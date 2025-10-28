import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/post_blood/data/models/user_location_model.dart';
import 'package:blood_donor/features/dashboard/post_blood/domain/repository_post_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PostRequestController extends GetxController {
  final String bloodgroup;
  PostRequestController({required this.bloodgroup});
  static PostRequestController get to => Get.find();
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  final RepositoryPostRequest _postRequest = RepositoryPostRequest();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController hospital = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController blood = TextEditingController();
  TextEditingController unit = TextEditingController();

  List<String> bloodType = ['Blood', 'Platelets', 'Exchange Blood'];
  List<String> bloodGroups = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];

  String selectedBlood = '';

  bool isToggled = false;
  bool isTerm = false;
  String selectedValue = 'normal';
  bool isEmergencyHelp = false;
  bool isLoading = false;
  File? selectedImage;
  List<UserModel> userList = [];
  List<UserLocationModel> userLocationList = [];
  List<UserLocationModel> filteredList = [];

  @override
  void onInit() {
    if (bloodgroup.isNotEmpty) {
      blood.text = bloodgroup;
    }
    super.onInit();
    donorOnMap();
  }

  Future<void> getUserList(String blood) async {
    userList.clear();
    userList = await getUserData(blood);
    update();
  }

  Future<void> getUserLocationList() async {
    try {
      showLoader('please wait...');
      userLocationList.clear();
      userLocationList = await getDonorLocations();
      for (var location in userLocationList) {
        for (var data in userList) {
          if (data.id == location.userId) {
            filteredList.add(location);
          }
        }
      }
      filteredList;
    } catch (e) {
    } finally {
      await EasyLoading.dismiss();
    }

    update();
  }

  Future<void> getCurrentAddress() async {
    try {
      isLoading = true;
      update();

      // Request permission if not granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Error",
            "Location permission denied",
            snackPosition: SnackPosition.TOP,
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: Colors.red.withValues(alpha: 0.9),
            colorText: Colors.white,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 3),
            borderRadius: 8,
            icon: Icon(Icons.error, color: Colors.white),
          );

          isLoading = false;
          update();

          return;
        }
      }

      String locations = "";
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      const apiKey = "AIzaSyAn6fh8krl1H-wflk6gHJ2aWoFEGAuaseI";
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        locations = data['results'][0]['formatted_address'];
      }
      if (locations.isNotEmpty) {
        location.text = locations;
      } else {
        location.text = "Address not found";
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Location permission denied",
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        borderRadius: 8,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading = false;
      update();
    }
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

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
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

  Future<List<UserModel>> getUserData(String blood) async {
    try {
      showLoader('please wait...');
      return await _postRequest.getUserData(blood);
    } catch (e) {
      Helper.handleError(e, 'Error while getting user data!');
      return [];
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<List<UserLocationModel>> getDonorLocations() async {
    try {
      showLoader('please wait...');
      return await _postRequest.getDonorLocations();
    } catch (e) {
      Helper.handleError(e, 'Error while getting user data!');
      return [];
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
