import 'dart:async';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helper {
  static void handleError(dynamic e, String errorMessage) {
    if (e is TypeError) {
      Get.snackbar(
        "Error",
        "$errorMessage",
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        borderRadius: 8,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } else if (e is FirebaseAuthException) {
      Get.snackbar(
        "Error",
        "${e.message ?? errorMessage}!",
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        borderRadius: 8,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } else if (e is FirebaseException) {
       Get.snackbar(
        "Error",
        "${e.message ?? errorMessage}!",
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        borderRadius: 8,
        icon: Icon(Icons.error, color: Colors.white),
      );
     
    } else if (e is TimeoutException) {
       Get.snackbar(
        "Error",
        "Request timeout, please try again in few seconds!",
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        borderRadius: 8,
        icon: Icon(Icons.error, color: Colors.white),
      );
      
    } else {
       Get.snackbar(
        "Error",
        "$e!",
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

    logError(e.toString());
  }
}
