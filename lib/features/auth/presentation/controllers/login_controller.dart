import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/auth/domain/auth_repository.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboatd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class LoginController extends GetxController {
    static LoginController get to => Get.find();
  final AuthRepository _authRepository = AuthRepository();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool? _hasBioSensorr;
  LocalAuthentication authentication = LocalAuthentication();
  bool _isFingerprintAuthenticated = false;
  bool isPasswordVisible = false;
  UserModel? userModel;
 
  Future<void> checkBio() async {
    try {
      _hasBioSensorr = await authentication.canCheckBiometrics;
      print(_hasBioSensorr);
      if (_hasBioSensorr!) {
        _getAuth();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await authentication.authenticate(
        localizedReason: 'Scan your fingerprint',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
      if (isAuth) {
        _isFingerprintAuthenticated = true;
        if (_isFingerprintAuthenticated) {
          Get.offAll(() => Dashboard());
          /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => mainpage(navigateFrom: "")),
          ); */
        } else {}
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> loginToFirebase(String email, String password) async {
    try {
      showLoader('loging user...');
      return await _authRepository.loginToFirestore(email, password);
    } catch (e) {
      Helper.handleError(e, 'Error while loging user!');
      return null;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
