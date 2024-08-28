// ignore_for_file: file_names, use_build_context_synchronously

import 'package:blood_donor/Screens/Authentication%20Screen/ForgetScreen.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OTPForgetScreen extends StatefulWidget {
  const OTPForgetScreen({super.key});

  @override
  State<OTPForgetScreen> createState() => _OTPForgetScreenState();
}

class _OTPForgetScreenState extends State<OTPForgetScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  bool isClicked = false;
  bool isClicked1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.w, 15.h, 0.w, 0),
            child: Center(
              child: Text(
                'Verification Code',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
            child: Center(
              child: Text(
                'We will send you a verification code',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
            child: Center(
              child: Text(
                'on your email',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
            child: Material(
              elevation: 7.0, // Add shadow/elevation
              borderRadius: BorderRadius.circular(10.0), // Add border radius
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  label: const Text('Email'),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Adjust padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Colors.grey), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Border color when focused
                  ),
                  hintText: 'Enter Email',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(60.w, 0.h, 5.w, 0),
            child: Center(
                child: TextButton(
              // ignore: prefer_const_constructors
              child: Text(
                'Send OTP',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: isClicked ? Colors.red : Colors.blue,
                    decoration: TextDecoration.underline),
              ),
              onPressed: () async {
                setState(() {
                  isClicked = true;
                });
                myauth.setConfig(
                    appEmail: "me@rohitchouhan.com",
                    appName: "Email OTP",
                    userEmail: email.text,
                    otpLength: 6,
                    otpType: OTPType.digitsOnly);
                if (await myauth.sendOTP() == true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("OTP has been sent"),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Oops, OTP send failed"),
                  ));
                }
              },
            )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
            child: Material(
              elevation: 7.0, // Add shadow/elevation
              borderRadius: BorderRadius.circular(10.0), // Add border radius
              child: TextFormField(
                controller: otp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: const Text('OTP'),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Adjust padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Colors.grey), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Border color when focused
                  ),
                  hintText: 'Enter OTP',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
            child: Center(
              child: Text(
                'Donot recieve code?',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
            child: Center(
                child: TextButton(
              // ignore: prefer_const_constructors
              child: Text(
                'Resend OTP',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: isClicked1 ? Colors.red : Colors.blue,
                    decoration: TextDecoration.underline),
              ),
              onPressed: () async {
                setState(() {
                  isClicked1 = true;
                });
                myauth.setConfig(
                    appEmail: "me@rohitchouhan.com",
                    appName: "Email OTP",
                    userEmail: email.text,
                    otpLength: 6,
                    otpType: OTPType.digitsOnly);
                if (await myauth.sendOTP() == true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("OTP has been sent"),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Oops, OTP send failed"),
                  ));
                }
              },
            )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 17.h, 5.w, 0),
            child: Material(
              elevation: 10.0,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (await myauth.verifyOTP(otp: otp.text) == true) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("OTP is verified"),
                    ));
                    String em = email.text;
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ForgetScreen(email: em);
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid OTP"),
                    ));
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    // ignore: prefer_const_constructors
                    EdgeInsets.symmetric(vertical: 13.5, horizontal: 35.w),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFFDE0A1E)), // Change button color
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 12.sp, // Adjust the font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
