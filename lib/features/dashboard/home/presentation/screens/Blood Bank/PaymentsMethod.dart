// ignore_for_file: file_names

import 'package:blood_donor/features/dashboard/home/presentation/screens/Blood%20Bank/PaymentsConfirm.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentsMethod extends StatefulWidget {
  const PaymentsMethod({super.key});

  @override
  State<PaymentsMethod> createState() => _PaymentsMethodState();
}

class _PaymentsMethodState extends State<PaymentsMethod> {
  bool isSelected = false;
  bool isSelected1 = false;
  bool isSelected2 = false;
  int index = 0;
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
                  'Add Payment Method',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(6.w, 2.h, 0, 0),
                  child: SizedBox(
                    height: 6.h,
                    width: 15.w,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.w, 0, 0, 1.h),
                          child: const Icon(Icons.add,
                              size: 24, color: Colors.white),
                        )),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(6.w, 2.h, 0.w, 0),
                child: Text(
                  'Cards',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.h, 70.w, 0.h),
                child: SizedBox(
                    height: 7.h,
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
                        child: Center(
                            child: Text(
                          'Visa',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 10, 119, 208)),
                        )),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(6.w, 2.h, 0.w, 0),
                child: Text(
                  'Mobile Banking',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0.h),
                      child: SizedBox(
                        height: 7.h,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = true;
                              isSelected1 = false;
                              isSelected2 = false;
                              index = 1;
                            });
                          },
                          child: Material(
                            color: isSelected ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            shadowColor: Colors.black,
                            elevation: 10.0,
                            borderOnForeground: true,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.black38, width: 1.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Easypaisa',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 101, 123, 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0.h),
                      child: SizedBox(
                        height: 7.h,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected1 = true;
                              isSelected = false;
                              isSelected2 = false;
                              index = 2;
                            });
                          },
                          child: Material(
                            color: isSelected1 ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            shadowColor: Colors.black,
                            elevation: 10.0,
                            borderOnForeground: true,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.black38, width: 1.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Jazz Cash',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 101, 123, 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0.h),
                      child: SizedBox(
                        height: 7.h,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected2 = true;
                              isSelected = false;
                              isSelected1 = false;
                              index = 3;
                            });
                          },
                          child: Material(
                            color: isSelected2 ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            shadowColor: Colors.black,
                            elevation: 10.0,
                            borderOnForeground: true,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.black38, width: 1.0),
                              ),
                              child: Center(
                                child: Text(
                                  'U Paisa',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 101, 123, 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 38.h, 5.w, 0),
                child: Material(
                  elevation: 10.0,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // ignore: non_constant_identifier_names
                      // String Name = hospital.text;
                      // ignore: non_constant_identifier_names
                      String Name = '';
                      if (index == 1) {
                        Name = 'Easypaisa';
                      }
                      if (index == 2) {
                        Name = 'Jazz Cash';
                      }
                      if (index == 3) {
                        Name = 'U Paisa';
                      }
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return PaymentsConfirm(Name: Name);
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
