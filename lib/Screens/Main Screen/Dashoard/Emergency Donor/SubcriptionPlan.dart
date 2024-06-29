// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Emergency%20Donor/Emergencydonor.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/SavedLife.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

class _SubscriptionPlanState extends State<SubscriptionPlan> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, oreientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Column(children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(2.w, 5.h, 0, 0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return const SavedLife();
                              },
                              transitionDuration: const Duration(seconds: 2),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(
                                    -10.0, 0.0); // slide in from the left
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
                            ));
                      },
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 5.h, 0, 0),
                  child: Text(
                    'Subsciption Plan',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2.h, 0, 0),
              child: Center(
                child: Image.asset('images/pic3.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22.w, 0.h, 22.w, 0.h),
              child: SizedBox(
                  height: 8.h,
                  width: 100.w,
                  child: Material(
                    color: const Color(0xFFDE0A1E),
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Colors.black,
                    elevation: 10.0,
                    borderOnForeground: true,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black26, width: 1.0),
                      ),
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.w, 2.h, 0, 0),
                          child: Text(
                            'Rs 1000',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                    ),
                  )),
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 2.h, 1.w, 0.h),
                    child: SizedBox(
                        height: 12.h,
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
                                  Border.all(color: Colors.black38, width: 1.0),
                            ),
                            child: Stack(children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 0.h, 0, 4.h),
                                  child: Center(
                                    child: Image.asset(
                                      'images/active.jpeg',
                                      width: 10.w,
                                      height: 10.h,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 2.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    '24/7',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 6.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Active',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                            ]),
                          ),
                        )),
                  ),
                  onTap: () {
                    // ignore: avoid_print
                    print('Nomi');
                  },
                )),
                Expanded(
                    child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(2.w, 2.h, 3.w, 0.h),
                    child: SizedBox(
                        height: 12.h,
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
                                  Border.all(color: Colors.black38, width: 1.0),
                            ),
                            child: Stack(children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 0.h, 0, 4.h),
                                  child: Center(
                                    child: Image.asset(
                                      'images/speed.jpeg',
                                      width: 10.w,
                                      height: 10.h,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 2.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Fast',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 6.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Reach',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                            ]),
                          ),
                        )),
                  ),
                  onTap: () {
                    // ignore: avoid_print
                    print('Nomi');
                  },
                )),
                Expanded(
                    child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 2.h, 6.w, 0.h),
                    child: SizedBox(
                        height: 12.h,
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
                                  Border.all(color: Colors.black38, width: 1.0),
                            ),
                            child: Stack(children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 0.h, 0, 4.h),
                                  child: Center(
                                    child: Image.asset(
                                      'images/cross.jpg',
                                      width: 23.w,
                                      height: 23.h,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 2.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'No Health',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 6.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Issue',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                            ]),
                          ),
                        )),
                  ),
                  onTap: () {
                    // ignore: avoid_print
                    print('Nomi');
                  },
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 2.h, 1.w, 0.h),
                    child: SizedBox(
                        height: 12.h,
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
                                  Border.all(color: Colors.black38, width: 1.0),
                            ),
                            child: Stack(children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 0.h, 0, 5.h),
                                  child: Center(
                                    child: Image.asset(
                                      'images/person.png',
                                      width: 10.w,
                                      height: 10.h,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 2.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Highly',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 6.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Experienced',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                            ]),
                          ),
                        )),
                  ),
                  onTap: () {
                    // ignore: avoid_print
                    print('Nomi');
                  },
                )),
                Expanded(
                    child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(2.w, 2.h, 3.w, 0.h),
                    child: SizedBox(
                        height: 12.h,
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
                                  Border.all(color: Colors.black38, width: 1.0),
                            ),
                            child: Stack(children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 0.h, 0, 4.h),
                                  child: Center(
                                    child: Image.asset(
                                      'images/good.png',
                                      width: 30.w,
                                      height: 30.h,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 2.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Good',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 6.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Behaviour',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                            ]),
                          ),
                        )),
                  ),
                  onTap: () {
                    // ignore: avoid_print
                    print('Nomi');
                  },
                )),
                Expanded(
                    child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 2.h, 6.w, 0.h),
                    child: SizedBox(
                        height: 12.h,
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
                                  Border.all(color: Colors.black38, width: 1.0),
                            ),
                            child: Stack(children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 0.h, 0, 4.h),
                                  child: Center(
                                    child: Image.asset(
                                      'images/injection.png',
                                      width: 15.w,
                                      height: 15.h,
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 2.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Covid',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.w, 6.h, 0, 0.h),
                                  child: Center(
                                      child: Text(
                                    'Vaccinated',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ))),
                            ]),
                          ),
                        )),
                  ),
                  onTap: () {
                    // ignore: avoid_print
                    print('Nomi');
                  },
                ))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
              child: Text(
                'By purcahsing premium donors package,you will get the best,service in emergency situation',
                style: TextStyle(fontSize: 12.sp, color: Colors.black54),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
              child: Material(
                elevation: 10.0,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    // ignore: non_constant_identifier_names
                    // String Name = hospital.text;
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const EmergencyDonor();
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
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      // Increase horizontal padding
                      // ignore: prefer_const_constructors
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 28.w),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFDE0A1E)),
                  ),
                  child: Text(
                    'Emergency donor',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }
}
