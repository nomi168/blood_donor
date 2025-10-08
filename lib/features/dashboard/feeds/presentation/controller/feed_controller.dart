import 'dart:async';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/feeds/data/models/feed_taker_model.dart';
import 'package:blood_donor/features/dashboard/feeds/domain/feed_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FeedController extends GetxController {
  final FeedRepository _feedRepository = FeedRepository();
  TextEditingController searchController = TextEditingController();
  final Completer<GoogleMapController> controllers =
      Completer<GoogleMapController>();
  static FeedController get to => Get.find();
  List<FeedTakerModel> takerList = [];
  List<FeedTakerModel> filterList = [];
  bool isLoading = false;
  bool? isAvailability;

  @override
  void onInit() {
    super.onInit();
    getTakerData();
    getavailableDonor(UserController.to.userModel!.email);
    deleteExpiredRequests();
    getCurrentLocation();
  }

  Future<void> getTakerData() async {
    takerList.clear();
    isLoading = true;
    update();
    takerList = await getFeedTakerData();
    takerList.sort((a, b) {
      if (a.situation == 'critical' && b.situation != 'critical') return -1;
      if (a.situation != 'critical' && b.situation == 'critical') return 1;
      return 0;
    });
    isLoading = false;

    update();
  }

  void filterUsers(String? query) {
    if (query == null || query.trim().isEmpty) {
      filterList = List.from(takerList);
    } else {
      final lowerQuery = query.toLowerCase();
      filterList = takerList.where((user) {
        final name = user.name?.toLowerCase() ?? '';
        final blood = user.blood?.toLowerCase() ?? '';
        return name.contains(lowerQuery) || blood.contains(lowerQuery);
      }).toList();
    }
    update();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final GoogleMapController controller = await controllers.future;

      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          9.6,
        ),
      );

      update();
    } catch (e) {
      logError("Error: $e");
    }
  }

  Future<List<FeedTakerModel>> getFeedTakerData() async {
    try {
      return await _feedRepository.getFeedTakerData();
    } catch (e) {
      Helper.handleError(e, 'Error while getting taker data!');
      return [];
    }
  }

  Future<bool> sendChatRequest(dynamic payload) async {
    try {
      showLoader('sending request...');
      return await _feedRepository.sendChatRequest(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while send chat request!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> sendNotification(String email) async {
    try {
      return await _feedRepository.sendNotification(email);
    } catch (e) {
      Helper.handleError(e, 'Error while sending notification!');
    }
  }

  Future<bool?> getavailableDonor(String email) async {
    try {
      isAvailability = await _feedRepository.getavailableDonor(email);
    } catch (e) {
      Helper.handleError(e, 'Error while checking availability!');
      return null;
    }
    return null;
  }

  Future<void> deleteExpiredRequests() async {
    try {
      return await _feedRepository.deleteExpiredRequests();
    } catch (e) {
      Helper.handleError(e, 'Error while deleting exipry request!');
    }
  }

  Future<bool> checkUserCnicVerification(String card) async {
    try {
      showLoader('checking...');
      return await _feedRepository.checkUserCnicVerification(card);
    } catch (e) {
      Helper.handleError(e, 'Error while checking CNIC verification!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
