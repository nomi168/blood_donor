import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/emergency_taker_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class EmergencyTakerScreen extends StatelessWidget {
  const EmergencyTakerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GetBuilder<EmergencyTakerController>(
          init: EmergencyTakerController(),
          builder: (controller) {
            return Column(children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
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
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Image.asset(
                'images/image1.jpeg',
                height: 220,
                width: double.infinity,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.isLoading && controller.takerModel == null
                      ? Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: PRIMARY_COLOR,
                            )
                          ],
                        )
                      : !controller.isLoading && controller.takerModel == null
                          ? SizedBox()
                          : controller.takerModel!.isEmergencyHelp == false
                              ? SizedBox()
                              : !controller.isLoading &&
                                      controller.takerModel == null
                                  ? SizedBox()
                                  : Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Card(
                                        color: Colors.grey.shade100,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.warning_amber_rounded,
                                                    color: Colors.redAccent,
                                                    size: 25.sp,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Emergency Help Available',
                                                      style: TextStyle(
                                                        fontSize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                ],
                                              ),
                                            ),
                                            controller.isLanguage
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.justify,
                                                        'If you need emergency help, please call "15". During the call, listen to the menu and press 4. '
                                                        'You will be connected to the virtual blood bank, which arranges emergency blood from your nearby location.',
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Text(
                                                        'اگر آپ کو ایمرجنسی مدد کی ضرورت ہو، تو براہ کرم "15" پر کال کریں۔ کال کے دوران مینو کو غور سے سنیں اور 4 دبائیں۔ '
                                                        'آپ کو ورچوئل بلڈ بینک سے منسلک کر دیا جائے گا، جو آپ کے قریبی مقام سے ایمرجنسی خون کا انتظام کرتا ہے۔',
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                controller.remainingTime !=
                                                            null &&
                                                        !controller.showButton
                                                    ? Text(
                                                        'Please wait for '
                                                        '${(controller.remainingTime!.inHours).toString().padLeft(2, '0')}'
                                                        ':'
                                                        '${(controller.remainingTime!.inMinutes %60).toString().padLeft(2, '0')}'
                                                        ':'
                                                        '${(controller.remainingTime!.inSeconds % 60).toString().padLeft(2, '0')}',
                                                      )
                                                    : SizedBox(),
                                                // controller.remainingTime!.inMinutes ==
                                                //             0 &&
                                                //         controller.remainingTime!
                                                //                 .inSeconds ==
                                                //             0
                                                //     ? InkWell(
                                                //         splashColor: Colors.transparent,
                                                //         splashFactory:
                                                //             NoSplash.splashFactory,
                                                //         onTap: () {
                                                //           controller
                                                //               .callEmergencyNumber();
                                                //         },
                                                //         child: Container(
                                                //           decoration: BoxDecoration(
                                                //               borderRadius:
                                                //                   BorderRadius.circular(
                                                //                       06),
                                                //               color:
                                                //                   Colors.grey.shade300),
                                                //           padding: EdgeInsets.symmetric(
                                                //               horizontal: 10,
                                                //               vertical: 5),
                                                //           child: Text(
                                                //             'Call to 15',
                                                //             style: TextStyle(
                                                //               fontSize: 17.sp,
                                                //               fontWeight:
                                                //                   FontWeight.w700,
                                                //               color: Colors.redAccent,
                                                //             ),
                                                //           ),
                                                //         ),
                                                //       )
                                                //     : SizedBox(),
                                                controller.showButton
                                                    ? InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        splashFactory: NoSplash
                                                            .splashFactory,
                                                        onTap: () {
                                                          controller
                                                              .callEmergencyNumber();
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          06),
                                                              color: Colors.grey
                                                                  .shade300),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: Text(
                                                            'Call to 15',
                                                            style: TextStyle(
                                                              fontSize: 17.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Colors
                                                                  .redAccent,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),

                                                controller.takerModel!
                                                            .isEmergencyHelp ==
                                                        false
                                                    ? SizedBox()
                                                    : controller.takerModel!
                                                                .situation ==
                                                            'critical'
                                                        ? InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            splashFactory: NoSplash
                                                                .splashFactory,
                                                            onTap: () {
                                                              controller
                                                                  .callEmergencyNumber();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              06),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                              child: Text(
                                                                'Call to 15',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                  controller.isShow
                      ? SizedBox()
                      : Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                                          'If you are meeting a donor in person and experience any form of unethical behavior, harassment, or feel unsafe, '
                                          'please call emergency services immediately by dialing "15". ',
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
                                          'اگر آپ کسی ڈونر سے بالمشافہ ملاقات کر رہے ہیں اور کسی بھی قسم کے غیر اخلاقی رویے، ہراسانی یا خطرے کا سامنا کرتے ہیں، تو فوراً ہنگامی سروسز کو "15" پر کال کریں۔',
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
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
                ],
              ),
            ]);
          },
        ),
      ),
    );
  }
}
