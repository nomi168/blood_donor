// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:io';

import 'package:blood_donor/Screens/Main%20Screen/Feed%20Screen/Notification.dart';
import 'package:blood_donor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../Provider/Page.dart';

class QuestionsScreen extends StatefulWidget {
  final String email;
  final String image;
  final String fname;
  final String lname;
  final String number;
  final String location;
  final String blood;
  final String gender;
  final String password;
  final int id;
  const QuestionsScreen(
      {super.key,
      required this.id,
      required this.number,
      required this.email,
      required this.location,
      required this.blood,
      required this.gender,
      required this.password,
      required this.image,
      required this.fname,
      required this.lname});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  String Q1 = '';
  String Q2 = '';
  String Q3 = '';
  String Q4 = '';
  String Q5 = '';
  String Q6 = '';
  String type = '';
  bool flag = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showCircularProgressIndicator = false;
  String token = '';
  String picture = '';
  String user_id = '';
  bool privacy_process = false;

  NotificationServices notificationServices = NotificationServices();

  getNotificationToken() async {
    String token1 = await notificationServices.getDeviceToken();
    token = token1;
  }

  @override
  void initState() {
    getNotificationToken();
    super.initState();
    // notificationServices.getDeviceToken().then((value) {
    //   print('device token');
    //   print('My device Token is here $value');
    //   token = value;
    //   print(token);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 0, 0),
              child: Text(
                'Questionnaires',
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
              child: Text(
                'Fill up the following Questionnaires and become a donor',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
              child: Material(
                color: Colors.white,
                elevation: 5,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 10.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Stack(children: [
                    Padding(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 37.w, 0),
                      child: Text(
                        'Do you have diabetes?',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 3.h, 0.w, 0.h),
                          child: RadioListTile<String>(
                            title: const Text('Yes'),
                            value: 'Yes',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q1,
                            onChanged: (value) {
                              setState(() {
                                Q1 = value!;
                                flag = true;
                              });
                            },
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 3.h, 0.w, 0.h),
                          child: RadioListTile<String>(
                            title: const Text('No'),
                            value: 'No',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q1,
                            onChanged: (value) {
                              setState(() {
                                Q1 = value!;
                              });
                            },
                          ),
                        )),
                      ],
                    )
                  ]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
              child: Material(
                color: Colors.white,
                elevation: 5,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Stack(children: [
                    Padding(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 0.w, 0),
                      child: Text(
                        'Have you ever had problems with your heart or lungs?',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 5.h, 0.w, 0.h),
                          child: RadioListTile<String>(
                            title: const Text('Yes'),
                            value: 'Yes',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q2,
                            onChanged: (value) {
                              setState(() {
                                Q2 = value!;
                                flag = true;
                              });
                            },
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 5.h, 10.w, 0),
                          child: RadioListTile<String>(
                            title: const Text('No'),
                            value: 'No',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q2,
                            onChanged: (value) {
                              setState(() {
                                Q2 = value!;
                              });
                            },
                          ),
                        )),
                      ],
                    )
                  ]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
              child: Material(
                color: Colors.white,
                elevation: 5,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 11.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Stack(children: [
                    Padding(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 0.w, 0),
                      child: Text(
                        'In the last 28 days do you have had COVID-19?',
                        style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 3.h, 0.w, 1.h),
                          child: RadioListTile<String>(
                            title: const Text('Yes'),
                            value: 'Yes',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q3,
                            onChanged: (value) {
                              setState(() {
                                Q3 = value!;
                              });
                            },
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 3.h, 10.w, 1.h),
                          child: RadioListTile<String>(
                            title: const Text('No'),
                            value: 'No',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q3,
                            onChanged: (value) {
                              setState(() {
                                Q3 = value!;
                              });
                            },
                          ),
                        )),
                      ],
                    )
                  ]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
              child: Material(
                color: Colors.white,
                elevation: 5,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 12.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Stack(children: [
                    Padding(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 0.w, 0),
                      child: Text(
                        'Have you ever had a positive test for the HIV/AIDS virus?',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 5.h, 0.w, 1.h),
                          child: RadioListTile<String>(
                            title: const Text('Yes'),
                            value: 'Yes',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q4,
                            onChanged: (value) {
                              setState(() {
                                Q4 = value!;
                                flag = true;
                              });
                            },
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 5.h, 10.w, 1.h),
                          child: RadioListTile<String>(
                            title: const Text('No'),
                            value: 'No',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q4,
                            onChanged: (value) {
                              setState(() {
                                Q4 = value!;
                              });
                            },
                          ),
                        )),
                      ],
                    )
                  ]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
              child: Material(
                color: Colors.white,
                elevation: 5,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 9.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Stack(children: [
                    Padding(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 0.w, 0),
                      child: Text(
                        'Have you ever had cancer?',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(1.w, 2.5.h, 0.w, 1.h),
                          child: RadioListTile<String>(
                            title: const Text('Yes'),
                            value: 'Yes',
                            groupValue: Q5,
                            activeColor: PRIMARY_COLOR,
                            onChanged: (value) {
                              setState(() {
                                Q5 = value!;
                                flag = true;
                              });
                            },
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 2.5.h, 10.w, 1.h),
                          child: RadioListTile<String>(
                            title: const Text('No'),
                            value: 'No',
                            groupValue: Q5,
                            activeColor: PRIMARY_COLOR,
                            onChanged: (value) {
                              setState(() {
                                Q5 = value!;
                              });
                            },
                          ),
                        )),
                      ],
                    )
                  ]),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
              child: Material(
                color: Colors.white,
                elevation: 5,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 11.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Stack(children: [
                    Padding(
                      // ignore: prefer_const_constructors
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 0.w, 0),
                      child: Text(
                        'In the last 3 months have you had a vaccination',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(1.w, 4.5.h, 0.w, 1.h),
                          child: RadioListTile<String>(
                            title: const Text('Yes'),
                            value: 'Yes',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q6,
                            onChanged: (value) {
                              setState(() {
                                Q6 = value!;
                              });
                            },
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0.w, 4.5.h, 10.w, 1.h),
                          child: RadioListTile<String>(
                            title: const Text('No'),
                            value: 'No',
                            activeColor: PRIMARY_COLOR,
                            groupValue: Q6,
                            onChanged: (value) {
                              setState(() {
                                Q6 = value!;
                              });
                            },
                          ),
                        )),
                      ],
                    )
                  ]),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(2.w, 0.h, 0.w, 0),
                  child: Checkbox(
                    value: type == 'Yes',
                    checkColor: Colors.white,
                    focusColor: Colors.red,
                    activeColor: Colors.red,

                    // Check if ttype is 'donor'
                    onChanged: (bool? value) {
                      setState(() {
                        type = value == true ? 'Yes' : '';

                        // Update ttype based on checkbox state
                      });
                    },
                  ),
                ),
                Text(
                  'By clicking, you agree to our terms and codition',
                  style:
                      TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
              child: Material(
                elevation: 10.0,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (type == 'Yes') {
                      if (Q1.isNotEmpty &&
                          Q2.isNotEmpty &&
                          Q3.isNotEmpty &&
                          Q4.isNotEmpty &&
                          Q5.isNotEmpty &&
                          Q6.isNotEmpty) {
                        setState(() {
                          showCircularProgressIndicator = true;
                        });
                        if (Q1 == 'Yes' ||
                            Q2 == 'Yes' ||
                            Q4 == 'Yes' ||
                            Q5 == 'Yes') {
                          // authBloc.questionresult = true;
                          // bool response = authBloc.questionresult;
                          // authBloc.notifyListeners();

                          _showAlertDialog4(
                            context,
                          );
                        } else {
                          _uploadImage();
                        }
                      } else {
                        _showAlertDialog6(context);
                      }
                    } else {
                      _showAlertDialog5(context);
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
                          height: 20.0,
                          width: 20.0,
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
  }

  void _showAlertDialog4(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text(
              'You are not Eligible for donate Blood Only you have take the Blood.\nClick on OK button then create a simple account'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                Navigator.pop(context);
                _uploadImage1();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog6(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Must be Check Questionares!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the alert dialog
                setState(() {
                  showCircularProgressIndicator = false;
                });
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog5(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Please must be check Terms and Conditions:'),
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

  Future<void> _uploadImage() async {
    // ignore: unnecessary_null_comparison
    if (widget.image == null) return;

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now()}.jpg');

    final UploadTask uploadTask = storageReference.putFile(File(widget.image));
    await uploadTask.whenComplete(() => null);

    final imageUrl = await storageReference.getDownloadURL();

    setState(() {
      picture = imageUrl;
    });
    _handleSignup();
  }

  Future<void> _uploadImage1() async {
    // ignore: unnecessary_null_comparison
    if (widget.image == null) return;

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now()}.jpg');

    final UploadTask uploadTask = storageReference.putFile(File(widget.image));
    await uploadTask.whenComplete(() => null);

    final imageUrl = await storageReference.getDownloadURL();

    setState(() {
      picture = imageUrl;
    });
    _handleSignup1();
  }

  void _handleSignup() async {
    try {
      print(token);
      CollectionReference users = _firestore.collection('users');
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: widget.email).get();

      if (existingUsers.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        _showAlertDialog1(context);
      } else {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );

        // String profileImageUrl = widget.image;

        // // ignore: unnecessary_null_comparison
        // ignore: unnecessary_null_comparison
        // if (profileImageUrl != null) {
        //   final File imageFile = File(profileImageUrl);

        //   final storageRef = FirebaseStorage.instance
        //       .ref()
        //       .child('profile_images/${result.user?.uid}.jpg');

        //   await storageRef.putFile(imageFile);
        //   profileImageUrl = await storageRef.getDownloadURL();
        // }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_uid', result.user?.uid ?? '');
        prefs.setString('user_email', widget.email);
        user_id = result.user!.uid;
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
          'image': picture,
          'type': 'donor',
          'status': false,
          'availabledonate': false
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );
        String name = widget.fname + " " + widget.lname;
        EasyLoading.showSuccess('Create Account Successfully!');

        showCircularProgressIndicator = false;
        setState(() {});
        Future.delayed(Duration(seconds: 2), () {
          _usereligible();
          _userAddLocations(name, widget.location, picture);
        });

        // ignore: use_build_context_synchronously
        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation, secondaryAnimation) {
        //       return const Dashboard();
        //     },
        //     transitionDuration: const Duration(seconds: 1),
        //     transitionsBuilder:
        //         (context, animation, secondaryAnimation, child) {
        //       const begin = Offset(10.0, 0.0); // slide in from the right
        //       const end = Offset.zero;
        //       const curve = Curves.easeInOutQuart;

        //       var tween =
        //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //       var offsetAnimation = animation.drive(tween);

        //       return SlideTransition(
        //         position: offsetAnimation,
        //         child: child,
        //       );
        //     },
        //   ),
        // );
      }

      // Navigate to the home page or another screen after successful signup
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      setState(() {
        showCircularProgressIndicator = false;
        EasyLoading.showError(
            "The email address is already in use by another account");
      });
    }
  }

  // Future<void> _uploadImage() async {
  //   if (widget.image.isEmpty) return;

  //   final Reference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('profile_images/${DateTime.now()}.jpg');

  //   final UploadTask uploadTask = storageReference.putFile(File(widget.image));
  //   await uploadTask.whenComplete(() => null);

  //   final imageUrl = await storageReference.getDownloadURL();

  //   setState(() {
  //     _imageUrl = imageUrl;
  //   });
  //   _handleSignup();
  // }

  void _handleSignup1() async {
    try {
      final authprovider = Provider.of<MyPageProvider>(context, listen: false);
      print(token);
      CollectionReference users = _firestore.collection('users');
      QuerySnapshot existingUsers =
          await users.where('email', isEqualTo: widget.email).get();

      if (existingUsers.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
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

        user_id = result.user!.uid;
        authprovider.notifyListeners();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_uid', result.user?.uid ?? '');
        prefs.setString('user_email', widget.email);
        prefs.setString('user_image', widget.image);
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
          'image': picture,
          'type': 'taker',
          'status': false,
          'availabledonate': false
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );
        EasyLoading.showSuccess('Create Acccount Successfully!');

        showCircularProgressIndicator = false;
        setState(() {});
        Future.delayed(Duration(seconds: 2), () {
          _usereligible1();
        });

        // ignore: use_build_context_synchronously
        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation, secondaryAnimation) {
        //       return const Dashboard();
        //     },
        //     transitionDuration: const Duration(seconds: 1),
        //     transitionsBuilder:
        //         (context, animation, secondaryAnimation, child) {
        //       const begin = Offset(10.0, 0.0); // slide in from the right
        //       const end = Offset.zero;
        //       const curve = Curves.easeInOutQuart;

        //       var tween =
        //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //       var offsetAnimation = animation.drive(tween);

        //       return SlideTransition(
        //         position: offsetAnimation,
        //         child: child,
        //       );
        //     },
        //   ),
        // );
      }

      // Navigate to the home page or another screen after successful signup
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _userAddLocations(String name, String location, String image) async {
    try {
      // Store additional user information in Firestore
      await _firestore.collection('donor_location').add({
        'user_id': user_id,
        'donor_name': name,
        'donor_location': location,
        'donor_image': image
      });
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _usereligible1() async {
    try {
      // Store additional user information in Firestore
      await _firestore.collection('terms_condition').add({
        'user_id': user_id,
        'donation_process': false,
        'eligibility': false,
        'hygiene': false,
        'safety': false,
        'privacy_policy': true,
      });
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _usereligible() async {
    try {
      // Store additional user information in Firestore
      await _firestore.collection('terms_condition').add({
        'user_id': user_id,
        'donation_process': true,
        'eligibility': true,
        'hygiene': true,
        'safety': true,
        'privacy_policy': true
      });
    } catch (error) {
      // ignore: avoid_print
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  // void addDataToFirestore() async {
  //   // ignore: unrelated_type_equality_checks

  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   CollectionReference users = firestore.collection('users');
  //   QuerySnapshot existingUsers =
  //       await users.where('email', isEqualTo: widget.email).get();
  //   if (existingUsers.docs.isNotEmpty) {
  //     // ignore: use_build_context_synchronously
  //     _showAlertDialog1(context);
  //   } else {
  //     await users.add({
  //       'id': widget.id,
  //       'firstname': widget.fname,
  //       'lastname': widget.lname,
  //       'phonenumber': widget.number,
  //       'email': widget.email,
  //       'location': widget.location,
  //       'bloodgroup': widget.blood,
  //       'gender': widget.gender,
  //       'password': widget.password,
  //       'image': widget.image,
  //       'type': 'donor'
  //     });
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushReplacement(
  //       context,
  //       PageRouteBuilder(
  //         pageBuilder: (context, animation, secondaryAnimation) {
  //           return const Dashboard();
  //         },
  //         transitionDuration: const Duration(seconds: 1),
  //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //           const begin = Offset(10.0, 0.0); // slide in from the right
  //           const end = Offset.zero;
  //           const curve = Curves.easeInOutQuart;

  //           var tween =
  //               Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //           var offsetAnimation = animation.drive(tween);

  //           return SlideTransition(
  //             position: offsetAnimation,
  //             child: child,
  //           );
  //         },
  //       ),
  //     );
  //   }
  //   // ignore: avoid_print
  //   print('User data added to Firestore!');
  // }

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
                setState(() {
                  showCircularProgressIndicator = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
