// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/AccountScreen.dart';
import 'package:blood_donor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  bool isFormVisible = true;
  TextEditingController home = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController travel = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const AccountScreen();
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
              ),
              Spacer(),
              Text(
                'Manage Address',
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              textAlign: TextAlign.center,
              'Add multiple location where you can travel to donate blood',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 0.0, // Ensure minWidth is not negative
              ),
              child: TextFormField(
                controller: home,
                decoration: InputDecoration(
                  label: const Text('Location'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: SizedBox(
                    height: 1.h,
                    width: 25.w,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 1.h),
                      child: ElevatedButton(
                        onPressed: () {
                          if (home.text.isNotEmpty) {
                            _addAddressHome();
                          } else {
                            _showAlertDialog(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // Set borderRadius to 0 for flat corners
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Location',
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth:
                    2.0, // Set minWidth to 0 to avoid negative constraints
              ),
              child: TextFormField(
                controller: work,
                decoration: InputDecoration(
                  label: const Text('Location'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: SizedBox(
                    height: 1.h,
                    width: 25.w,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 1.h),
                      child: ElevatedButton(
                        onPressed: () {
                          if (work.text.isNotEmpty) {
                            _addAddressWork();
                          } else {
                            _showAlertDialog(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // Set borderRadius to 0 for flat corners
                          ),
                        ),
                        child: Center(
                          child: Text('Work',
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Location',
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Add more',
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 6.h,
                  width: 15.w,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFormVisible = !isFormVisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      backgroundColor: PRIMARY_COLOR,
                      padding: const EdgeInsets.all(12.0),
                    ),
                    child: const Icon(Icons.add, size: 24, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: !isFormVisible,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
              child: Material(
                elevation: 7.0,
                borderRadius: BorderRadius.circular(10.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 2.0,
                  ),
                  child: TextFormField(
                    controller: travel,
                    decoration: InputDecoration(
                      label: const Text('Location'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: SizedBox(
                        height: 1.h,
                        width: 25.w,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 1.h),
                          child: ElevatedButton(
                            onPressed: () {
                              if (travel.text.isNotEmpty) {
                                _addAddressTravel();
                              } else {
                                _showAlertDialog(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Travel',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Location',
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  void _addAddressHome() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print(userEmail);
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Save user data in the 'taker' collection
      await _firestore.collection('useraddress').add({
        'email': userEmail,
        'address': home.text,
        'type': 'home',
      });

      _showAlertDialog2(context);
    } catch (error) {
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _addAddressWork() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print(userEmail);
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Save user data in the 'taker' collection
      await _firestore.collection('useraddress').add({
        'email': userEmail,
        'address': work.text,
        'type': 'work',
      });

      _showAlertDialog2(context);
    } catch (error) {
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _addAddressTravel() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print(userEmail);
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Save user data in the 'taker' collection
      await _firestore.collection('useraddress').add({
        'email': userEmail,
        'address': travel.text,
        'type': 'travel',
      });

      _showAlertDialog2(context);
    } catch (error) {
      print("Error in _handleSignup: $error");
      // Handle error and show a proper error message to the user
    }
  }

  void _showAlertDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Address added Successfullt:'),
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

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Required Location'),
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
