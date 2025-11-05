import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/core/temp_data/custom_map_design.dart';
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

class TakerReachController extends GetxController {
  final DonateAcceptModel payload;
  final Completer<GoogleMapController> mapController;
  TakerReachController({required this.payload, required this.mapController});
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
  @override
  void onInit() {
    super.onInit();
    if (!mapController.isCompleted) {
      controllers = mapController;
    } else {
      controllers = Completer<GoogleMapController>();
    }

    toController.text = payload.location;
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final GoogleMapController controller = await controllers.future;

    circles.clear();
    circles.add(Circle(
      circleId: const CircleId('CurrentLocationCircle'),
      center: LatLng(position.latitude, position.longitude),
      radius: 120.0,
      fillColor: Colors.blue.withValues(alpha: 0.3),
      strokeColor: Colors.blue,
      strokeWidth: 10,
    ));

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        9.6,
      ),
    );

    fromController.text =
        "${position.latitude.toString()}, ${position.longitude.toString()}";
    update();
    await showPath(payload.donorEmail);
  }

  Future<void> goToCurrentLocation() async {
    await getCurrentLocation();
  }

  Future<void> showPath(String location) async {
    try {
      String from = payload.location;
      String? to = await getDonorCurrentLocation(location);

      // Fetch locations for 'from' and 'to'
      List<Location> fromLocations = await locationFromAddress(from);
      List<Location> toLocations = await locationFromAddress(to!);

      if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
        Location fromLocation = fromLocations.first;

        // Allow user to choose the correct destination from multiple results
        Location? toLocation = await _chooseLocation(toLocations);

        if (toLocation != null) {
          final GoogleMapController controller = await controllers.future;

          LatLng fromLatLng =
              LatLng(fromLocation.latitude, fromLocation.longitude);
          LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

          // Fetch the directions from Google Directions API
          String url =
              "https://maps.googleapis.com/maps/api/directions/json?origin=${fromLocation.latitude},${fromLocation.longitude}&destination=${toLocation.latitude},${toLocation.longitude}&key=AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI";

          var response = await http.get(Uri.parse(url));
          Map<String, dynamic> data = jsonDecode(response.body);

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            var route = data['routes'][0];
            var points = route['overview_polyline']['points'];
            var durationInSeconds =
                route['legs'][0]['duration']['value']; // in seconds
            // String durationText =
            //     route['legs'][0]['duration']['text']; // Readable format

            // Convert duration into hours, minutes, and seconds
            hours = 0;
            minutes = 0;
            seconds = 0;
            hours = durationInSeconds ~/ 3600;
            minutes = (durationInSeconds % 3600) ~/ 60;
            seconds = durationInSeconds % 60;

            List<LatLng> polylineCoordinates = _decodePolyline(points);

            polylines.clear();
            circles.clear();

            // Add polyline following the road
            polylines.add(Polyline(
              polylineId: const PolylineId('Path'),
              color: Colors.blue.shade500,
              width: 5,
              points: polylineCoordinates,
            ));

            // Add circles for the start and end points
            circles.add(Circle(
              circleId: const CircleId('CurrentLocationCircle'),
              center: fromLatLng,
              radius: 120.0,
              fillColor: Colors.blue.withValues(alpha: 0.3),
              strokeColor: Colors.blue,
              strokeWidth: 10,
            ));
            circles.add(Circle(
              circleId: const CircleId('DestinationCircle'),
              center: toLatLng,
              radius: 120.0,
              fillColor: Colors.green.withValues(alpha: 0.3),
              strokeColor: Colors.green,
              strokeWidth: 10,
            ));

            update();

            // Animate the camera to fit both points
            LatLngBounds bounds = LatLngBounds(
              southwest: LatLng(
                fromLocation.latitude < toLocation.latitude
                    ? fromLocation.latitude
                    : toLocation.latitude,
                fromLocation.longitude < toLocation.longitude
                    ? fromLocation.longitude
                    : toLocation.longitude,
              ),
              northeast: LatLng(
                fromLocation.latitude > toLocation.latitude
                    ? fromLocation.latitude
                    : toLocation.latitude,
                fromLocation.longitude > toLocation.longitude
                    ? fromLocation.longitude
                    : toLocation.longitude,
              ),
            );
            controller
                .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));

            double distance = await Geolocator.distanceBetween(
              fromLocation.latitude,
              fromLocation.longitude,
              toLocation.latitude,
              toLocation.longitude,
            );
            distanceInKm = 0.0;

            distanceInKm = distance / 1000;

            // Show distance and travel time in Snackbar
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //         'Distance: ${distanceInKm.toStringAsFixed(2)} km\nTime: ${hours}h ${minutes}m ${seconds}s'),
            //   ),
            // );
          } else {
            logError('No route found');
          }
        }
      }
    } catch (e) {
      logError("Error: $e");
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> polylineCoordinates = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int b;
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

      LatLng point = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polylineCoordinates.add(point);
    }
    return polylineCoordinates;
  }

  Future<Location?> _chooseLocation(List<Location> locations) async {
    // You can implement a UI to let the user choose the correct location
    // For simplicity, here we choose the first location from the list
    return locations.first;
  }

  Future<void> toggleMapMode() async {
    final GoogleMapController controller = await controllers.future;
    controller.setMapStyle(isLightMode ? null : darkMapStyle);
  }

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
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'custom_sound.wav',
                }
              }
            },
            'data': {'type': 'request_notification', 'id': 'Nomi12345'}
          }
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
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'custom_sound.wav',
                }
              }
            },
            'data': {'type': 'request_notification', 'id': 'Nomi12345'}
          }
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
          updateReceivedStatue(payload.email, payload.donorEmail);
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

  Future<void> updateReceivedStatue(
      String takerEmail, String donorEmail) async {
    try {
      return await _homeRepository.updateReceivedStatue(takerEmail, donorEmail);
    } catch (e) {
      Helper.handleError(e, 'Error while updating status!');
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
}
