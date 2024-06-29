// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:blood_donor/Screens/Main%20Screen/Feed%20Screen/Notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SimpleAuthentication extends StatefulWidget {
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
  const SimpleAuthentication(
      {super.key,
      required this.email,
      required this.Id,
      required this.image,
      required this.fname,
      required this.lname,
      required this.number,
      required this.location,
      required this.blood,
      required this.gender,
      required this.password});

  @override
  State<SimpleAuthentication> createState() => _SimpleAuthenticationState();
}

class _SimpleAuthenticationState extends State<SimpleAuthentication> {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  bool isClicked = false;
  bool isClicked1 = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showCircularProgressIndicator = false;
  String token = '';

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    email.text = widget.email;
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print('My device Token is here $value');
        token = value;
        print(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.w, 15.h, 0.w, 0),
                child: Center(
                  child: Text(
                    'Verification Code',
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
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
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    controller: email,
                    readOnly: true,
                    decoration: InputDecoration(
                      label: const Text('Email'),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color
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
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    controller: otp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Text('OTP'),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color
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
                        setState(() {
                          showCircularProgressIndicator = true;
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("OTP is verified"),
                        ));
                        _handleSignup();
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (showCircularProgressIndicator)
                          const SizedBox(
                            height: 20.0, // Set your desired height here
                            width: 20.0, // Set your desired width here
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        if (!showCircularProgressIndicator)
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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

  void _handleSignup() async {
    try {
      CollectionReference users = _firestore.collection('users');
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: widget.email).get();

      if (existingUsers.docs.isNotEmpty) {
        _showAlertDialog1(context);
      } else {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );

        String profileImageUrl = widget.image;

        // // ignore: unnecessary_null_comparison
        // ignore: unnecessary_null_comparison
        if (profileImageUrl != null) {
          final File imageFile = File(profileImageUrl);

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images/${result.user?.uid}.jpg');

          await storageRef.putFile(imageFile);
          profileImageUrl = await storageRef.getDownloadURL();
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_uid', result.user?.uid ?? '');
        prefs.setString('user_email', widget.email);
        // print('Add');

        // Store additional user information in Firestore
        await _firestore.collection('users').doc(result.user?.uid).set({
          'id': result.user?.uid,
          'firstname': widget.fname,
          'lastname': widget.lname,
          'deviceToken': token.toString(),
          'phonenumber': widget.number,
          'email': widget.email,
          'location': widget.location,
          'bloodgroup': widget.blood,
          'gender': widget.gender,
          'password': widget.password,
          'image': widget.image,
          'type': 'taker'
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );

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

      // Navigate to the home page or another screen after successful signup
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _showAlertDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content:
              const Text('Email is already Exist Pleae add diffirent email'),
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

  // ignore: unused_element
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Success"),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          content: Text("Account successfully Created"),
        );
      },
    );

    // Close the dialog after 5 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
}
