// ignore_for_file: file_names

import 'package:blood_donor/Screens/Authentication%20Screen/SignupScreen.dart';
import 'package:blood_donor/Screens/Splash%20Screen/SplashWithEndScreen.dart';
import 'package:blood_donor/Screens/Splash%20Screen/StartWithSplashScreen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SplashMiddleScreen extends StatefulWidget {
  const SplashMiddleScreen({super.key});

  @override
  State<SplashMiddleScreen> createState() => _SplashMiddleScreenState();
}

class _SplashMiddleScreenState extends State<SplashMiddleScreen> {
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.w, 3.h, 0.w, 0.h),
              child: Center(child: Image.asset('images/image3.jpeg')),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0.w, 11.h, 0.w, 0),
                child: Center(
                  child: Text(
                    'Track Your Donor',
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(10.w, 3.h, 10.w, 0),
                child: Center(
                  child: Text(
                    'You can track your donors location and',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
                child: Center(
                  child: Text(
                    'send to them neccessary information to reach',
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
                    'to destination properly.',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const SplashEndScreen();
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
                  padding: EdgeInsets.fromLTRB(4.w, 12.h, 0, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const StartWithSplashScreen();
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
                  padding: EdgeInsets.fromLTRB(25.w, 12.h, 0, 0),
                  child: Center(
                    child: DotsIndicator(
                      dotsCount: 3,
                      position: currentPage.toDouble().toInt(),
                      // ignore: prefer_const_constructors
                      decorator: DotsDecorator(
                        color: Colors.grey, // Inactive dot color
                        activeColor:
                            const Color(0xFFDE0A1E), // Active dot color
                        size: const Size(10.0, 10.0), // Dot size
                        activeSize: const Size(14.0, 14.0), // Active dot size
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(27.w, 12.h, 0, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
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
        ),
      );
    });
  }
}
