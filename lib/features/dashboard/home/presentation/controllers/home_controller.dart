import 'dart:async';

import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/notification.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository();
  final Completer<GoogleMapController> controllers =
      Completer<GoogleMapController>();
  NotificationServices notificationServices = NotificationServices();
  ScrollController scrollController = ScrollController();

  Set<Circle> circles = {};
  List<FeedTakerModel> takerList = [];
  List<DonateAcceptModel> donorList = [];
  List<DonateAcceptModel> seeList = [];

  List<String> bloodGroups = [
    'A+',
    'B+',
    'O+',
    'AB+',
    'A-',
    'B-',
    'O-',
    'AB-',
  ];
  final List<String> imagesBannerList = [
    'images/Banners/2.jpeg',
    'images/Banners/3.jpeg',
    'images/Banners/4.jpg',
    'images/Banners/5.jpg',
    'images/Banners/banner_app.jpg'
  ];

  String selectedBloodGroup = '';
  int currentIndex = 0;
  bool isLoading = false;
  bool? isAvailability;

  @override
  void onInit() {
    final user = UserController.to.userModel;
    if (user != null) {
      if (user.type == 'donor') {
        getInitDonorData();
      } else {
        getInitTakerData();
      }
    }
    getNotificationToken();

    super.onInit();
  }

  Future<void> getTakerListByBlood() async {
    takerList.clear();
    isLoading = true;
    update();
    takerList = await getTakersList();
    isLoading = false;
    update();
  }

  Future<void> getAcceptanceDonorList() async {
    donorList.clear();
    donorList = await getAcceptanceDonor();
    update();
  }

  Future<void> seeTakerAcceptanceList() async {
    seeList.clear();
    seeList = await seeTakerAcceptanceData();
    update();
  }

  Future<void> getInitDonorData() async {
    getCurrentLocation();
    await getTakerListByBlood();
    await getavailableDonor(UserController.to.userModel!.email);
    await getAcceptanceDonorList();
    await checkAvailabilityDonor();
    await deleteExpiredRequests();
  }

  Future<void> getInitTakerData() async {
    await seeTakerAcceptanceList();
  }

  Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Are you sure you want to exit the application?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> getNotificationToken() async {
    String token1 = await notificationServices.getDeviceToken();
    if (token1 != UserController.to.userModel!.deviceToken) {
      await updateFCMToken(UserController.to.userModel!.id, token1);
      UserController.to.onInit();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      String address =
          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      updateDonorLocation(address, UserController.to.userModel!.id);

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

      // fromController.text = address;
      update();
    } catch (e) {
      logError("Error: $e");
    }
  }

  Future<List<FeedTakerModel>> getTakersList() async {
    try {
      return await _homeRepository.getTakersList();
    } catch (e) {
      Helper.handleError(e, 'Error while getting taker list!');
      return [];
    }
  }

  Future<void> updateDonorLocation(String location, String userID) async {
    try {
      return await _homeRepository.updateDonorLocation(location, userID);
    } catch (e) {
      Helper.handleError(e, 'Error while updating location!');
    }
  }

  Future<void> updateFCMToken(String userId, String token) async {
    try {
      return await _homeRepository.updateFCMToken(userId, token);
    } catch (e) {
      Helper.handleError(e, 'Error while updating FCM token!');
    }
  }

  Future<void> checkAvailabilityDonor() async {
    try {
      return await _homeRepository.checkAvailabilityDonor();
    } catch (e) {
      Helper.handleError(e, 'Error while checking donor availability!');
    }
  }

  Future<List<DonateAcceptModel>> getAcceptanceDonor() async {
    try {
      return await _homeRepository.getAcceptanceDonor();
    } catch (e) {
      Helper.handleError(e, 'Error while getting acceptance donor!');
      return [];
    }
  }

  Future<void> updateStatus(bool status) async {
    try {
      return await _homeRepository.updateStatus(status);
    } catch (e) {
      Helper.handleError(e, 'Error while updating app status!');
    }
  }

  Future<bool?> getavailableDonor(String email) async {
    try {
      isAvailability = await _homeRepository.getavailableDonor(email);
    } catch (e) {
      Helper.handleError(e, 'Error while checking availability!');
      return null;
    }
    return null;
  }

  Future<List<DonateAcceptModel>> seeTakerAcceptanceData() async {
    try {
      return await _homeRepository.seeTakerAcceptanceData();
    } catch (e) {
      Helper.handleError(e, 'Error while see taker acceptance data!');
      return [];
    }
  }

  Future<void> deleteExpiredRequests() async {
    try {
      return await _homeRepository.deleteExpiredRequests();
    } catch (e) {
      Helper.handleError(e, 'Error while deleting exipry request!');
    }
  }
}
