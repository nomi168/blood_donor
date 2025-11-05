// ignore_for_file: file_names

import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/data/models/history_model.dart';
import 'package:blood_donor/features/dashboard/account/presentation/controllers/history_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/account_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<HistoryController>(
          init: HistoryController(),
          builder: (controller) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(3.w, 0.h, 0, 0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 27,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            Navigator.pop(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const AccountScreen();
                                },
                                transitionDuration:
                                    const Duration(microseconds: 100),
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
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 0.h, 0, 0),
                          child: Text(
                            'History Log',
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ))
                    ],
                  ),
                  controller.historyList.isEmpty &&
                          controller.isLoading == false
                      ? Center(
                          child: Text('no data found'),
                        )
                      : controller.historyList.isEmpty &&
                              controller.isLoading == true
                          ? Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 40.h,
                                ),
                                CircularProgressIndicator(
                                  color: PRIMARY_COLOR,
                                  strokeWidth: 3,
                                ),
                              ],
                            )
                          : Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ListView.builder(
                                  itemCount: controller.historyList.length,
                                  itemBuilder: (context, index) {
                                    BloodHistoryModel his =
                                        controller.historyList[index];

                                    // Pick data depending on user type
                                    final isDonor =
                                        UserController.to.userModel!.type ==
                                            'donor';
                                    final name =
                                        isDonor ? his.takername : his.donorname;
                                    final email = isDonor
                                        ? his.takeremail
                                        : his.donoremail;
                                    final blood = isDonor
                                        ? his.takerblood
                                        : his.donorblood;
                                    final image = isDonor
                                        ? his.takerimage
                                        : his.donorimage;

                                    return TweenAnimationBuilder(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeOut,
                                      tween: Tween<double>(begin: 0, end: 1),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(0, (1 - value) * 20),
                                          child: Opacity(
                                              opacity: value, child: child),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Profile image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                width: 70,
                                                height: 70,
                                                imageUrl: image,
                                                placeholder: (context, url) =>
                                                    const CupertinoActivityIndicator(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Icon(Icons.person,
                                                        size: 40,
                                                        color: Colors.grey),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                      
                                            // Text info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    email,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.red.shade50,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(20),
                                                    ),
                                                    child: Text(
                                                      "Blood Type: $blood",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .red.shade700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
