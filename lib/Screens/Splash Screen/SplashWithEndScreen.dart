// ignore_for_file: file_names

import 'package:blood_donor/Screens/Authentication%20Screen/SignupScreen.dart';
import 'package:blood_donor/Screens/Splash%20Screen/SplashWithMiddleScree.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
        Padding(
          padding: EdgeInsets.fromLTRB(0.w, 3.h, 0.w, 0.h),
          child: Center(child: Image.asset('images/image2.jpeg')),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0.w, 12.h, 0.w, 0),
            child: Center(
              child: Text(
                'Emergency Subcription',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(15.w, 3.h, 15.w, 0),
            child: Center(
              child: Text(
                'In case of emergency, you can find',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(11.w, 1.h, 11.w, 0),
            child: Center(
              child: Text(
                'donor who are active 24/7',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const SignupScreen();
                    },
                    transitionDuration: const Duration(seconds: 1),
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
                  padding: EdgeInsets.all(3.8.w),
                  backgroundColor: const Color(0xFFDE0A1E)),
              child: const Icon(
                Icons.arrow_forward,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 10.h, 0, 0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const SplashMiddleScreen();
                      },
                      transitionDuration: const Duration(seconds: 1),
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
                      fontSize: 15.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.w, 10.h, 0, 0),
              child: Center(
                child: DotsIndicator(
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
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(26.w, 10.h, 0, 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const SignupScreen();
                      },
                      transitionDuration: const Duration(seconds: 1),
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
                      fontSize: 15.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
