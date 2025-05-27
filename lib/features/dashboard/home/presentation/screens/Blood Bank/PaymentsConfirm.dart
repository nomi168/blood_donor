// ignore_for_file: file_names, non_constant_identifier_names

import 'package:blood_donor/features/dashboard/home/presentation/screens/Dashboatd.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentsConfirm extends StatefulWidget {
  final String Name;
  const PaymentsConfirm({super.key, required this.Name});

  @override
  State<PaymentsConfirm> createState() => _PaymentsConfirmState();
}

class _PaymentsConfirmState extends State<PaymentsConfirm> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          Navigator.pop(context);
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 5.h, 0, 0),
                    child: Text(
                      'Payment',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 3.h, 0.w, 0),
                child: Text(
                  'Payment Method',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0.h),
                child: SizedBox(
                    height: 7.h,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: Colors.black,
                      elevation: 10.0,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border:
                                Border.all(color: Colors.black38, width: 1.0),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
                                  child: Text(
                                    widget.Name,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 10, 119, 208)),
                                  )),
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(50.w, 0, 0, 0),
                                    child: const Icon(Icons.payment)),
                              )
                            ],
                          )),
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 65.h, 5.w, 0),
                child: Material(
                  elevation: 10.0,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                  child: ElevatedButton(
                    onPressed: _showDonatePopup,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        // Increase horizontal padding
                        // ignore: prefer_const_constructors
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 36.5.w),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFDE0A1E)),
                    ),
                    child: Text(
                      'Continue',
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
          ));
    });
  }

  void _showDonatePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.white,
          title: Center(
            child: Column(
              children: [
                // Your image goes here
                Image.asset(
                  'images/svg1.png',
                  height: 40.h,
                  width: 40.w,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Payment is Done.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Your donation popup content goes here
              Text(
                'Wait for the Confirmation call from the blood bank',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // variables.location = widget.Name;
                    // variables.name = widget.name;
                    // variables.distance = widget.distance;
                    // variables.blood = widget.blood;
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const Dashboard();
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
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 8,
                      padding: EdgeInsets.all(4.0.w),
                      backgroundColor: const Color(0xFFDE0A1E)),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
