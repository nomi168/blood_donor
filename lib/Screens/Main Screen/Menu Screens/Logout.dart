// ignore_for_file: file_names

import 'package:blood_donor/Screens/Authentication%20Screen/LoginScreen.dart';
import 'package:blood_donor/Screens/Authentication%20Screen/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orietation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0.w, 5.h, 0, 0),
                  child: Center(
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                child: Image.asset('images/image1.jpeg'),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                child: Text(
                  'You Have Been LogOut',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                  child: TextButton(
                    child: Text(
                      'Signin',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const LoginScreen();
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
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.h, 3.w, 0),
                child: Text(
                  'If you wish to create a new account, please click on the Sign Up button.',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black45,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 2.h, 0, 0),
                  child: TextButton(
                    child: Text(
                      'Signup',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
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
                  ))
            ]),
          ),
        );
      },
    );
  }
}
