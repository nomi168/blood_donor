// ignore_for_file: file_names
import 'package:blood_donor/features/auth/presentation/screens/signup_screen.dart';
import 'package:blood_donor/features/splashscreens/presentation/controllers/splash_animator_controller.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StartWithSplashScreen extends StatefulWidget {
  const StartWithSplashScreen({Key? key}) : super(key: key);

  @override
  State<StartWithSplashScreen> createState() => _StartWithSplashScreenState();
}

class _StartWithSplashScreenState extends State<StartWithSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<SplashAnimatorController>(
          init: SplashAnimatorController(),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  flex: 7,
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.splashData.length,
                    onPageChanged: (value) {
                      controller.currentPage = value;
                      controller.update();
                    },
                    itemBuilder: (context, index) => _buildPageContent(
                      image: controller.splashData[index]["image"]!,
                      title: controller.splashData[index]["title"]!,
                      subtitle1: controller.splashData[index]["subtitle1"]!,
                      subtitle2: controller.splashData[index]["subtitle2"]!,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // ✅ Dots indicator
                DotsIndicator(
                  dotsCount: controller.splashData.length,
                  position: controller.currentPage.toInt(),
                  decorator: const DotsDecorator(
                    color: Colors.grey,
                    activeColor: Color(0xFFDE0A1E),
                    size: Size(10.0, 10.0),
                    activeSize: Size(14.0, 14.0),
                  ),
                ),

                SizedBox(height: 40.h),

                // ✅ Main action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Preview button — hide on first page
                    if (controller.currentPage > 0)
                      TextButton(
                        onPressed: controller.onPreviewPressed,
                        child: Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 90), // keep layout aligned

                    // Skip button
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  
                      TextButton(
                        onPressed: controller.onNextPressed,
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                   
                  ],
                ),

                SizedBox(height: 30.h),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageContent({
    required String image,
    required String title,
    required String subtitle1,
    required String subtitle2,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 280.h),
        SizedBox(height: 20.h),
        Text(
          title,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.h),
        Text(
          subtitle1,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5.h),
        Text(
          subtitle2,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
