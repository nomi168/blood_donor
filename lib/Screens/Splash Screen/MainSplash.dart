import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';

import '../Main Screen/Dashoard/Dashboatd.dart';

class MainSplash extends StatefulWidget {
  const MainSplash({super.key});

  @override
  State<MainSplash> createState() => _MainSplashState();
}

class _MainSplashState extends State<MainSplash> {
  @override
  void initState() {
    super.initState();
    getAppVersion();
    navigateAfterDelay();
  }

  String version = '';
  PackageInfo? packageInfo;

  getAppVersion() async {
    packageInfo = await PackageInfo.fromPlatform();

    if (packageInfo != null) {
      version = packageInfo!.version.toString();
    }
    setState(() {});
  }

  void navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const Dashboard();
            },
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(10.0, 0.0); // slide in from the right
              const end = Offset.zero;
              const curve = Curves.easeInOutQuart;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.w, 25.h, 0.w, 0.h),
              child: Center(
                child: Image.asset(
                  'images/bloodsplash.png',
                  height: 50.h,
                  width: 50.w,
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),

            Text(
              "version: $version",
              style: TextStyle(
                fontSize: 15.sp,
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
        ),
      );
    });
  }
}
