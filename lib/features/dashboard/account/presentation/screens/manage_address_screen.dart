// ignore_for_file: file_names

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/controllers/manage_address_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ManageAddressScreen extends StatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<ManageAddressController>(
          init: ManageAddressController(),
          builder: (controller) {
            return Column(children: [
              Row(
                children: [
                  IconButton(
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
                          transitionDuration: const Duration(microseconds: 100),
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
                  ),
                  Spacer(),
                  Text(
                    'Manage Address',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  textAlign: TextAlign.center,
                  'Add multiple location where you can travel to donate blood',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 0.0, // Ensure minWidth is not negative
                  ),
                  child: TextFormField(
                    controller: controller.home,
                    decoration: InputDecoration(
                      label: const Text('Location'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: SizedBox(
                        height: 1.h,
                        width: 25.w,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 1.h),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (controller.home.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "please enter address",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: 0.9),
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  duration: Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: Icon(Icons.error, color: Colors.white),
                                );

                                return;
                              }
                              dynamic payload = {
                                'email': UserController.to.userModel!.email,
                                'address': controller.home.text.trim(),
                                'type': 'home',
                              };
                              bool result =
                                  await controller.addHomeAddress(payload);
                              if (result) {
                                Get.snackbar(
                                  "Success",
                                  "Home address added successfully",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.green.withValues(alpha: 0.9),
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  duration: Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.white),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ), // Set borderRadius to 0 for flat corners
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Location',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth:
                        2.0, // Set minWidth to 0 to avoid negative constraints
                  ),
                  child: TextFormField(
                    controller: controller.work,
                    decoration: InputDecoration(
                      label: const Text('Location'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: SizedBox(
                        height: 1.h,
                        width: 25.w,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 1.h),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (controller.work.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "please enter address",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.red.withValues(alpha: 0.9),
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  duration: Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: Icon(Icons.error, color: Colors.white),
                                );

                                return;
                              }
                              dynamic payload = {
                                'email': UserController.to.userModel!.email,
                                'address': controller.work.text.trim(),
                                'type': 'work',
                              };
                              bool result =
                                  await controller.addWorkAddress(payload);
                              if (result) {
                                Get.snackbar(
                                  "Success",
                                  "Work address added successfully",
                                  snackPosition: SnackPosition.TOP,
                                  snackStyle: SnackStyle.FLOATING,
                                  backgroundColor:
                                      Colors.green.withValues(alpha: 0.9),
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  duration: Duration(seconds: 3),
                                  borderRadius: 8,
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.white),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ), // Set borderRadius to 0 for flat corners
                              ),
                            ),
                            child: Center(
                              child: Text('Work',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Location',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Add more',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 6.h,
                      width: 15.w,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.isFormVisible = !controller.isFormVisible;
                          controller.update();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          backgroundColor: PRIMARY_COLOR,
                          padding: const EdgeInsets.all(12.0),
                        ),
                        child: const Icon(Icons.add,
                            size: 24, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: !controller.isFormVisible,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                  child: Material(
                    elevation: 7.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 2.0,
                      ),
                      child: TextFormField(
                        controller: controller.travel,
                        decoration: InputDecoration(
                          
                          label: const Text('Location'),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: SizedBox(
                            height: 1.h,
                            width: 25.w,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 1.h),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (controller.travel.text.isEmpty) {
                                    Get.snackbar(
                                      "Error",
                                      "please enter address",
                                      snackPosition: SnackPosition.TOP,
                                      snackStyle: SnackStyle.FLOATING,
                                      backgroundColor:
                                          Colors.red.withValues(alpha: 0.9),
                                      colorText: Colors.white,
                                      margin: EdgeInsets.all(10),
                                      duration: Duration(seconds: 3),
                                      borderRadius: 8,
                                      icon: Icon(Icons.error,
                                          color: Colors.white),
                                    );

                                    return;
                                  }
                                  dynamic payload = {
                                    'email': UserController.to.userModel!.email,
                                    'address': controller.travel.text.trim(),
                                    'type': 'travel',
                                  };
                                  bool result = await controller
                                      .addTravelAddress(payload);
                                  if (result) {
                                    Get.snackbar(
                                      "Success",
                                      "Travel address added successfully",
                                      snackPosition: SnackPosition.TOP,
                                      snackStyle: SnackStyle.FLOATING,
                                      backgroundColor:
                                          Colors.green.withValues(alpha: 0.9),
                                      colorText: Colors.white,
                                      margin: EdgeInsets.all(10),
                                      duration: Duration(seconds: 3),
                                      borderRadius: 8,
                                      icon: Icon(Icons.check_circle,
                                          color: Colors.white),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PRIMARY_COLOR,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Travel',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          hintText: 'Location',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
