
import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/domain/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  bool isCheck = false;
  bool obscureText = false;
  bool obscureText1 = false;
  // TextEditingController otp = TextEditingController();
  // EmailOTP myauth = EmailOTP();
  // bool isClicked = false;
  // bool isClicked1 = false;

  Future<bool> checkEmail(String email) async {
    try {
      showLoader('please wait...');
      // showCustomLoader(navigatorKey.currentContext!);
      return await _authRepository.checkEmail(email);
    } catch (e) {
      Helper.handleError(e, "Error while checking email!");
      return false;
    } finally {
      
      await EasyLoading.dismiss();
    }
  }

  Future<bool> forgotPassword(dynamic payload) async {
    try {
      showLoader('updating password...');
      return await _authRepository.forgotPassword(payload);
    } catch (e) {
      Helper.handleError(e, 'Error while updating password!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
