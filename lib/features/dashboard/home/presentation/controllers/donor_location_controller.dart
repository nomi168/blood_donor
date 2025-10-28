import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DonorLocationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final DonateAcceptModel payload;
  final Completer<GoogleMapController> mapController;
  DonorLocationController({required this.payload, required this.mapController});
  static DonorLocationController get to => Get.find();
  final HomeRepository _homeRepository = HomeRepository();
  Completer<GoogleMapController> controllers = Completer<GoogleMapController>();
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Example: San Francisco
    zoom: 10.0,
  );

  TextEditingController fromController = TextEditingController();

  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  bool isReceived = false;
  // bool isNextProcess = false;
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
  late AnimationController animationController;
  late Animation<Color?> colorAnimation;
  int tapCount = 0;
  int tapCountReceived = 0;
  var isNextProcess = false.obs;
  StreamSubscription? nextProcessSub;
  @override
  Future<void> onInit() async {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    colorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.green.withValues(alpha: .3),
    ).animate(animationController);
    if (!mapController.isCompleted) {
      controllers = mapController;
    } else {
      controllers = Completer<GoogleMapController>();
    }
    await showPath(payload.location);

    // getCurrentLocation();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    animationController.dispose();
    nextProcessSub?.cancel();
    super.onClose();
  }

  Future<void> checkIsNextProcessData() async {
    bool response = await checkIsNextProcess(payload.id);
    if (response) {
      isNextProcess.value = true;
      update();
    }
  }

  Future<void> changeCurrentAvailabilities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.getBool('ID_${payload.id}') ?? false;
    if (result) {
      tapCountReceived = 2;
      update();
    }
  }

  void startListeningToNextProcess(String id) {
    nextProcessSub = checkIsNextProcessRealTime(id).listen((value) {
      isNextProcess.value = value;
    });
    update();
  }

  Future<void> showPath(String takerAddress) async {
    try {
      String location = "";
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      const apiKey = "AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI";
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        location = data['results'][0]['formatted_address'];
      }

      List<Location> donorLocations = await locationFromAddress(location);
      List<Location> takerLocations = await locationFromAddress(takerAddress);

      if (donorLocations.isEmpty || takerLocations.isEmpty) {
        debugPrint("No location found for one of the addresses");
        return;
      }

      Location donor = donorLocations.first;
      Location taker = takerLocations.first;

      LatLng donorLatLng = LatLng(donor.latitude, donor.longitude);
      LatLng takerLatLng = LatLng(taker.latitude, taker.longitude);

      await _updateRoute(takerLatLng, donorLatLng);

      circles.clear();
      circles.add(Circle(
        circleId: const CircleId('CurrentLocationCircle'),
        center: takerLatLng,
        radius: 19,
        fillColor: Colors.blue.withValues(alpha: .3),
        strokeColor: Colors.blue,
        strokeWidth: 3,
      ));
      circles.add(Circle(
        circleId: const CircleId('DestinationCircle'),
        center: donorLatLng,
        radius: 20,
        fillColor: Colors.green.withValues(alpha: .3),
        strokeColor: Colors.green,
        strokeWidth: 3,
      ));

      update();

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
      // mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
      await checkIsNextProcessData();

      // Start real-time tracking after initial route setup
      _startRealTimeTracking(donorLatLng);
    } catch (e) {
      debugPrint("Error in showPath: $e");
    }
  }

  /// Start live tracking of the taker's movement
  void _startRealTimeTracking(LatLng donorLatLng) async {
    positionStream?.cancel();

    // ✅ Cache the controller once outside the stream
    final GoogleMapController controller1 = await controllers.future;

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3, // more frequent updates
      ),
    ).listen((Position position) async {
      final LatLng takerLatLng = LatLng(position.latitude, position.longitude);

      // ✅ Ensure coordinates are valid numbers
      if (takerLatLng.latitude == 0.0 && takerLatLng.longitude == 0.0) return;

      // Update taker circle
      circles.removeWhere((c) => c.circleId.value == 'CurrentLocationCircle');
      circles.add(Circle(
        circleId: const CircleId('CurrentLocationCircle'),
        center: takerLatLng,
        radius: 100,
        fillColor: Colors.blue.withValues(alpha: .3),
        strokeColor: Colors.blue,
        strokeWidth: 6,
      ));

      // Smooth camera follow
      controller1.animateCamera(CameraUpdate.newLatLng(takerLatLng));

      // ✅ Calculate precise distance
      // double distanceInMeters = Geolocator.distanceBetween(
      //   takerLatLng.latitude,
      //   takerLatLng.longitude,
      //   donorLatLng.latitude,
      //   donorLatLng.longitude,
      // );

      // distanceInKm = distanceInMeters / 1000;

      // ✅ Debug log to confirm correctness
      logSuccess(
          "Distance between Taker (${takerLatLng.latitude},${takerLatLng.longitude}) and Donor (${donorLatLng.latitude},${donorLatLng.longitude}) = ${distanceInKm.toStringAsFixed(3)} km");

      // ✅ Arrived condition
      if (distanceInKm < 0.10) {
        positionStream?.cancel();
        Get.snackbar(
          "Arrived",
          "You have reached the donor location!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
          borderRadius: 8,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        final prefs = await SharedPreferences.getInstance();
        bool isReceive = prefs.getBool('ID_${payload.id}') ?? false;
        if (isReceive) {
          isReceived = isReceive;
        } else {
          await prefs.setBool('ID_${payload.id}', true);
        }

        update();
        await changeCurrentAvailabilities();
        return;
      }

      // ✅ Only refresh route occasionally
      await changeCurrentAvailability();
      // await _updateRoute(takerLatLng, donorLatLng);

      update();
    });
  }

  Future<void> changeCurrentAvailability() async {
    if (distanceInKm > 0.10) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('ID_${payload.id}');
      DonorLocationController.to.isReceived = false;
      update();
    }
  }

  /// Update the route dynamically with duration and path
  Future<void> _updateRoute(LatLng from, LatLng to) async {
    try {
      const String apiKey = "AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI";
      String url = "https://maps.googleapis.com/maps/api/directions/json?"
          "origin=${from.latitude},${from.longitude}"
          "&destination=${to.latitude},${to.longitude}"
          "&key=$apiKey";

      var response = await http.get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        var route = data['routes'][0];

        // ✅ Safely check for legs
        if (route['legs'] == null || route['legs'].isEmpty) {
          debugPrint("⚠️ No legs found in route");
          return;
        }

        final durationInSeconds = route['legs'][0]['duration']['value'];
        var leg = route['legs'][0];
        var points = route['overview_polyline']['points'];

        // ✅ Get duration and distance correctly
        // var durationInSeconds = leg['duration']?['value'] ?? 0;
        var distanceInMeters = leg['distance']?['value'] ?? 0;

        hours = durationInSeconds ~/ 3600;
        minutes = (durationInSeconds % 3600) ~/ 60;
        seconds = durationInSeconds % 60;
        distanceInKm = distanceInMeters / 1000;

        final polylineCoordinates = _decodePolyline(points);

        polylines.clear();
        polylines.add(Polyline(
          polylineId: const PolylineId('DynamicPath'),
          color: Colors.blue.shade600,
          width: 6,
          points: polylineCoordinates,
        ));

        debugPrint(
            "✅ Route updated successfully: ${distanceInKm.toStringAsFixed(2)} km, ETA: ${hours}h ${minutes}m ${seconds}s");
        update();
      } else {
        debugPrint("⚠️ No routes found between points.");
      }
    } catch (e) {
      debugPrint("❌ Route update failed: $e");
    }
  }

  /// Decode Google Maps polyline points
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

  // Future<void> getCurrentLocation() async {
  //   try {
  //     // 1️⃣ Get the current GPS position of the taker
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     final GoogleMapController controller = await controllers.future;

  //     // 2️⃣ Convert latitude/longitude to a readable address
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );

  //     String readableAddress = "Unknown location";
  //     if (placemarks.isNotEmpty) {
  //       final place = placemarks.first;
  //       readableAddress =
  //           "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  //     }

  //     // 3️⃣ Update the map circle for the taker’s current position
  //     circles.clear();
  //     circles.add(Circle(
  //       circleId: const CircleId('CurrentLocationCircle'),
  //       center: LatLng(position.latitude, position.longitude),
  //       radius: 40.0,
  //       fillColor: Colors.blue.withValues(alpha: 0.3),
  //       strokeColor: Colors.blue,
  //       strokeWidth: 10,
  //     ));

  //     // 4️⃣ Animate map camera to the current location
  //     controller.animateCamera(
  //       CameraUpdate.newLatLngZoom(
  //         LatLng(position.latitude, position.longitude),
  //         14.5,
  //       ),
  //     );

  //     // 5️⃣ Set the English-readable address in your text controller
  //     fromController.text = readableAddress;

  //     update();

  //     // 6️⃣ Call your route function with this address
  //     await showPath(payload.donorEmail);
  //   } catch (e) {
  //     debugPrint("Error getting current location: $e");
  //   }
  // }

  // Future<void> goToCurrentLocation() async {
  //   await getCurrentLocation();
  // }

  Future<bool> sendNotificationToDonor(
      String email, int hours, int minutes, int seconds) async {
    try {
      showLoader('please wait...');
      String projectId = 'blood-app-8f4c2';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // If no users found, return false
      if (querySnapshot.docs.isEmpty) {
        logError("No user found with email: $email");
        return false;
      }

      // Iterate over each user document
      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        // Get the device token and name from the user document
        String firstName = userDoc['firstname'];
        String lastName = userDoc['lastname'];
        String name = "$firstName $lastName";

        String deviceToken = userDoc['deviceToken'];

        logSuccess("Device Token: $deviceToken");

        var data = {
          'message': {
            'token': deviceToken,
            'notification': {
              'title': 'Blood Request',
              'body':
                  'Hello $name I am on my way and will arrive in ${hours > 0 ? "$hours hours, " : ""}${minutes > 0 ? "$minutes minutes, " : ""}${seconds > 0 ? "$seconds seconds" : ""}.',
            },
            'android': {
              'priority': 'HIGH', // ✅ Correct place for priority
              'notification': {
                'sound': 'custom_sound', // ✅ Do NOT include .wav extension
                'default_vibrate_timings': true,
                'icon': 'ic_blood_request', // Optional custom icon name
                'color': '#DE0A1E',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'custom_sound.wav',
                  'alert': {
                    'title': 'Blood Request',
                    'body':
                        'Hello $name I am on my way and will arrive in ${hours > 0 ? "$hours hours, " : ""}${minutes > 0 ? "$minutes minutes, " : ""}${seconds > 0 ? "$seconds seconds" : ""}.',
                  },
                },
              },
            },
            'data': {
              'type': 'request_notification',
              'id': 'Nomi12345',
            },
          },
        };

        // Generate OAuth2 token using service account
        var jsonString = await rootBundle.loadString('images/json/key1.json');
        var clientCredentials =
            auth.ServiceAccountCredentials.fromJson(jsonString);
        var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
        var client =
            await auth.clientViaServiceAccount(clientCredentials, scopes);

        var response = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
          headers: {
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        // Check response status
        if (response.statusCode == 200) {
          logSuccess('Notification sent successfully to user: $name');
          return true;
        } else {
          logError(
              'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
          logError('Response body: ${response.body}');
        }
      }
    } catch (e) {
      logError('Error sending notification: $e');
    } finally {
      await EasyLoading.dismiss();
    }

    // Ensure function always returns a value
    return false;
  }

  Future<bool> sendNotificationToDonorReached(String email) async {
    try {
      showLoader('please wait...');
      String projectId = 'blood-app-8f4c2';

      // Fetch all users from Firestore who are donors
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // If no users found, return false
      if (querySnapshot.docs.isEmpty) {
        logError("No user found with email: $email");
        return false;
      }

      // Iterate over each user document
      for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
        // Get the device token and name from the user document
        String firstName = userDoc['firstname'];
        String lastName = userDoc['lastname'];
        String name = "$firstName $lastName";

        String deviceToken = userDoc['deviceToken'];

        var data = {
          'message': {
            'token': deviceToken,
            'notification': {
              'title': 'Blood Request',
              'body': 'Hello $name I am reached on your location.',
            },
            'android': {
              'priority': 'HIGH', // ✅ Correct place for priority
              'notification': {
                'sound': 'custom_sound', // ✅ Do NOT include .wav extension
                'default_vibrate_timings': true,
                'icon': 'ic_blood_request', // Optional custom icon name
                'color': '#DE0A1E',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'custom_sound.wav',
                  'alert': {
                    'title': 'Blood Request',
                    'body': 'Hello $name I am reached on your location.',
                  },
                },
              },
            },
            'data': {
              'type': 'request_notification',
              'id': 'Nomi12345',
            },
          },
        };

        // var data = {
        //   'message': {
        //     'token': deviceToken,
        //     'notification': {
        //       'title': 'Blood Request',
        //       'body': 'Hello $name I am reached on your location.',
        //     },
        //     'apns': {
        //       'payload': {
        //         'aps': {
        //           'sound': 'custom_sound.wav',
        //         }
        //       }
        //     },
        //     'data': {'type': 'request_notification', 'id': 'Nomi12345'}
        //   }
        // };

        // Generate OAuth2 token using service account
        var jsonString = await rootBundle.loadString('images/json/key1.json');
        var clientCredentials =
            auth.ServiceAccountCredentials.fromJson(jsonString);
        var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
        var client =
            await auth.clientViaServiceAccount(clientCredentials, scopes);

        var response = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
          headers: {
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        // Check response status
        if (response.statusCode == 200) {
          return true;
        } else {
          logError('Response body: ${response.body}');
        }
      }
    } catch (e) {
      logError('Error sending notification: $e');
    } finally {
      await EasyLoading.dismiss();
    }

    // Ensure function always returns a value
    return false;
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

  Future<bool> deleteAcceptedRequest(Map<String, dynamic> payload) async {
    try {
      showLoader('deleted request...');
      return await _homeRepository.deleteAcceptedRequest(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while deleting request!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> checkIsNextProcess(String id) async {
    try {
      return await _homeRepository.checkIsNextProcess(id);
    } catch (e) {
      Helper.handleError(e, 'Error while checking data!');
      return false;
    }
  }

  Stream<bool> checkIsNextProcessRealTime(String id) {
    try {
      return _homeRepository.checkIsNextProcessRealTime(id);
    } catch (e) {
      Helper.handleError(e, 'Error while checking data!');
      return Stream.value(false);
    }
  }
}
