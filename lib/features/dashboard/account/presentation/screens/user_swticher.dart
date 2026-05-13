import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/controllers/user_swticher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class UserSwitcherScreen extends StatelessWidget {
  const UserSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<UserSwticherController>(
        init: UserSwticherController(),
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "User Switcher Screen",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (UserController.to.userModel!.type == "taker" &&
                      controller.checkExistDonor)
                    _switcherUI(controller),
                  if (UserController.to.userModel!.type == "taker" &&
                      !controller.checkExistDonor)
                    _noticeUI(),
                  if (UserController.to.userModel!.type == "donor")
                    _switcherUI(controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _switcherUI(UserSwticherController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "You can switch your role below:",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 20),
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roleButton(
                title: "Taker",
                value: "taker",
                controller: controller,
              ),
              const SizedBox(width: 10),
              _roleButton(
                title: "Donor",
                value: "donor",
                controller: controller,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _noticeUI() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Takers will not be able to donate blood.",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleButton({
    required String title,
    required String value,
    required UserSwticherController controller,
  }) {
    return GestureDetector(
      onTap: () async {
        if (controller.selectedOption == value) {
          Get.snackbar(
            "Info",
            "You are already a $title",
            snackPosition: SnackPosition.TOP,
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: Colors.blue.withValues(alpha: 0.5),
            colorText: Colors.white,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 3),
            borderRadius: 8,
            icon: Icon(Icons.info, color: Colors.blue),
          );

          return;
        }

        controller.selectedOption = value;
        controller.update();

        /// SWITCH LOGIC
        if (value == "taker") {
          bool? response = await controller.addingDonorSwitcher(
            UserController.to.userModel!.email,
          );

          if (response != true) {
            Get.snackbar(
              "Error",
              "Failed to create donor switcher",
              snackPosition: SnackPosition.TOP,
              snackStyle: SnackStyle.FLOATING,
              backgroundColor: Colors.red.withValues(alpha: 0.9),
              colorText: Colors.white,
              margin: EdgeInsets.all(10),
              duration: Duration(seconds: 3),
              borderRadius: 8,
              icon: Icon(Icons.error, color: Colors.white),
            );

            return;
          }
        }

        bool? result = await controller.updateUserType(
          value,
          UserController.to.userModel!.email,
        );

        if (result == true) {
          Restart.restartApp();
        } else {
          Get.snackbar(
            "Error",
            "Could not update user",
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
      },
      child: Container(
        alignment: Alignment.center,
        width: 90,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:
              controller.selectedOption == value ? PRIMARY_COLOR : Colors.white,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: controller.selectedOption == value
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
