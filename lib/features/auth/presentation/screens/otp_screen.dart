import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/otp_controller.dart';
import 'package:blood_donor/features/auth/presentation/screens/questions_screen.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtpScreen extends StatelessWidget {
  final Map<String, dynamic> payload;
  const OtpScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<OtpController>(
        init: OtpController(userEmail: payload['email']),
        builder: (otpController) {
          otpController.email.text = payload['email'];
          return SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.w, 200.h, 0.w, 0),
                child: Center(
                  child: Text(
                    'Verification Code',
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(begin: Offset(1, 0), end: Offset.zero),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'We will send you a verification code\non your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(begin: Offset(1, 0), end: Offset.zero),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0),
                child: Material(
                  color: Colors.white,
                  elevation: 7.0, // Add shadow/elevation
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    controller: otpController.email,
                    readOnly: false,
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
                            color: Colors.blue), // Border color when focused
                      ),
                      hintText: 'Enter Email',
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(begin: Offset(1, 0), end: Offset.zero),
              Container(
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                child: TextButton(
                  // ignore: prefer_const_constructors
                  child: Text(
                    'Send OTP',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color:
                            otpController.isClicked ? Colors.red : Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  onPressed: () async {
                    try {
                      showLoader('sending otp...');
                      otpController.sendOTP(true);
                      EmailOTP.config(
                          appEmail: "me@rohitchouhan.com",
                          appName: "Email OTP",
                          otpLength: 4,
                          otpType: OTPType.numeric);
                      if (await EmailOTP.sendOTP(
                              email: otpController.email.text.trim()) ==
                          true) {
                        Get.snackbar(
                          "Success",
                          "OTP has been sent",
                          snackPosition: SnackPosition.TOP,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundColor: Colors.green.withValues(alpha: 0.9),
                          colorText: Colors.white,
                          margin: EdgeInsets.all(10),
                          duration: Duration(seconds: 3),
                          borderRadius: 8,
                          icon: Icon(Icons.check_circle, color: Colors.white),
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Oops, OTP send failed",
                          snackPosition: SnackPosition.TOP,
                          snackStyle: SnackStyle.FLOATING,
                          backgroundColor: Colors.red.withValues(alpha: 0.9),
                          colorText: Colors.white,
                          margin: EdgeInsets.all(10),
                          duration: Duration(seconds: 3),
                          borderRadius: 8,
                          icon: Icon(Icons.error, color: Colors.white),
                        );
                      }
                    } catch (e) {
                    } finally {
                      await EasyLoading.dismiss();
                    }
                  },
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(begin: Offset(1, 0), end: Offset.zero),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                child: Material(
                  color: Colors.white,
                  elevation: 7.0, // Add shadow/elevation
                  borderRadius:
                      BorderRadius.circular(10.0), // Add border radius
                  child: TextFormField(
                    controller: otpController.otp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Text('OTP'),
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
                            color: Colors.blue), // Border color when focused
                      ),
                      hintText: 'Enter OTP',
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(begin: Offset(1, 0), end: Offset.zero),
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0),
                child: Center(
                  child: Text(
                    "Don\'t receive code?",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(begin: Offset(1, 0), end: Offset.zero),
              TextButton(
                // ignore: prefer_const_constructors
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: otpController.isClickedResend
                          ? Colors.red
                          : Colors.blue,
                      decoration: TextDecoration.underline),
                ),
                onPressed: () async {
                  try {
                    showLoader('resending otp...');
                    otpController.resendOTP(true);
                    EmailOTP.config(
                        appEmail: "me@rohitchouhan.com",
                        appName: "Email OTP",
                        otpLength: 4,
                        otpType: OTPType.numeric);
                    if (await EmailOTP.sendOTP(
                            email: otpController.email.text.trim()) ==
                        true) {
                      Get.snackbar(
                        "Success",
                        "OTP has been sent",
                        snackPosition: SnackPosition.TOP,
                        snackStyle: SnackStyle.FLOATING,
                        backgroundColor: Colors.green.withValues(alpha: 0.9),
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                        duration: Duration(seconds: 3),
                        borderRadius: 8,
                        icon: Icon(Icons.check_circle, color: Colors.white),
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Oops, OTP send failed",
                        snackPosition: SnackPosition.TOP,
                        snackStyle: SnackStyle.FLOATING,
                        backgroundColor: Colors.red.withValues(alpha: 0.9),
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                        duration: Duration(seconds: 3),
                        borderRadius: 8,
                        icon: Icon(Icons.error, color: Colors.white),
                      );
                    }
                  } catch (e) {
                  } finally {
                    await EasyLoading.dismiss();
                  }
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(begin: Offset(1, 0), end: Offset.zero),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: ElevatedButton(
                  onPressed: () async {
                    if (otpController.otp.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "enter otp",
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
                    if (await EmailOTP.verifyOTP(
                            otp: otpController.otp.text.trim()) ==
                        true) {
                      Get.snackbar(
                        "Success",
                        "OTP is verified",
                        snackPosition: SnackPosition.TOP,
                        snackStyle: SnackStyle.FLOATING,
                        backgroundColor: Colors.green.withValues(alpha: 0.9),
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                        duration: Duration(seconds: 3),
                        borderRadius: 8,
                        icon: Icon(Icons.check_circle, color: Colors.white),
                      );

                      // setState(() {
                      //   otpresult = true;
                      // });

                      // String email = widget.email;
                      // int id = widget.Id;
                      // String image = widget.image;
                      // String fname = widget.fname;
                      // String lname = widget.lname;

                      // String number = widget.number;
                      // String location = widget.location;
                      // String blood = widget.blood;
                      // String gender = widget.gender;
                      // String password = widget.password;
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return QuestionsScreen(
                              payload: payload,
                            );
                          },
                          transitionDuration: const Duration(microseconds: 100),
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
                    } else {
                      Get.snackbar(
                        "Error",
                        "OTP is not verify",
                        snackPosition: SnackPosition.TOP,
                        snackStyle: SnackStyle.FLOATING,
                        backgroundColor: Colors.red.withValues(alpha: 0.9),
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                        duration: Duration(seconds: 3),
                        borderRadius: 8,
                        icon: Icon(Icons.error, color: Colors.white),
                      );
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      // ignore: prefer_const_constructors
                      EdgeInsets.symmetric(vertical: 13.5, horizontal: 35.w),
                    ),
                    backgroundColor: WidgetStatePropertyAll<Color>(
                        const Color(0xFFDE0A1E)), // Change button color
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 14.sp, // Adjust the font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ));
        },
      ),
    );
  }
}
