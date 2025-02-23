// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/MenuScreen.dart';
import 'package:blood_donor/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const MenuScreen();
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
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 5.h, 0, 0),
              child: Text(
                'Help Center',
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0),
          child: Image.asset('images/image1.jpeg'),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'E-blood is an online blood donation app where user can donate blood anywhere and anytime.',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 20),
          // padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.black12),
          child: Text(
            '24/7',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Need Help',
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Text(
          'Tell us how we can help you',
          style: TextStyle(
              fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            textAlign: TextAlign.center,
            'It looks like you are experiencing problem while using our app.We are here to help so please get in touch with us.',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 100),
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.black12),
          child: InkWell(
            onTap: () {
              showEmailPopup(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(08),
                  color: Colors.grey.withOpacity(0.3)),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0),
                      child: Icon(
                        Icons.email,
                        size: 70,
                        color: PRIMARY_COLOR,
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 1.h, 0, 0),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  void showEmailPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Owner Email"),
          content: Text('nafeesmazhar1661@gmail.com'),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
