import 'package:blood_donor/features/splashscreens/presentation/controllers/main_splahscreen_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';

class MainSplash extends StatefulWidget {
  const MainSplash({super.key});

  @override
  State<MainSplash> createState() => _MainSplashState();
}

class _MainSplashState extends State<MainSplash> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<MainSplahscreenController>(
          init: MainSplahscreenController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 25.h, 5.w, 0.h),
                  child: Center(
                      child: SvgPicture.asset(
                    'images/svg/Logo.svg',
                    height: 35.h,
                    width: 35.w,
                  )),
                ),
                const SizedBox(
                  height: 250,
                ),

                Text(
                  "version: ${controller.appVersion}",
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Stack(
                //   children: animatedTextWidgets,
                // ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(10.w, 25.h, 10.w, 0.h),
                //   child: ElevatedButton(
                //     style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all<Color>(
                //         const Color(0xFFDE0A1E),
                //       ),
                //     ),
                //     child: const Text(
                //       'Let\'s Get Started',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         PageRouteBuilder(
                //           pageBuilder: (context, animation, secondaryAnimation) {
                //             return const StartWithSplashScreen();
                //           },
                //           transitionDuration: const Duration(seconds: 1),
                //           transitionsBuilder:
                //               (context, animation, secondaryAnimation, child) {
                //             const begin =
                //                 Offset(10.0, 0.0); // slide in from the right
                //             const end = Offset.zero;
                //             const curve = Curves.easeInOutQuart;

                //             var tween = Tween(begin: begin, end: end)
                //                 .chain(CurveTween(curve: curve));
                //             var offsetAnimation = animation.drive(tween);

                //             return SlideTransition(
                //               position: offsetAnimation,
                //               child: child,
                //             );
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            );
          },
        ),
      );
    });
  }
}
