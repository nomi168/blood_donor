// ignore_for_file: file_names

import 'package:blood_donor/Screens/auth/presentation/screens/LoginScreen.dart';
import 'package:blood_donor/Screens/auth/presentation/screens/SignupScreen.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Center(
            child: Text(
              'Log Out',
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 2.h, 0, 0),
            child: Image.asset('images/image1.jpeg'),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'You Have Been LogOut',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          TextButton(
            child: Text(
              'Signin',
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const LoginScreen();
                  },
                  transitionDuration: const Duration(seconds: 1),
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
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'If you wish to create a new account, please click on the Sign Up button.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            child: Text(
              'Signup',
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
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
          )
        ]),
      ),
    );
  }
}
