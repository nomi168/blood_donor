import 'dart:async';
import 'dart:convert';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/auth/presentation/screens/card_scanning_screen.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/notification.dart';
import 'package:blood_donor/features/dashboard/home/data/models/active_user_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/banner_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:blood_donor/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<ActiveUserModel> activeUserModel = [];
  List<BannerModel> bannerList = [];

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

  String selectedBloodGroup = '';
  int currentIndex = 0;
  bool isLoading = false;
  bool? isAvailability;
  bool isUrdu = false;
  @override
  Future<void> onInit() async {
    super.onInit();
    getBannersList();
    checkCNICVerification();

    final updatedUser = UserController.to.userModel;

    if (updatedUser != null) {
      if (updatedUser.type == 'donor') {
        await getInitDonorData();
      } else {
        await getInitTakerData();
      }

      await getNotificationToken();
      await getTodayActiveUsersList();
    }
  }

  Future<void> waitForUser() async {
    while (UserController.to.userModel == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> checkCNICVerification() async {
    bool result = await checkUserCnicVerification();
    if (!result) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.verified_user, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  "CNIC Verification Required",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please verify your CNIC before proceeding.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                Text(
                  "• If you are a Taker: You cannot request blood without CNIC verification.\n\n"
                  "• If you are a Donor: You cannot donate blood without verifying your CNIC.\n\n"
                  "👉 Go to your account section and verify your CNIC to continue.",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Later", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    isScrollControlled: true, 
                    backgroundColor:
                        Colors.transparent, 
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.only(top: 40), 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          child: CardScanningScreen(), // 👈 your screen
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "Verify Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  // Future<void> getBannersList() async {
  //   bannerList.clear();
  //   bannerList = await getBanners();

  //   update();
  // }

  Future<void> getBannersList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? cachedData = prefs.getString('banners');
    if (cachedData != null) {
      List<dynamic> cachedList = jsonDecode(cachedData);
      bannerList = cachedList.map((e) => BannerModel.fromJson(e)).toList();
    }

    List<BannerModel> freshList = await getBanners();
    bannerList = freshList;
    prefs.setString(
        'banners', jsonEncode(bannerList.map((e) => e.toJson()).toList()));

    update();
  }

  Future<void> getTodayActiveUsersList() async {
    activeUserModel.clear();
    activeUserModel = await getTodayActiveUsers();
    if (activeUserModel.isEmpty) {
      dynamic payload = {
        'email': UserController.to.userModel!.email,
        'today': Timestamp.fromDate(DateTime.now())
      };
      await addActiveTodayUser(payload);
    } else {
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      for (var time in activeUserModel) {
        final Timestamp? timestamp = time.today;

        if (timestamp != null) {
          final String docDate =
              DateFormat('yyyy-MM-dd').format(timestamp.toDate());

          if (docDate == today) {
            break;
          } else {
            dynamic payload = {
              'email': UserController.to.userModel!.email,
              'today': Timestamp.fromDate(DateTime.now())
            };
            await addActiveTodayUser(payload);
            break;
          }
        }
      }
    }

    update();
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

  Future<List<ActiveUserModel>> getTodayActiveUsers() async {
    try {
      return await _homeRepository.getTodayActiveUsers();
    } catch (e) {
      Helper.handleError(e, 'Error while getting user data!');
      return [];
    }
  }

  Future<void> addActiveTodayUser(dynamic payload) async {
    try {
      return await _homeRepository.addTodateActiveUser(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while getting user data!');
    }
  }

  Future<bool> checkTakerBloodRequest(Map<String, dynamic> payload) async {
    try {
      showLoader('checking request');
      return await _homeRepository.checkTakerBloodRequest(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while checking taler blood request!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<List<BannerModel>> getBanners() async {
    try {
      return await _homeRepository.getBanners();
    } catch (e) {
      Helper.handleError(e, 'Error while getting banners data!');
      return [];
    }
  }

  Future<bool> checkUserCnicVerification() async {
    try {
      return await _homeRepository.checkUserCnicVerification();
    } catch (e) {
      // Helper.handleError(e, 'Error while checking CNIC verification!');
      return false;
    }
  }
}
