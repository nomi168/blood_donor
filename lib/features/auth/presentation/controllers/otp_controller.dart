import 'package:blood_donor/constants.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final String userEmail;
  OtpController({required this.userEmail});
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  bool _isClicked = false;
  bool _isClickedResend = false;

  bool get isClicked => _isClicked;
  bool get isClickedResend => _isClickedResend;
  @override
  void onInit() {
    email.text=userEmail;
    onLoadSend();
    super.onInit();
  }

  void sendOTP(bool value) {
    _isClicked = value;
    update();
  }

  void resendOTP(bool value) {
    _isClickedResend = value;
    update();
  }

  Future<void> onLoadSend() async {
    try {
      showLoader('sending otp...');
      sendOTP(true);
      EmailOTP.config(
          appEmail: "me@rohitchouhan.com",
          appName: "Email OTP",
          otpLength: 4,
          otpType: OTPType.numeric);
      if (await EmailOTP.sendOTP(email: email.text.trim()) == true) {
        Get.snackbar(
          "Success",
          "OTP has been sent",
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          borderRadius: 8,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Oops, OTP send failed",
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
      await EasyLoading.dismiss();
    }
  }
}
