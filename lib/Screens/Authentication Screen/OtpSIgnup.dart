// ignore_for_file: file_names, use_build_context_synchronously, non_constant_identifier_names

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OTPSignup extends StatefulWidget {
  final String email;
  final String image;
  final String fname;
  final String lname;
  final String number;
  final String location;
  final String blood;
  final String gender;
  final String password;
  final int Id;

  const OTPSignup(
      {super.key,
      required this.email,
      required this.image,
      required this.fname,
      required this.lname,
      required this.number,
      required this.location,
      required this.blood,
      required this.gender,
      required this.password,
      required this.Id});

  @override
  State<OTPSignup> createState() => _OTPSignupState();
}

class _OTPSignupState extends State<OTPSignup> {
  // ignore: prefer_final_fields
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  bool isClicked = false;
  bool isClicked1 = false;
  bool result = false;
  @override
  void initState() {
    super.initState();
    email.text = widget.email;
  }

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
              color: Colors.white,
              elevation: 7.0, // Add shadow/elevation
              borderRadius: BorderRadius.circular(10.0), // Add border radius
              child: TextFormField(
                controller: email,
                readOnly: true,
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
              color: Colors.white,
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

                    // String email = widget.email;
                    // int id = widget.Id;
                    // String image = widget.image;
                    // String fname = widget.fname;
                    // String lname = widget.lname;

                    // String number = widget.number;
                    // String location = widget.location;
                    // String blood = widget.blood;
                    // String gender = widget.gender;
                    // String password = widget.password;
                    // Navigator.push(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (context, animation, secondaryAnimation) {
                    //       return QuestionsScreen(
                    //           id: id,
                    //           image: image,
                    //           fname: fname,
                    //           lname: lname,
                    //           number: number,
                    //           email: email,
                    //           location: location,
                    //           blood: blood,
                    //           gender: gender,
                    //           password: password);
                    //     },
                    //     transitionDuration: const Duration(seconds: 1),
                    //     transitionsBuilder:
                    //         (context, animation, secondaryAnimation, child) {
                    //       const begin =
                    //           Offset(10.0, 0.0); // slide in from the right
                    //       const end = Offset.zero;
                    //       const curve = Curves.easeInOutQuart;

                    //       var tween = Tween(begin: begin, end: end)
                    //           .chain(CurveTween(curve: curve));
                    //       var offsetAnimation = animation.drive(tween);

                    //       return SlideTransition(
                    //         position: offsetAnimation,
                    //         child: child,
                    //       );
                    //     },
                    //   ),
                    // );
                  } else {
                    _showAlertDialog2(context);
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

  void _showAlertDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Invalid OTP,Please Correct the Submit OTP Code'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
