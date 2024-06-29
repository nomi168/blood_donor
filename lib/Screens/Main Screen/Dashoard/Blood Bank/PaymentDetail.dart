// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Blood%20Bank/PaymentsMethod.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentDetail extends StatefulWidget {
  const PaymentDetail({super.key});

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
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
                  'Subtotal',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0.h),
                child: SizedBox(
                    height: 20.h,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: Colors.black,
                      elevation: 10.0,
                      borderOnForeground: true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.black38, width: 1.0),
                        ),
                        child: Stack(children: [
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.w, 0.h, 50.w, 10.h),
                              child: Center(
                                  child: Text(
                                'Blood Price',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ))),
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(50.w, 0.h, 0.w, 10.h),
                              child: Center(
                                  child: Text(
                                '5000 Rs',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ))),
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.w, 7.h, 39.w, 10.h),
                              child: Center(
                                  child: Text(
                                'Delivery Charges',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ))),
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(50.w, 7.h, 0.w, 10.h),
                              child: Center(
                                  child: Text(
                                '50 Rs',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.w, 5.h, 63.w, 0.h),
                              child: Center(
                                  child: Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(50.w, 5.h, 0.w, 0.h),
                              child: Center(
                                  child: Text(
                                '5500 Rs',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ]),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 50.h, 5.w, 0),
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const PaymentsMethod();
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
}
