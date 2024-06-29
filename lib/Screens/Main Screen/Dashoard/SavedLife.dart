// ignore_for_file: file_names

import 'package:blood_donor/Provider/RewardPoints.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Dashboatd.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Emergency%20Donor/SubcriptionPlan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SavedLife extends StatefulWidget {
  const SavedLife({super.key});

  @override
  State<SavedLife> createState() => _SavedLifeState();
}

class _SavedLifeState extends State<SavedLife> {
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
                      padding: EdgeInsets.fromLTRB(0.w, 9.h, 0, 0),
                      child: Center(
                        child: Text(
                          'Congratulations !!',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDE0A1E)),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.w, 1.h, 0, 0),
                      child: Center(
                        child: Text(
                          'You have save 7 Life till now',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.w, 3.h, 0, 0),
                      child: Center(child: Image.asset('images/pic2.jpeg'))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                    child: SizedBox(
                        height: 8.h,
                        width: 100.w,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          shadowColor: Colors.black,
                          elevation: 10.0,
                          borderOnForeground: true,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                                  Border.all(color: Colors.black26, width: 1.0),
                            ),
                            child: Stack(children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(5.w, 2.h, 0, 0),
                                child: Text(
                                  'Reward Points',
                                  style: TextStyle(
                                      color: const Color(0xFFDE0A1E),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(60.w, 0.h, 0, 0.7.h),
                                  child: Image.asset(
                                    'images/award.jpeg',
                                    height: 10.h,
                                    width: 10.w,
                                  )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(73.w, 2.h, 0, 0),
                                child: Text(
                                  '300',
                                  style: TextStyle(
                                      color: const Color(0xFFDE0A1E),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ]),
                          ),
                        )),
                  ),
                  Consumer<RewardPoints>(
                    builder: (context, value, child) {
                      return Slider(
                        value: value.changevalue,
                        min: 0.0,
                        max: 100.0,
                        onChanged: (newValue) {
                          // Use the provider to update the value in RewardPoints
                          Provider.of<RewardPoints>(context, listen: false)
                              .ChangeValue(newValue);
                        },
                        activeColor: Colors.red, // Set the active color to red
                      );
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(7.w, 0.h, 0, 0),
                        child: Text(
                          'Donator',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0),
                        child: Text(
                          'Life Savior',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 0.h, 0, 0),
                        child: Text(
                          'SuperHero',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0.w, 0.h, 4.w, 0),
                              child: CircleAvatar(
                                radius: 20,
                                child: Image.asset(
                                  'images/do.png',
                                ),
                              ))),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0, 0),
                              child: CircleAvatar(
                                  radius: 30,
                                  child: Image.asset('images/person1.png')))),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0, 0),
                              child: CircleAvatar(
                                  radius: 20,
                                  child: Image.asset('images/hero.jpeg')))),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                      child: Center(
                        child: Text(
                          'Share your achievement on social media and let',
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
                      child: Center(
                        child: Text(
                          'friends know how you are saving valuable lives',
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                        ),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                          child: Material(
                            elevation: 10.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // ignore: non_constant_identifier_names
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return const Dashboard();
                                    },
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(
                                          10.0, 0.0); // slide in from the right
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOutQuart;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  // Increase horizontal padding
                                  // ignore: prefer_const_constructors
                                  EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 5.w),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              child: Text(
                                'Now, Later',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.w, 3.h, 5.w, 0),
                          child: Material(
                            elevation: 10.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // ignore: non_constant_identifier_names
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return const SubscriptionPlan();
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(
                                          10.0, 0.0); // slide in from the right
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOutQuart;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  // Increase horizontal padding
                                  // ignore: prefer_const_constructors
                                  EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 10..w),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFFDE0A1E)),
                              ),
                              child: Text(
                                'Share',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ])));
      },
    );
  }
}
