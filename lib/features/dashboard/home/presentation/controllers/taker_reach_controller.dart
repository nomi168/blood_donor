import 'dart:async';
import 'dart:convert';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_update_location_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/taker_anaylsis_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

class TakerReachController extends GetxController {
  final DonateAcceptModel payload;
  final Completer<GoogleMapController> mapController;
  final String donorLocation;
  TakerReachController(
      {required this.payload,
      required this.mapController,
      required this.donorLocation});
  final HomeRepository _homeRepository = HomeRepository();
  Completer<GoogleMapController> controllers = Completer<GoogleMapController>();
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Example: San Francisco
    zoom: 10.0,
  );

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  bool isLightMode = false;

  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  bool isReceived = false;
  double shortdistance = 0.0;

  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  double distanceInKm = 0.0;
  StreamSubscription<Position>? positionStream;
  var totalDistance = ''.obs;
  var totalDuration = ''.obs;
  var isTrafficEnabled = true.obs;
  var isNavigating = false.obs;
  Stream<LocationUpdateModel?>? locationUpdateStream;
  StreamSubscription<LocationUpdateModel?>? locationUpdateSubscription;
  LocationUpdateModel? locationUpdateModel;
  @override
  Future<void> onInit() async {
    super.onInit();
    if (!mapController.isCompleted) {
      controllers = mapController;
    } else {
      controllers = Completer<GoogleMapController>();
    }

    await showPath(donorLocation);
    // getCurrentLocation();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }

  // Stream<void> streamDonorUpdateLocationModel() {
  //   locationUpdateStream = streamDonorUpdateLocation(payload.id);
  //   update();
  //   return locationUpdateStream!;
  // }
  Stream<void> streamDonorUpdateLocationModel(String donorId) {
    locationUpdateStream = streamDonorUpdateLocation(donorId);

    locationUpdateSubscription?.cancel();
    locationUpdateSubscription = locationUpdateStream!.listen((data) {
      locationUpdateModel = data;
      if (data != null) {
        // Update donor location in real time
        LatLng donorLatLng = LatLng(data.latitude, data.longitude);
        _updateDonorMarker(donorLatLng);
      }
      update();
    });

    return locationUpdateStream!.map((_) {});
  }

  /// Update donor marker and route when donor location changes
  Future<void> _updateDonorMarker(LatLng donorLatLng) async {
    if (circles.any((c) => c.circleId.value == 'DestinationCircle')) {
      circles.removeWhere((c) => c.circleId.value == 'DestinationCircle');
    }

    circles.add(Circle(
      circleId: const CircleId('DestinationCircle'),
      center: donorLatLng,
      radius: 20,
      fillColor: Colors.green.withValues(alpha: .3),
      strokeColor: Colors.green,
      strokeWidth: 6,
    ));

    // If taker already has a circle, update the path between them
    final takerCircle = circles
        .firstWhereOrNull((c) => c.circleId.value == 'CurrentLocationCircle');
    if (takerCircle != null) {
      await _updateRoute(takerCircle.center, donorLatLng);
    }

    update();
  }

  Future<void> showPath(String donorAddress) async {
    try {
    

      List<Location> donorLocations = await locationFromAddress(donorAddress);
      if (donorLocations.isEmpty) {
        debugPrint("No donor location found");
        return;
      }
      List<Location> takerLocations =
          await locationFromAddress(payload.location);
      if (takerLocations.isEmpty) {
        debugPrint("No taker location found");
        return;
      }

      LatLng donorLatLng = LatLng(
        donorLocations.first.latitude,
        donorLocations.first.longitude,
      );
      LatLng takerLatLng =
          LatLng(takerLocations.first.latitude, takerLocations.first.longitude);

      await _updateRoute(takerLatLng, donorLatLng);

      circles.clear();
      circles.add(Circle(
        circleId: const CircleId('CurrentLocationCircle'),
        center: takerLatLng,
        radius: 15,
        fillColor: Colors.blue.withValues(alpha: .3),
        strokeColor: Colors.blue,
        strokeWidth: 6,
      ));
      circles.add(Circle(
        circleId: const CircleId('DestinationCircle'),
        center: donorLatLng,
        radius: 15,
        fillColor: Colors.green.withValues(alpha: .3),
        strokeColor: Colors.green,
        strokeWidth: 6,
      ));

      update();

      final GoogleMapController mapController = await controllers.future;
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          takerLatLng.latitude < donorLatLng.latitude
              ? takerLatLng.latitude
              : donorLatLng.latitude,
          takerLatLng.longitude < donorLatLng.longitude
              ? takerLatLng.longitude
              : donorLatLng.longitude,
        ),
        northeast: LatLng(
          takerLatLng.latitude > donorLatLng.latitude
              ? takerLatLng.latitude
              : donorLatLng.latitude,
          takerLatLng.longitude > donorLatLng.longitude
              ? takerLatLng.longitude
              : donorLatLng.longitude,
        ),
      );
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));

      _startRealTimeTracking(donorLatLng);
    } catch (e) {
      debugPrint("Error in showPath: $e");
    }
  }

  /// Start live tracking of the taker's movement
  void _startRealTimeTracking(LatLng donorLatLng) async {
    positionStream?.cancel();

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) async {
      LatLng takerLatLng = LatLng(position.latitude, position.longitude);

      circles.removeWhere((c) => c.circleId.value == 'CurrentLocationCircle');
      circles.add(Circle(
        circleId: const CircleId('CurrentLocationCircle'),
        center: takerLatLng,
        radius: 100,
        fillColor: Colors.blue.withValues(alpha: .3),
        strokeColor: Colors.blue,
        strokeWidth: 6,
      ));

      final GoogleMapController controller = await controllers.future;
      controller.animateCamera(CameraUpdate.newLatLng(takerLatLng));

      double distance = await Geolocator.distanceBetween(
        takerLatLng.latitude,
        takerLatLng.longitude,
        donorLatLng.latitude,
        donorLatLng.longitude,
      );

      distanceInKm = distance / 1000;

      if (distanceInKm < 0.10) {
        positionStream?.cancel();
        Get.snackbar(
          "Arrived",
          "You have reached the donor location!",
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          borderRadius: 8,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );

        TakerAnaylsisController.to.isReceived = true;
        update();
        return;
      }

      await _updateRoute(takerLatLng, donorLatLng);
      update();
    });
  }

  Future<void> _updateRoute(LatLng from, LatLng to) async {
    try {
      const String apiKey = "AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI";
      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&key=$apiKey";

      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        var route = data['routes'][0];
        var points = route['overview_polyline']['points'];
        var durationInSeconds = route['legs'][0]['duration']['value'];

        hours = durationInSeconds ~/ 3600;
        minutes = (durationInSeconds % 3600) ~/ 60;
        seconds = durationInSeconds % 60;

        List<LatLng> polylineCoordinates = _decodePolyline(points);

        polylines.clear();
        polylines.add(Polyline(
          polylineId: const PolylineId('DynamicPath'),
          color: Colors.blue.shade600,
          width: 6,
          points: polylineCoordinates,
        ));
      }
    } catch (e) {
      debugPrint("Route update failed: $e");
    }
  }

  /// Decode polyline
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0, b;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylineCoordinates;
  }

  Future<void> getCurrentLocation() async {
    try {
      // 1️⃣ Get the current GPS position of the taker
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final GoogleMapController controller = await controllers.future;

      // 2️⃣ Convert latitude/longitude to a readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String readableAddress = "Unknown location";
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        readableAddress =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }

      // 3️⃣ Update the map circle for the taker’s current position
      circles.clear();
      circles.add(Circle(
        circleId: const CircleId('CurrentLocationCircle'),
        center: LatLng(position.latitude, position.longitude),
        radius: 120.0,
        fillColor: Colors.blue.withValues(alpha: 0.3),
        strokeColor: Colors.blue,
        strokeWidth: 10,
      ));

      // 4️⃣ Animate map camera to the current location
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14.5,
        ),
      );

      // 5️⃣ Set the English-readable address in your text controller
      fromController.text = readableAddress;

      update();

      // 6️⃣ Call your route function with this address
      await showPath(payload.donorEmail);
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }

  Future<void> goToCurrentLocation() async {
    await getCurrentLocation();
  }

  Future<String?> getDonorCurrentLocation(String donorEmail) async {
    try {
      return await _homeRepository.getDonorCurrentLocation(donorEmail);
    } catch (e) {
      Helper.handleError(e, 'Error while getting location!');
      return null;
    }
  }

  Future<bool> getTakerReceivedStatus(String email, String donorEmall) async {
    try {
      showLoader('checking status...');
      return await _homeRepository.getTakerReceivedStatus(email, donorEmall);
    } catch (e) {
      Helper.handleError(e, 'Error while checking status!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Stream<LocationUpdateModel?>? streamDonorUpdateLocation(String id) {
    try {
      return _homeRepository.streamDonorUpdateLocation(id);
    } catch (e) {
      Helper.handleError(e, 'Error while updating status!');
      return null;
    }
  }
}
