// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/AccountScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentInfoScreen extends StatefulWidget {
  const PaymentInfoScreen({super.key});

  @override
  State<PaymentInfoScreen> createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends State<PaymentInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orietation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
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
                                return const AccountScreen();
                              },
                              transitionDuration: const Duration(seconds: 1),
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
                            ),
                          );
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 5.h, 0, 0),
                    child: Text(
                      'Payment Info',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                child: Image.asset('images/image1.jpeg'),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
                child: Text(
                  'Comming Soon',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
