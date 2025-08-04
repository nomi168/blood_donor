import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyDonorController extends GetxController {
  bool isLanguage = false;
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
 
}
