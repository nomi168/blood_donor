import 'package:blood_donor/features/dashboard/home/presentation/controllers/emergency_donor_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class EmergencyDonorScreen extends StatelessWidget {
  const EmergencyDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GetBuilder<EmergencyDonorController>(
          init: EmergencyDonorController(),
          builder: (controller) {
            return Column(children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Row(
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
                              return const HomeScreen();
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
                    ),
                    Spacer(),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      'Emergency Help',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (!controller.isLanguage) {
                          controller.isLanguage = true;
                          controller.update();
                        } else {
                          controller.isLanguage = false;
                          controller.update();
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(06),
                            color: controller.isLanguage
                                ? Colors.red
                                : Colors.grey.shade300),
                        child: Text(
                          !controller.isLanguage
                              ? 'Switch to English'
                              : 'Switch to Urdu',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: controller.isLanguage
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Image.asset(
                'images/image1.jpeg',
                height: 220,
                width: double.infinity,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Card(
                  color: Colors.grey.shade100,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                            size: 25.sp,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Emergency Assistance',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      controller.isLanguage
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                textAlign: TextAlign.justify,
                                'If during a physical meeting between donor and recipient, either party experiences any form of unethical behavior, harassment, or feels unsafe, please call emergency services immediately by dialing "15. ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ))
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                'اگر خون دینے والے اور لینے والے کے درمیان ملاقات کے دوران کسی بھی فریق کو غیر اخلاقی رویے، ہراسانی یا خطرے کا سامنا ہو، '
                                'تو فوراً ہنگامی سروسز کو "15" پر کال کریں۔',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ),
                      SizedBox(height: 14),
                      InkWell(
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          controller.callEmergencyNumber();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey.shade300,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Text(
                            'Call 15 - Emergency',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              )
            ]);
          },
        ),
      ),
    );
  }
}
