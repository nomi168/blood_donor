import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/domain/account_repository.dart';
import 'package:blood_donor/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class UserSwticherController extends GetxController {
  final AccountRepository _accountRepository = AccountRepository();
  String selectedOption = '';
  bool checkExistDonor = false;

  @override
  void onInit() {
    onInitData();
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPopup(navigatorKey.currentContext!);
    });
  }

  void showPopup(BuildContext context) {
    if (UserController.to.userModel!.type == "taker" && checkExistDonor) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.swap_horiz, color: Colors.blue, size: 26),
              SizedBox(width: 8),
              Text(
                "Switch Account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You are currently a Donor. You can switch your role below:",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // ✅ Your custom toggle bar goes here
              UserController.to.userModel!.type == 'donor' ||
                      checkExistDonor == true
                  ? Container(
                      height: 50, // replace with 6.h if using Sizer
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🔴 Taker Button
                          GestureDetector(
                            onTap: () async {
                              if (selectedOption == 'taker') {
                                Get.snackbar(
                                  "Error",
                                  "You are already a Taker",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .9),
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              } else {
                                selectedOption = 'taker';
                                update();

                                bool? response = await addingDonorSwitcher(
                                    UserController.to.userModel!.email);

                                if (response == true) {
                                  bool? result = await updateUserType('taker',
                                      UserController.to.userModel!.email);

                                  if (result == true) {
                                    Restart.restartApp();
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "Could not update user. Please try again.",
                                      snackPosition: SnackPosition.TOP,
                                      snackStyle: SnackStyle.FLOATING,
                                      backgroundColor:
                                          Colors.red.withValues(alpha: .8),
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(10),
                                      duration: const Duration(seconds: 3),
                                      borderRadius: 8,
                                      icon: const Icon(Icons.error,
                                          color: Colors.white),
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Failed to create donor switcher. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: .8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80, // replace with 25.w if using Sizer
                              height: 40, // replace with 5.h
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: selectedOption == 'taker'
                                    ? PRIMARY_COLOR
                                    : Colors.white,
                              ),
                              child: Text(
                                'Taker',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedOption == 'taker'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          
                          GestureDetector(
                            onTap: () async {
                              if (selectedOption == 'donor') {
                                Get.snackbar(
                                  "Error",
                                  "You are already a Donor",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .8),
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              } else {
                                selectedOption = 'donor';
                                update();

                                bool? result = await updateUserType('donor',
                                    UserController.to.userModel!.email);

                                if (result == true) {
                                  Restart.restartApp();
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Could not update user. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: .8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80, // replace with 25.w
                              height: 40, // replace with 5.h
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: selectedOption == 'donor'
                                    ? PRIMARY_COLOR
                                    : Colors.white,
                              ),
                              child: Text(
                                'Donor',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedOption == 'donor'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    } else if (UserController.to.userModel!.type == "taker" &&
        !checkExistDonor) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.red, size: 26),
              SizedBox(width: 8),
              Text(
                "Notice",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: const Text(
            "Takers will not be able to donate any blood.",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else if (UserController.to.userModel!.type == "donor") {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.swap_horiz, color: Colors.blue, size: 26),
              SizedBox(width: 8),
              Text(
                "Switch Account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You are currently a Donor. You can switch your role below:",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // ✅ Your custom toggle bar goes here
              UserController.to.userModel!.type == 'donor' ||
                      checkExistDonor == true
                  ? Container(
                      height: 50, // replace with 6.h if using Sizer
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🔴 Taker Button
                          GestureDetector(
                            onTap: () async {
                              if (selectedOption == 'taker') {
                                Get.snackbar(
                                  "Error",
                                  "You are already a Taker",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .9),
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              } else {
                                selectedOption = 'taker';
                                update();

                                bool? response = await addingDonorSwitcher(
                                    UserController.to.userModel!.email);

                                if (response == true) {
                                  bool? result = await updateUserType('taker',
                                      UserController.to.userModel!.email);

                                  if (result == true) {
                                    Restart.restartApp();
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "Could not update user. Please try again.",
                                      snackPosition: SnackPosition.TOP,
                                      snackStyle: SnackStyle.FLOATING,
                                      backgroundColor:
                                          Colors.red.withValues(alpha: .8),
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(10),
                                      duration: const Duration(seconds: 3),
                                      borderRadius: 8,
                                      icon: const Icon(Icons.error,
                                          color: Colors.white),
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Failed to create donor switcher. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: .8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80, // replace with 25.w if using Sizer
                              height: 40, // replace with 5.h
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: selectedOption == 'taker'
                                    ? PRIMARY_COLOR
                                    : Colors.white,
                              ),
                              child: Text(
                                'Taker',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedOption == 'taker'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // 🔵 Donor Button
                          GestureDetector(
                            onTap: () async {
                              if (selectedOption == 'donor') {
                                Get.snackbar(
                                  "Error",
                                  "You are already a Donor",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: .8),
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(10),
                                  duration: const Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              } else {
                                selectedOption = 'donor';
                                update();

                                bool? result = await updateUserType('donor',
                                    UserController.to.userModel!.email);

                                if (result == true) {
                                  Restart.restartApp();
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Could not update user. Please try again.",
                                    snackPosition: SnackPosition.TOP,
                                    snackStyle: SnackStyle.FLOATING,
                                    backgroundColor:
                                        Colors.red.withValues(alpha: .8),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 3),
                                    borderRadius: 8,
                                    icon: const Icon(Icons.error,
                                        color: Colors.white),
                                  );
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 80, // replace with 25.w
                              height: 40, // replace with 5.h
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: selectedOption == 'donor'
                                    ? PRIMARY_COLOR
                                    : Colors.white,
                              ),
                              child: Text(
                                'Donor',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedOption == 'donor'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    }
  }

  Future<bool> checkingDonorSwitcher(String email) async {
    try {
      return await _accountRepository.checkingDonorSwitcher(email);
    } catch (e) {
      Helper.handleError(e, 'Error while checking donor switcher!');
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
}
