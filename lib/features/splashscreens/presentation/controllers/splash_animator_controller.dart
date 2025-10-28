import 'package:blood_donor/features/auth/presentation/screens/signup_screen.dart';
import 'package:blood_donor/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashAnimatorController extends GetxController {
  final PageController pageController = PageController();
  int currentPage = 0; 

  final List<Map<String, String>> splashData = [
    {
      "image": "images/image1.jpeg",
      "title": "Easy Donor Search",
      "subtitle1": "Easy to find available donors nearby.",
      "subtitle2": "Verified donors willing to help.",
    },
    {
      "image": "images/image2.jpeg",
      "title": "Track Your Donor",
      "subtitle1": "You can track your donor's location and",
      "subtitle2": "send them necessary information to reach you.",
    },
    {
      "image": "images/image3.jpeg",
      "title": "Emergency Subscription",
      "subtitle1": "In case of emergency, you can find",
      "subtitle2": "donors who are active 24/7.",
    },
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onNextPressed() {
    if (currentPage < splashData.length - 1) {
      currentPage++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      update();
    } else {
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    }
  }

  void onPreviewPressed() {
    if (currentPage > 0) {
      currentPage--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      update();
    }
  }
}
