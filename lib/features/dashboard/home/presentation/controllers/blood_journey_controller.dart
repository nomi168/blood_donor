import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/core/temp_data/custom_map_design.dart';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class BloodJourneyController extends GetxController {
  final DonateAcceptModel payload;
  final Completer<GoogleMapController> mapController;
  BloodJourneyController({required this.payload, required this.mapController});
  final HomeRepository _homeRepository = HomeRepository();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController review = TextEditingController();

  Completer<GoogleMapController> controllers = Completer<GoogleMapController>();

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 10.0,
  );

  Set<Circle> circles = {};
  Set<Polyline> polylines = {};
  bool isLightMode = false;

  @override
  void onInit() {
    super.onInit();
    if (!mapController.isCompleted) {
      controllers = mapController;
    } else {
      controllers = Completer<GoogleMapController>();
    }

    toController.text = payload.location;
    _getCurrentLocation();
  }

  Future<void> toggleMapMode() async {
    final GoogleMapController controller = await controllers.future;
    controller.setMapStyle(isLightMode ? null : darkMapStyle);
  }

  Future<void> _getCurrentLocation() async {
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

      fromController.text =
          "${position.latitude.toString()}, ${position.longitude.toString()}";
      update();
      await showPathOnMap(payload.location);
    } catch (e) {
      // ignore: avoid_print
      logError("Error: $e");
    }
  }

  Future<void> goToCurrentLocation() async {
    _getCurrentLocation();
  }

  Future<void> showPathOnMap(String location) async {
    try {
      String from = fromController.text;
      String to = location;

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

            // Clear previous polylines and circles
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
            update();
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

  Future<bool> deleteAcceptedRequest(dynamic payload) async {
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

  Future<bool> getReceivedStatus(Map<String,dynamic> payload) async {
    try {
      showLoader('checking status...');
      return await _homeRepository.getReceivedStatus(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while checking status!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> updateTakerReceivedStatue(
      String takerEmail, String donorEmail) async {
    try {
      return await _homeRepository.updateTakerReceivedStatue(
          takerEmail, donorEmail);
    } catch (e) {
      Helper.handleError(e, 'Error while updating status!');
    }
  }
}
