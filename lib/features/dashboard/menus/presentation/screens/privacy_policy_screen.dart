import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/controllers/privacy_policy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'menu_setting_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<PrivacyPolicyController>(
        init: PrivacyPolicyController(),
        builder: (controller) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(3.w, 4.h, 0, 0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 27,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const MenuSettingScreen();
                            },
                            transitionDuration:
                                const Duration(microseconds: 100),
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
                      padding: EdgeInsets.fromLTRB(20.w, 4.h, 0, 0),
                      child: Text(
                        'Privacy & Policy',
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      )),
                ],
              ),
              Expanded(
                  child:
                      controller.isLoading && controller.privacy_policy.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: PRIMARY_COLOR,
                            ))
                          : !controller.isLoading &&
                                  controller.privacy_policy.isEmpty
                              ? Center(
                                  child: Text(
                                  'no data found',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ))
                              : SfPdfViewer.network(controller.privacy_policy)),
            ],
          );
        },
      ),
    );
  }
}
