// ignore_for_file: file_names

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/controllers/term_condition_controller.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/menu_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<TermConditionController>(
        init: TermConditionController(),
        builder: (controller) {
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(2.w, 5.h, 0, 0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const MenuSettingScreen();
                            },
                            transitionDuration: const Duration(microseconds: 1),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin =
                                  Offset(-10.0, 0.0); // slide in from the left
                              const end = Offset.zero;
                              const curve = Curves.easeInOutQuart;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 5.h, 0, 0),
                    child: Text(
                      'Terms & Condition',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                ],
              ),
              controller.termsConditionModel == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: PRIMARY_COLOR,
                        strokeWidth: 4,
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        buildCheckBoxRow(
                            'Eligibility',
                            controller.termsConditionModel!.eligibility,
                            (value) {}),
                        SizedBox(
                          height: 15,
                        ),
                        buildCheckBoxRow(
                            'Privacy Policy',
                            controller.termsConditionModel!.privacyPolicy,
                            (value) {}),
                        SizedBox(
                          height: 15,
                        ),
                        buildCheckBoxRow(
                            'Donation Process',
                            controller.termsConditionModel!.donationProcess,
                            (value) {}),
                        SizedBox(
                          height: 15,
                        ),
                        buildCheckBoxRow('Safety',
                            controller.termsConditionModel!.safety, (value) {}),
                        SizedBox(
                          height: 15,
                        ),
                        buildCheckBoxRow(
                            'Hygiene',
                            controller.termsConditionModel!.hygiene,
                            (value) {}),
                      ],
                    )
            ],
          );
        },
      ),
    );
  }

  Widget buildCheckBoxRow(
      String title, bool isChecked, ValueChanged<bool?> onChanged) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1.0, // Top border width (optional)
            ),
            left: BorderSide(
              color: Colors.grey, // Red left border color
              width: 1.0, // Left border width (optional)
            ),
            right: BorderSide(
              color: Colors.grey, // Red right border color
              width: 1.0, // Right border width (optional)
            ),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0.h, 0, 0),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.w, 0.h, 0, 0),
                child: CheckboxListTile(
                  activeColor: const Color(0xFFDE0A1E),
                  value: isChecked,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ));
  }
}
