// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Blood%20Bank/OrderDetail.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuantumBloodBank extends StatefulWidget {
  final String name;
  final String image;
  final String location;
  const QuantumBloodBank(
      {super.key,
      required this.name,
      required this.image,
      required this.location});

  @override
  State<QuantumBloodBank> createState() => _QuantumBloodBankState();
}

class _QuantumBloodBankState extends State<QuantumBloodBank> {
  bool isSelected = false;
  bool isSelected1 = false;
  bool isSelected2 = false;
  bool isSelected3 = false;
  bool isSelected4 = false;
  bool isSelected5 = false;
  bool isSelected6 = false;
  bool isSelected7 = false;
  int index = 0;
  int enable = 0;
  bool value = false;
  bool value1 = false;
  String number = '03331111234';

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.fromLTRB(0, 7.h, 0, 0),
                child: Center(
                    child: Text(
                  'Quantum Blood Bank',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: Colors.black54),
                ))),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0.h),
              child: SizedBox(
                  height: 24.h,
                  child: Material(
                    color: const Color(0xFFDE0A1E),
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Colors.black,
                    elevation: 10.0,
                    borderOnForeground: true,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black38, width: 1.0),
                      ),
                      child: Row(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.w, 0.h, 0.w, 5.h),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(23.w, 0.h, 0.w, 0.h),
                              child: Center(
                                  child: Image.network(
                                widget.image,
                                fit: BoxFit.fill,
                              ))),
                        ),
                      ]),
                    ),
                  )),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 2.h, 0.w, 0.h),
                  child: Text(
                    'Location:',
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 2.h, 0.w, 0.h),
                  child: Text(
                    widget.location,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 1.h, 0.w, 0.h),
                  child: Text(
                    number,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 1.h, 0.w, 0.h),
                  child: Text(
                    '00334567312',
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 0.w, 0.h),
              child: Text(
                'Blood Bank Stock',
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
                      height: 9.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = true;
                            isSelected1 = false;
                            isSelected2 = false;
                            isSelected3 = false;
                            isSelected4 = false;
                            isSelected5 = false;
                            isSelected6 = false;
                            isSelected7 = false;
                            enable = 1;

                            index = 1;
                          });
                        },
                        child: Material(
                          color: isSelected ? Colors.blueGrey : Colors.white,
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.w, 0, 0, 2.h),
                                    child: Image.asset(
                                      'images/blood.jpeg',
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.w, 5.5.h, 0, 0.h),
                                      child: Text(
                                        'A+',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0.h),
                    child: SizedBox(
                      height: 9.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected1 = true;
                            isSelected = false;
                            isSelected2 = false;
                            isSelected3 = false;
                            isSelected4 = false;
                            isSelected5 = false;
                            isSelected6 = false;
                            isSelected7 = false;
                            enable = 1;

                            index = 2;
                          });
                        },
                        child: Material(
                          color: isSelected1 ? Colors.blueGrey : Colors.white,
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.w, 0, 0, 2.h),
                                    child: Image.asset(
                                      'images/blood.jpeg',
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.w, 5.5.h, 0, 0.h),
                                      child: Text(
                                        'B+',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0.h),
                    child: SizedBox(
                      height: 9.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = false;
                            isSelected1 = false;
                            isSelected2 = true;
                            isSelected3 = false;
                            isSelected4 = false;
                            isSelected5 = false;
                            isSelected6 = false;
                            isSelected7 = false;
                            enable = 1;

                            index = 3;
                          });
                        },
                        child: Material(
                          color: isSelected2 ? Colors.blueGrey : Colors.white,
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.w, 0, 0, 2.h),
                                    child: Image.asset(
                                      'images/blood.jpeg',
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.w, 5.5.h, 0, 0.h),
                                      child: Text(
                                        'O-',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0.h),
                    child: SizedBox(
                      height: 9.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = false;
                            isSelected1 = false;
                            isSelected2 = false;
                            isSelected3 = true;
                            isSelected4 = false;
                            isSelected5 = false;
                            isSelected6 = false;
                            isSelected7 = false;
                            enable = 1;

                            index = 4;
                          });
                        },
                        child: Material(
                          color: isSelected3 ? Colors.blueGrey : Colors.white,
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.w, 0, 0, 2.h),
                                    child: Image.asset(
                                      'images/blood.jpeg',
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.w, 5.5.h, 0, 0.h),
                                      child: Text(
                                        'AB+',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0.h),
                    child: SizedBox(
                      height: 9.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = false;
                            isSelected1 = false;
                            isSelected2 = false;
                            isSelected3 = false;
                            isSelected4 = true;
                            isSelected5 = false;
                            isSelected6 = false;
                            isSelected7 = false;
                            enable = 1;

                            index = 5;
                          });
                        },
                        child: Material(
                          color: isSelected4 ? Colors.blueGrey : Colors.white,
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.w, 0, 0, 2.h),
                                    child: Image.asset(
                                      'images/blood.jpeg',
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.w, 5.5.h, 0, 0.h),
                                      child: Text(
                                        'A-',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0.h),
                    child: SizedBox(
                      height: 9.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = false;
                            isSelected1 = false;
                            isSelected2 = false;
                            isSelected3 = false;
                            isSelected4 = false;
                            isSelected5 = true;
                            isSelected6 = false;
                            isSelected7 = false;
                            enable = 1;

                            index = 6;
                          });
                        },
                        child: Material(
                          color: isSelected5 ? Colors.blueGrey : Colors.white,
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.w, 0, 0, 2.h),
                                    child: Image.asset(
                                      'images/blood.jpeg',
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.w, 5.5.h, 0, 0.h),
                                      child: Text(
                                        'B-',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0.h),
                    child: SizedBox(
                      height: 9.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = false;
                            isSelected1 = false;
                            isSelected2 = false;
                            isSelected3 = false;
                            isSelected4 = false;
                            isSelected5 = false;
                            isSelected6 = true;
                            isSelected7 = false;
                            enable = 1;

                            index = 7;
                          });
                        },
                        child: Material(
                          color: isSelected6 ? Colors.blueGrey : Colors.white,
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.w, 0, 0, 2.h),
                                    child: Image.asset(
                                      'images/blood.jpeg',
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.w, 5.5.h, 0, 0.h),
                                      child: Text(
                                        'O+',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0.h),
                    child: SizedBox(
                      height: 9.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = false;
                            isSelected1 = false;
                            isSelected2 = false;
                            isSelected3 = false;
                            isSelected4 = false;
                            isSelected5 = false;
                            isSelected6 = false;
                            isSelected7 = true;
                            enable = 1;

                            index = 8;
                          });
                        },
                        child: Material(
                          color: isSelected7 ? Colors.blueGrey : Colors.white,
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.w, 0, 0, 2.h),
                                    child: Image.asset(
                                      'images/blood.jpeg',
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.w, 5.5.h, 0, 0.h),
                                      child: Text(
                                        'AB-',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45),
                                      ))
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(3.w, 0, 0, 0),
                  child: Checkbox(
                    value: value,
                    checkColor: Colors.white,
                    activeColor: const Color(0xFFDE0A1E),
                    onChanged: (bool? value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.w, 0, 0.w, 0),
                  child: Text(
                    'You will get confirmation call after placing the order',
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(3.w, 0, 0, 0),
                  child: Checkbox(
                    value: value1,
                    checkColor: Colors.white,
                    activeColor: const Color(0xFFDE0A1E),
                    onChanged: (bool? value1) {
                      setState(() {
                        this.value1 = value1!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 2.h, 0.w, 0),
                    child: Text(
                      'Your Order will e delivered within 30 minutes to 2 hours depending on time and location ',
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
              child: Material(
                elevation: 10.0,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
                child: ElevatedButton(
                  onPressed: enable == 1
                      ? () {
                          String name = widget.name;
                          String blood = '';
                          String location = widget.location;
                          String image = widget.image;
                          if (isSelected == true) {
                            blood = 'A+';
                          }
                          if (isSelected1 == true) {
                            blood = 'B+';
                          }
                          if (isSelected2 == true) {
                            blood = 'O+';
                          }
                          if (isSelected3 == true) {
                            blood = 'AB+';
                          }
                          if (isSelected4 == true) {
                            blood = 'A-';
                          }
                          if (isSelected5 == true) {
                            blood = 'B-';
                          }
                          if (isSelected6 == true) {
                            blood = 'O-';
                          }

                          if (isSelected7 == true) {
                            blood = 'AB-';
                          }
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return OrderDetail(
                                    name: name,
                                    location: location,
                                    number: number,
                                    image: image,
                                    blood: blood);
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
                        }
                      : null,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 36.5.w),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        // Change color based on index
                        if (states.contains(MaterialState.disabled)) {
                          // Color when the button is disabled
                          return Colors.black54;
                        }
                        return const Color(
                            0xFFDE0A1E); // Color when the button is enabled
                      },
                    ),
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
            )
          ]),
        ),
      );
    }));
  }
}
