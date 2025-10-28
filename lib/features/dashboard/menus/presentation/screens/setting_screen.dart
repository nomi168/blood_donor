// ignore_for_file: file_names

import 'package:blood_donor/common/widgets/profile_icons.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/manage_address_screen.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/controllers/setting_controller.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/help_center_screen.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/menu_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SettingController>(
        init: SettingController(),
        builder: (controller) {
          return Column(children: [
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
                              return const MenuSettingScreen();
                            },
                            transitionDuration:
                                const Duration(microseconds: 100),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                        fontSize: 18.sp,
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
                      value: controller.isSwitched,
                      onChanged: (bool value) {
                        controller.isSwitched = value;
                        controller.update();
                      },
                      activeColor:
                          Colors.red, // Customize the color when turned on
                      inactiveThumbColor: Colors
                          .redAccent, // Customize the color when turned off
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
                          value: controller.isSwitched1,
                          onChanged: (bool value) {
                            controller.isSwitched1 = value;
                            controller.update();
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
                          value: controller.isSwitched2,
                          onChanged: (bool value) {
                            controller.isSwitched2 = value;
                            controller.update();
                          },
                          activeColor:
                              Colors.red, // Customize the color when turned on
                          inactiveThumbColor: Colors
                              .redAccent, // Customize the color when turned off
                        ))
                  ],
                )),
            // ProfileMenuTile(
            //   icon: Icons.insert_invitation,
            //   title: "Invite",
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         PageRouteBuilder(
            //           pageBuilder: (_, __, ___) => const InviteScreen(),
            //           transitionsBuilder: (_, animation, __, child) {
            //             return SlideTransition(
            //               position:
            //                   Tween(begin: const Offset(1, 0), end: Offset.zero)
            //                       .animate(CurvedAnimation(
            //                           parent: animation,
            //                           curve: Curves.easeInOutQuart)),
            //               child: child,
            //             );
            //           },
            //         ));
            //   },
            // ),
            ProfileMenuTile(
              icon: Icons.help_center,
              title: "Help Center",
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HelpCenterScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position:
                              Tween(begin: const Offset(1, 0), end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutQuart)),
                          child: child,
                        );
                      },
                    ));
              },
            ),
            ProfileMenuTile(
              icon: Icons.location_on,
              title: "Manage Address",
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ManageAddressScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position:
                              Tween(begin: const Offset(1, 0), end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutQuart)),
                          child: child,
                        );
                      },
                    ));
              },
            ),

            // Referral Invitation
          ]);
        },
      ),
    );
  }
}
