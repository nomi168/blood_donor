import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  bool _isClicked = false;
  bool _isClickedResend = false;

  bool get isClicked => _isClicked;
  bool get isClickedResend => _isClickedResend;
  void sendOTP(bool value) {
    _isClicked = value;
    update();
  }

  void resendOTP(bool value) {
    _isClickedResend = value;
    update();
  }
}
