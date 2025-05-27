// ignore_for_file: file_names

import 'package:blood_donor/features/auth/presentation/screens/signup_screen.dart';
import 'package:blood_donor/features/splashscreens/presentation/screens/splash_with_middle_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartWithSplashScreen extends StatefulWidget {
  const StartWithSplashScreen({Key? key}) : super(key: key);

  @override
  State<StartWithSplashScreen> createState() => _StartWithSplashScreenState();
}

class _StartWithSplashScreenState extends State<StartWithSplashScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(child: Image.asset('images/image1.jpeg')),
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: Text(
              'Easy Donor Search',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Text(
              'Easy to find available donors nearby.',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Center(
            child: Text(
              'Verified donors willing to help.',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),
          SizedBox(
            height: 100.h,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const SplashMiddleScreen();
                    },
                    transitionDuration: const Duration(microseconds: 100),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin =
                          Offset(10.0, 0.0); // slide in from the right
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
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 8,
                  padding: EdgeInsets.all(10.w),
                  backgroundColor: const Color(0xFFDE0A1E)),
              child: const Icon(
                Icons.arrow_forward,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 120.h,
          ),
          DotsIndicator(
            dotsCount: 3,
            position: currentPage.toDouble().toInt(),
            // ignore: prefer_const_constructors
            decorator: DotsDecorator(
              color: Colors.grey, // Inactive dot color
              activeColor: const Color(0xFFDE0A1E), // Active dot color
              size: const Size(10.0, 10.0), // Dot size
              activeSize: const Size(14.0, 14.0), // Active dot size
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10.h),
            child: InkWell(
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () async {
                print("Nomi");

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const SignUpScreen();
                    },
                    transitionDuration:
                        Duration(microseconds: 300), // Faster transition
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // slide in from the right
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
              child: Text(
                'Skip',
                style: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
