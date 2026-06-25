// ignore_for_file: file_names, use_build_context_synchronously

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class OTPForgetScreen extends StatefulWidget {
  const OTPForgetScreen({super.key});

  @override
  State<OTPForgetScreen> createState() => _OTPForgetScreenState();
}

class _OTPForgetScreenState extends State<OTPForgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<ForgotPasswordController>(
          init: ForgotPasswordController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(children: [
                Visibility(
                  visible: !controller.isCheck,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                        child: Text(
                          'Verification Email',
                          style: TextStyle(
                              fontSize: 22.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
                      //   child: Center(
                      //     child: Text(
                      //       'We will send you a verification code',
                      //       style: TextStyle(
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.black54),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
                      //   child: Center(
                      //     child: Text(
                      //       'on your email',
                      //       style: TextStyle(
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.black54),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5.w, 15.h, 5.w, 0),
                        child: Material(
                          color: Colors.white,
                          elevation: 7.0, // Add shadow/elevation
                          borderRadius:
                              BorderRadius.circular(10.0), // Add border radius
                          child: TextFormField(
                            controller: controller.email,
                            decoration: InputDecoration(
                              label: const Text('Email'),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0), // Adjust padding
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                    color: Colors.grey), // Border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                    color: Colors
                                        .blue), // Border color when focused
                              ),
                              hintText: 'Enter Email',
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(60.w, 0.h, 5.w, 0),
                      //   child: Center(
                      //       child: TextButton(
                      //     // ignore: prefer_const_constructors
                      //     child: Text(
                      //       'Send OTP',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 13.sp,
                      //           color: isClicked ? Colors.red : Colors.blue,
                      //           decoration: TextDecoration.underline),
                      //     ),
                      //     onPressed: () async {
                      //       setState(() {
                      //         isClicked = true;
                      //       });
                      //       myauth.setConfig(
                      //           appEmail: "me@rohitchouhan.com",
                      //           appName: "Email OTP",
                      //           userEmail: email.text,
                      //           otpLength: 6,
                      //           otpType: OTPType.digitsOnly);
                      //       if (await myauth.sendOTP() == true) {
                      //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //           content: Text("OTP has been sent"),
                      //         ));
                      //       } else {
                      //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //           content: Text("Oops, OTP send failed"),
                      //         ));
                      //       }
                      //     },
                      //   )),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                      //   child: Material(
                      //     elevation: 7.0, // Add shadow/elevation
                      //     borderRadius: BorderRadius.circular(10.0), // Add border radius
                      //     child: TextFormField(
                      //       controller: otp,
                      //       keyboardType: TextInputType.number,
                      //       decoration: InputDecoration(
                      //         label: const Text('OTP'),
                      //         contentPadding: const EdgeInsets.symmetric(
                      //             horizontal: 16.0), // Adjust padding
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           borderSide:
                      //               const BorderSide(color: Colors.grey), // Border color
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           borderSide: const BorderSide(
                      //               color: Colors.blue), // Border color when focused
                      //         ),
                      //         hintText: 'Enter OTP',
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                      //   child: Center(
                      //     child: Text(
                      //       'Donot recieve code?',
                      //       style: TextStyle(
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.black54),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
                      //   child: Center(
                      //       child: TextButton(
                      //     // ignore: prefer_const_constructors
                      //     child: Text(
                      //       'Resend OTP',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 13.sp,
                      //           color: isClicked1 ? Colors.red : Colors.blue,
                      //           decoration: TextDecoration.underline),
                      //     ),
                      //     onPressed: () async {
                      //       setState(() {
                      //         isClicked1 = true;
                      //       });
                      //       myauth.setConfig(
                      //           appEmail: "me@rohitchouhan.com",
                      //           appName: "Email OTP",
                      //           userEmail: email.text,
                      //           otpLength: 6,
                      //           otpType: OTPType.digitsOnly);
                      //       if (await myauth.sendOTP() == true) {
                      //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //           content: Text("OTP has been sent"),
                      //         ));
                      //       } else {
                      //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //           content: Text("Oops, OTP send failed"),
                      //         ));
                      //       }
                      //     },
                      //   )),
                      // ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (controller.email.text.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Email is required",
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
                            bool result = await controller
                                .checkEmail(controller.email.text.trim());
                            if (!result) {
                              controller.isCheck = true;
                              controller.update();
                            } else {
                              Get.snackbar(
                                "Error",
                                "Email not found",
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
                            }
                            // if (await myauth.verifyOTP(otp: otp.text) == true) {
                            //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            //     content: Text("OTP is verified"),
                            //   ));
                            //   String em = email.text;
                            //   Navigator.push(
                            //     context,
                            //     PageRouteBuilder(
                            //       pageBuilder: (context, animation, secondaryAnimation) {
                            //         return ForgetScreen(email: em);
                            //       },
                            //       transitionDuration: const Duration(seconds: 1),
                            //       transitionsBuilder:
                            //           (context, animation, secondaryAnimation, child) {
                            //         const begin =
                            //             Offset(10.0, 0.0); // slide in from the right
                            //         const end = Offset.zero;
                            //         const curve = Curves.easeInOutQuart;

                            //         var tween = Tween(begin: begin, end: end)
                            //             .chain(CurveTween(curve: curve));
                            //         var offsetAnimation = animation.drive(tween);

                            //         return SlideTransition(
                            //           position: offsetAnimation,
                            //           child: child,
                            //         );
                            //       },
                            //     ),
                            //   );
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            //     content: Text("Invalid OTP"),
                            //   ));
                            // }
                          },
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              // ignore: prefer_const_constructors
                              EdgeInsets.symmetric(
                                  vertical: 13.5, horizontal: 35.w),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xFFDE0A1E)), // Change button color
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16.sp, // Adjust the font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: controller.isCheck,
                  child: Column(children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: SvgPicture.asset(
                        height: 200,
                        width: 200,
                        'images/svg/Layer_1.svg',
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.w, 5.h, 0, 0),
                        child: Center(
                          child: Text(
                            'Forget Password',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 2.h, 5, 0),
                      child: Material(
                        color: Colors.white,
                        elevation: 7.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: TextFormField(
                          controller: controller.pass,
                          obscureText: controller
                              .obscureText, // Set to true to obscure text
                          decoration: InputDecoration(
                            label: const Text('New Password'),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintText: 'New Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                controller.obscureText =
                                    !controller.obscureText;
                                controller.update();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 2.h, 5, 0),
                      child: Material(
                        color: Colors.white,
                        elevation: 7.0, // Add shadow/elevation
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                        child: TextFormField(
                          obscureText: controller.obscureText1,
                          controller: controller.cpass,
                          decoration: InputDecoration(
                            label: const Text('Confirm Password'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0), // Adjust padding
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey), // Border color
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureText1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                controller.obscureText1 =
                                    !controller.obscureText1;
                                controller.update();
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Colors.blue),
                              // Border color when focused
                            ),
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: () async {
                        if (controller.pass.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "New password is required",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        if (controller.cpass.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Confirm password is required",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        if (controller.pass.text.trim() !=
                            controller.cpass.text.trim()) {
                          Get.snackbar(
                            "Error",
                            "Entered must be same password!",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor: Colors.red.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.error, color: Colors.white),
                          );

                          return;
                        }
                        Map<String,dynamic> payload = {
                          'email': controller.email.text.trim(),
                          'password': controller.pass.text.trim()
                        };
                        UserModel? result =
                            await controller.forgotPassword(payload);
                        if (result != null) {
                          Get.snackbar(
                            "Success",
                            "Changed password successfully",
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                            backgroundColor:
                                Colors.green.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            duration: Duration(seconds: 3),
                            borderRadius: 8,
                            icon: Icon(Icons.check_circle, color: Colors.white),
                          );
                          Get.offAll(() => Dashboard());
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(06)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16.sp, // Adjust the font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ]),
            );
          },
        ));
  }
}
