// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Menu%20Screens/MenuScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitched = true;
  bool isSwitched1 = false;
  bool isSwitched2 = false;
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
              padding: EdgeInsets.fromLTRB(25.w, 5.h, 0, 0),
              child: Text(
                'Settings',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 1.0, // Top border width (optional)
              ),
              left: BorderSide(
                color: Colors.grey, // Red left border color
                width: 1.0, // Left border width (optional)
              ),
              right: BorderSide(
                color: Colors.grey, // Red right border color
                width: 1.0, // Right border width (optional)
              ),
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0.0, 0, 0),
                child: Text(
                  'Sound',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Switch(
                  value: isSwitched,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched = value;
                      // ignore: avoid_print
                      print('Switch is turned ${isSwitched ? 'on' : 'off'}');
                    });
                  },
                  activeColor: Colors.red, // Customize the color when turned on
                  inactiveThumbColor:
                      Colors.redAccent, // Customize the color when turned off
                ),
              )
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 1.0, // Top border width (optional)
                ),
                left: BorderSide(
                  color: Colors.grey, // Red left border color
                  width: 1.0, // Left border width (optional)
                ),
                right: BorderSide(
                  color: Colors.grey, // Red right border color
                  width: 1.0, // Right border width (optional)
                ),
              ),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 0, 0),
                  child: Text(
                    'Vibrate',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Switch(
                      value: isSwitched1,
                      onChanged: (bool value) {
                        setState(() {
                          isSwitched1 = value;
                          // ignore: avoid_print
                          print(
                              'Switch is turned ${isSwitched1 ? 'on' : 'off'}');
                        });
                      },
                      activeColor:
                          Colors.red, // Customize the color when turned on
                      inactiveThumbColor: Colors
                          .redAccent, // Customize the color when turned off
                    ))
              ],
            )),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 1.0, // Top border width (optional)
                ),
                left: BorderSide(
                  color: Colors.grey, // Red left border color
                  width: 1.0, // Left border width (optional)
                ),
                right: BorderSide(
                  color: Colors.grey, // Red right border color
                  width: 1.0, // Right border width (optional)
                ),
              ),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 0, 0),
                  child: Text(
                    'Muted',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Switch(
                      value: isSwitched2,
                      onChanged: (bool value) {
                        setState(() {
                          isSwitched2 = value;
                          // ignore: avoid_print
                          print(
                              'Switch is turned ${isSwitched2 ? 'on' : 'off'}');
                        });
                      },
                      activeColor:
                          Colors.red, // Customize the color when turned on
                      inactiveThumbColor: Colors
                          .redAccent, // Customize the color when turned off
                    ))
              ],
            )),
      ]),
    );
  }
}
