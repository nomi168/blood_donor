import 'dart:async';

import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';
import 'package:blood_donor/features/dashboard/home/domain/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyTakerController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository();
  bool isLanguage = false;
  FeedTakerModel? takerModel;
  bool isLoading = false;
  bool is6Hours = false;
  bool isShow = false;
  DateTime? notedTime;
  Duration? remainingTime;
  bool showButton = false;
  Timer? countdownTimer;

  @override
  void onInit() {
    checkTakerConditionData();
    super.onInit();
  }

  Future<void> checkTakerConditionData() async {
    takerModel = null;
    isLoading = true;
    isShow = true;
    takerModel = await checkTakerCondition();

    if (takerModel != null) {
      DateTime createdAt = DateTime.parse(takerModel!.createdAt!);
      notedTime = createdAt.add(const Duration(hours: 6));

      if (takerModel!.situation == 'normal') {
        startCountdown();
      }
    }

    isLoading = false;
    isShow = false;
    update();
  }

  void startCountdown() {
    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (notedTime != null) {
        if (now.isAfter(notedTime!) || now.isAtSameMomentAs(notedTime!)) {
          showButton = true;
          remainingTime = Duration.zero;
          timer.cancel(); // Stop the timer
        } else {
          remainingTime = notedTime!.difference(now);
          showButton = false;
        }
        update(); // Refresh UI every second
      }
    });
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> callEmergencyNumber() async {
    final Uri telLaunchUri = Uri(
      scheme: 'tel',
      path: '15',
    );
    if (await canLaunchUrl(telLaunchUri)) {
      await launchUrl(
        telLaunchUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar(
        "Error",
        "Could not launch dialer $telLaunchUri",
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        borderRadius: 8,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<FeedTakerModel?> checkTakerCondition() async {
    try {
      return await _homeRepository.checkTakerCondition();
    } catch (e) {
      Helper.handleError(e, 'Error while checking taker data!');
      return null;
    }
  }
}
