// ignore_for_file: file_names

import 'package:blood_donor/features/auth/presentation/screens/signup_screen.dart';
import 'package:blood_donor/features/splashscreens/presentation/screens/splash_with_middle_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashEndScreen extends StatefulWidget {
  const SplashEndScreen({super.key});

  @override
  State<SplashEndScreen> createState() => _SplashEndScreenState();
}

class _SplashEndScreenState extends State<SplashEndScreen> {
  int currentPage = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        SizedBox(
          height: 10.h,
        ),
        Center(child: Image.asset('images/image2.jpeg')),
        SizedBox(
          height: 12.h,
        ),
        Center(
          child: Text(
            'Emergency Subcription',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Center(
          child: Text(
            'In case of emergency, you can find',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
        ),
        Center(
          child: Text(
            'donor who are active 24/7',
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
                    return const SignUpScreen();
                  },
                  transitionDuration: const Duration(microseconds: 100),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(10.0, 0.0); // slide in from the right
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
          height: 115.h,
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
        Row(
          children: [
            SizedBox(
              width: 10.w,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const SplashMiddleScreen();
                    },
                    transitionDuration: const Duration(microseconds: 100),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
              child: Text(
                'Prew',
                style: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const SignUpScreen();
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
              child: Text(
                'Skip',
                style: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
      ]),
    );
  }
}
