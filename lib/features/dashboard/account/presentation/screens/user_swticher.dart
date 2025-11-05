import 'package:blood_donor/features/dashboard/account/presentation/controllers/user_swticher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSwitcherScreen extends StatelessWidget {
  const UserSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<UserSwticherController>(
        init: UserSwticherController(),
        builder: (controller) {
          // controller.showPopup(context);
          return Center(
            child: Text(
              "User Switcher Screen",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(221, 24, 19, 19),
              ),
            ),
          );
        },
      ),
    );
  }
}
