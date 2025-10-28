import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/core/temp_data/custom_map_design.dart';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/dashboard/feeds/domain/feed_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapDonateController extends GetxController {
  final Map<String, dynamic> payload;
  final Completer<GoogleMapController> mapController;
  MapDonateController({required this.payload, required this.mapController});
  final FeedRepository _feedRepository = FeedRepository();
  Completer<GoogleMapController> controllers = Completer<GoogleMapController>();
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 10.0,
  );

  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  bool isLightMode = false;
  double shortdistance = 0.0;
  @override
  void onInit() {
    super.onInit();
    // logJSON(object: payload);
    if (!mapController.isCompleted) {
      controllers = mapController;
    } else {
      controllers = Completer<GoogleMapController>();
    }

    fromController.text = payload['location'];
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
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

      toController.text =
          "${position.latitude.toString()}, ${position.longitude.toString()}";
      update();

      await showPathOnMap(payload['location']);
    } catch (e) {
      logError("Error: $e");
    }
  }

  Future<void> showPathOnMap(String location) async {
    try {
      String from = location;
      String to = toController.text;

      // Fetch locations for 'from' and 'to'
      List<Location> fromLocations = await locationFromAddress(from);
      List<Location> toLocations = await locationFromAddress(to);

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
            var points = data['routes'][0]['overview_polyline']['points'];
            List<LatLng> polylineCoordinates = _decodePolyline(points);

            polylines.clear();
            circles.clear();

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

            double distanceInKm = distance / 1000;
            shortdistance = distanceInKm;

            Get.snackbar(
              "Success",
              "Distance: ${distanceInKm.toStringAsFixed(2)} km",
              snackPosition: SnackPosition.TOP,
              snackStyle: SnackStyle.FLOATING,
              backgroundColor: Colors.green.withValues(alpha: 0.9),
              colorText: Colors.white,
              margin: EdgeInsets.all(10),
              duration: Duration(seconds: 3),
              borderRadius: 8,
              icon: Icon(Icons.check_circle, color: Colors.white),
            );
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

  Future<void> goToCurrentLocation() async {
    getCurrentLocation();
  }

  Future<void> toggleMapMode() async {
    final GoogleMapController controller = await controllers.future;
    controller.setMapStyle(isLightMode ? null : darkMapStyle);
  }

  Future<bool> aceeptDonationRequest(Map<String, dynamic> payload) async {
    try {
      showLoader('adding request...');
      return await _feedRepository.aceeptDonationRequest(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while adding donation request!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> sendNotification(String email) async {
    try {
      return await _feedRepository.sendNotification(email);
    } catch (e) {
      Helper.handleError(e, 'Error while sending notification request!');
    } 
  }
}
