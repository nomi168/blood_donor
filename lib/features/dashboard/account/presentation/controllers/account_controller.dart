import 'dart:async';

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/domain/account_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final AccountRepository _accountRepository = AccountRepository();

  DateTime? nextDonationDate;
  Duration remainingTime = Duration();
  Timer? timer;

  bool checkExistDonor = false;
  bool availablility = false;
  String selectedOption = '';

  @override
  void onInit() {
    // onInitData();
    getDonorBackforDonation();
    checkingDonorAvailable();
    super.onInit();
  }

  Future<void> onInitData() async {
    bool result =
        await checkingDonorSwitcher(UserController.to.userModel!.email);
    if (result == true) {
      checkExistDonor = true;
    }
    if (UserController.to.userModel!.type == 'donor' &&
        UserController.to.userModel!.status &&
        checkExistDonor) {
      selectedOption = 'donor';
    } else if (UserController.to.userModel!.type == 'donor' &&
        !UserController.to.userModel!.status &&
        !checkExistDonor) {
      selectedOption = 'donor';
    } else if (UserController.to.userModel!.type == 'donor' &&
        !UserController.to.userModel!.status &&
        checkExistDonor) {
      selectedOption = 'donor';
    } else if (UserController.to.userModel!.type == 'taker' &&
        UserController.to.userModel!.status &&
        checkExistDonor) {
      selectedOption = 'taker';
    } else if (UserController.to.userModel!.type == 'taker' &&
        !UserController.to.userModel!.status &&
        checkExistDonor) {
      selectedOption = 'taker';
    } else if (UserController.to.userModel!.type == 'taker' &&
        !UserController.to.userModel!.status &&
        checkExistDonor == false) {
      selectedOption = 'taker';
    }
    update();
  }

  Future<void> getDonorBackforDonation() async {
    nextDonationDate =
        await getDonorBackToDonate(UserController.to.userModel!.email);
    if (nextDonationDate != null) {
      startCountdown();
    }
  }

  void startCountdown() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (nextDonationDate != null && nextDonationDate!.isAfter(now)) {
        remainingTime = nextDonationDate!.difference(now);
      } else {
        remainingTime = Duration.zero; // Countdown reached zero
        timer.cancel();
      }
      update();
    });
  }

  Future<void> checkingDonorAvailable() async {
    availablility =
        await checkDonorAvailability(UserController.to.userModel!.email);
    availablility;
    update();
  }

  Future<bool> checkingDonorSwitcher(String email) async {
    try {
      return await _accountRepository.checkingDonorSwitcher(email);
    } catch (e) {
      Helper.handleError(e, 'Error while checking donor switcher!');
      return false;
    }
  }

  Future<DateTime?> getDonorBackToDonate(String email) async {
    try {
      return await _accountRepository.getDonorBackToDonate(email);
    } catch (e) {
      Helper.handleError(e, 'Error while getting donor time!');
      return null;
    }
  }

  Future<bool> checkDonorAvailability(String email) async {
    try {
      return await _accountRepository.checkDonorAvailability(email);
    } catch (e) {
      Helper.handleError(e, 'Error while checking donor availability!');
      return false;
    }
  }

  Future<bool> addingDonorSwitcher(String email) async {
    try {
      showLoader('adding...');
      return await _accountRepository.addingDonorSwitcher(email);
    } catch (e) {
      Helper.handleError(e, 'Error while adding donor switcher!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> updateUserType(String userType, String email) async {
    try {
      showLoader('updating type...');
      return await _accountRepository.updateUserType(userType, email);
    } catch (e) {
      Helper.handleError(e, 'Error while updating user type!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> checkUserCnicVerification(String card) async {
    try {
      showLoader('checking...');
      return await _accountRepository.checkUserCnicVerification(card);
    } catch (e) {
      Helper.handleError(e, 'Error while checking CNIC verification!');
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }
}
