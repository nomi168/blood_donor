import 'dart:async';

import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostRequestController extends GetxController {
  static PostRequestController get to => Get.find();
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController hospital = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController blood = TextEditingController();
  TextEditingController unit = TextEditingController();

  List<String> bloodType = ['blood', 'platelets'];
  String selectedBlood = '';

  bool isToggled = false;
  bool isTerm = false;
  String selectedValue = 'normal';

  @override
  void onInit() {
    super.onInit();
    donorOnMap();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      update();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      update();
    }
  }

  Future<void> donorOnMap() async {
    try {
      // Fetch all donor locations from Firestore

      Set<Marker> newMarkers = {};

      // Get taker location from the widget
      List<String> extraLocations = [UserController.to.userModel!.location];

      for (String extraLocation in extraLocations) {
        List<Location> locations = await locationFromAddress(extraLocation);
        if (locations.isNotEmpty) {
          Location loc = locations.first;

          // Add marker for taker location
          newMarkers.add(Marker(
            markerId: MarkerId(extraLocation),
            position: LatLng(loc.latitude, loc.longitude),
            infoWindow: InfoWindow(title: extraLocation),
          ));

          // Animate camera to the taker location
          final GoogleMapController controllers = await controller.future;
          controllers.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(loc.latitude, loc.longitude),
              10.0, // Adjust zoom level as needed
            ),
          );
        }
      }

      update();

      logSuccess('Nearby donors saved to file.');
    } catch (e) {
      logError(e.toString());
    }
  }
}
