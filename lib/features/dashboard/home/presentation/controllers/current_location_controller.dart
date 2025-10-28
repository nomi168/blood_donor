import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/donor_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrentLocationController extends GetxController {
  final Completer<GoogleMapController> controllers = Completer();
  final HomeRepository _homeRepository = HomeRepository();
  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  Set<Marker> markers = {}; // ✅ added for vehicle marker
  StreamSubscription<Position>? positionStream;

  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  RxBool showDirections = false.obs;

  RxDouble distanceInKm = 0.0.obs;
  RxInt hours = 0.obs, minutes = 0.obs, seconds = 0.obs;

  final DonateAcceptModel model; // donor location (address)
  late LatLng donorLatLng;
  BitmapDescriptor? carIcon; // ✅ vehicle icon
  LatLng? lastPosition;
  DateTime? lastApiCallTime;
  bool donorReceived = false;

  CurrentLocationController({required this.model});

  @override
  void onInit() {
    super.onInit();
    _loadCarIcon();
    _initRoute();
  }

  Future<void> _loadCarIcon() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/png/gray.png', // ✅ Make sure you have this file in your assets folder
    );
  }

  Future<void> _initRoute() async {
    try {
      List<Location> donorLocations = await locationFromAddress(model.location);
      if (donorLocations.isEmpty) return;

      donorLatLng = LatLng(
        donorLocations.first.latitude,
        donorLocations.first.longitude,
      );

      await getCurrentLocation();
    } catch (e) {
      debugPrint("Error initializing route: $e");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Error", "Location permission permanently denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // List<Placemark> placemarks =
      //     await placemarkFromCoordinates(position.latitude, position.longitude);
      // if (placemarks.isNotEmpty) {
      //   final place = placemarks.first;
      //   sourceController.text =
      //       "${place.street}, ${place.locality}, ${place.country}";
      // }
      destinationController.text = model.location;

      final takerLatLng = LatLng(position.latitude, position.longitude);
      await showPath(takerLatLng);
      _startRealTimeTracking();
    } catch (e) {
      debugPrint("Error in getCurrentLocation: $e");
    }
  }

  Future<void> showPath(LatLng takerLatLng) async {
    try {
      await _updateRoute(takerLatLng, donorLatLng);

      circles
        ..clear()
        ..add(Circle(
          circleId: const CircleId('DestinationCircle'),
          center: donorLatLng,
          radius: 19,
          fillColor: Colors.green.withValues(alpha: .3),
          strokeColor: Colors.green,
          strokeWidth: 4,
        ));

      // ✅ Add vehicle marker
      markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('vehicle'),
          position: takerLatLng,
          icon: carIcon ?? BitmapDescriptor.defaultMarker,
          rotation: 0,
          anchor: const Offset(0.5, 0.5),
        ));

      final GoogleMapController mapController = await controllers.future;
      mapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            min(takerLatLng.latitude, donorLatLng.latitude),
            min(takerLatLng.longitude, donorLatLng.longitude),
          ),
          northeast: LatLng(
            max(takerLatLng.latitude, donorLatLng.latitude),
            max(takerLatLng.longitude, donorLatLng.longitude),
          ),
        ),
        80,
      ));

      update();
    } catch (e) {
      debugPrint("Error in showPath: $e");
    }
  }

  void _startRealTimeTracking() async {
    positionStream?.cancel();

    // ✅ Ensure carIcon is ready
    if (carIcon == null) await _loadCarIcon();

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 3,
      ),
    ).listen((Position position) async {
      LatLng takerLatLng = LatLng(position.latitude, position.longitude);
      final GoogleMapController mapController = await controllers.future;

      // ✅ Calculate bearing for smooth rotation
      double bearing = _calculateBearing(
        lastPosition?.latitude ?? takerLatLng.latitude,
        lastPosition?.longitude ?? takerLatLng.longitude,
        takerLatLng.latitude,
        takerLatLng.longitude,
      );
      lastPosition = takerLatLng;

      // ✅ Update vehicle marker
      markers.removeWhere((m) => m.markerId.value == 'vehicle');
      markers.add(Marker(
        markerId: const MarkerId('vehicle'),
        position: takerLatLng,
        rotation: bearing,
        icon: carIcon!,
        anchor: const Offset(0.5, 0.5),
      ));

      update(); // ✅ refresh markers immediately

      // ✅ Smooth camera follow
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: takerLatLng, zoom: 17, bearing: bearing),
        ),
      );

      // ✅ Calculate distance (live)
      double distance = Geolocator.distanceBetween(
        takerLatLng.latitude,
        takerLatLng.longitude,
        donorLatLng.latitude,
        donorLatLng.longitude,
      );

      distanceInKm.value = distance / 1000;

      if (distanceInKm.value < 0.10) {
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isReceived = await prefs.getBool('ID_${model.id}') ?? false;
        if (isReceived) {
          DonorLocationController.to.isReceived = isReceived;
        } else {
          await prefs.setBool('ID_${model.id}', true);
        }
        update();
        return;
      }
      final now = DateTime.now();
      if (lastApiCallTime == null ||
          now.difference(lastApiCallTime!).inSeconds >= 10) {
        Map<String, dynamic> payload = {
          'taker_email': model.email,
          'donor_email': model.donorEmail,
          'id': model.id,
          'latitude': takerLatLng.latitude,
          'longitude': takerLatLng.longitude
        };
        await sendLocationToApi(payload);
        await changeCurrentAvailability();
        lastApiCallTime = now;
      }

      await _updateRoute(takerLatLng, donorLatLng);
      update();
    });
  }

  Future<void> changeCurrentAvailability() async {
    if (distanceInKm.value > 0.10) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('ID_${model.id}');

      DonorLocationController.to.isReceived = false;
      update();
    }
  }

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  Future<void> _updateRoute(LatLng from, LatLng to) async {
    try {
      const apiKey = "AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI";
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['routes'] == null || data['routes'].isEmpty) return;

      final route = data['routes'][0];
      final points = route['overview_polyline']['points'];
      final durationInSeconds = route['legs'][0]['duration']['value'];

      hours.value = durationInSeconds ~/ 3600;
      minutes.value = (durationInSeconds % 3600) ~/ 60;
      seconds.value = durationInSeconds % 60;

      final polylineCoordinates = _decodePolyline(points);
      polylines
        ..clear()
        ..add(Polyline(
          polylineId: const PolylineId('DynamicPath'),
          color: Colors.redAccent,
          width: 5,
          points: polylineCoordinates,
        ));
      update();
    } catch (e) {
      debugPrint("Route update failed: $e");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> coordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return coordinates;
  }

  Future<void> sendLocationToApi(Map<String, dynamic> paylod) async {
    try {
      return await _homeRepository.sendLocationToApi(paylod);
    } catch (e) {
      Helper.handleError(e, 'Error while adding location!');
      return null;
    }
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }
}
