// ignore_for_file: file_names

import 'dart:developer';

import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/HelpCenter.dart';
import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/Invite.dart';
import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/Logout.dart';
import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/Settings.dart';
import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/TermsCondition.dart';
import 'package:blood_donor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      log("My State is $state");
      updateStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      log("My State is $state");
      updateStatus(true);
    }
  }

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
                      'Menu',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 5.h, 0, 0),
                      child: const Icon(
                        Icons.policy,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 5.h, 0, 0.h),
                        child: Text(
                          'Terms & Condition',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 5.h, 0, 0.h),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const TermsConditionScreen();
                                },
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(
                                      10.0, 0.0); // slide in from the right
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0),
                      child: const Icon(
                        Icons.insert_invitation,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0.h),
                        child: Text(
                          'Invite',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(55.5.w, 0.h, 0, 0.h),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const InviteScreen();
                                },
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(
                                      10.0, 0.0); // slide in from the right
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0),
                      child: const Icon(
                        Icons.help_center,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0.h),
                        child: Text(
                          'Help Center',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(42.5.w, 0.h, 0, 0.h),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const HelpCenterScreen();
                                },
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(
                                      10.0, 0.0); // slide in from the right
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0.h),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(49.w, 0.h, 0, 0.h),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const SettingsScreen();
                                },
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(
                                      10.0, 0.0); // slide in from the right
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0.h),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(49.5.w, 0.h, 0, 0.h),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 28,
                          ),
                          onPressed: () async {
                            _showLogoutDialog(context);
                          },
                        )),
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: PRIMARY_COLOR),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('user_uid');
                prefs.clear();
                updateStatus(false);
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const LogoutScreen();
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
                  (Route<dynamic> route) =>
                      false, // Predicate that removes all the routes
                );

                // Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login screen
              },
              child: Text(
                "Logout",
                style: TextStyle(color: PRIMARY_COLOR),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateStatus(bool isActive) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'status': isActive});
        log("My Statis is $isActive");
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
