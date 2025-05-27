// ignore_for_file: file_names

import 'package:blood_donor/constants.dart';
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
                // crossAxisAlignment: CrossAxisAlignment.center,
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
                          ? CircularProgressIndicator(
                              color: PRIMARY_COLOR,
                              strokeWidth: 3,
                            )
                          : Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: ListView.builder(
                                  itemCount: controller.historyList.length,
                                  itemBuilder: (context, index) {
                                    BloodHistoryModel his =
                                        controller.historyList[index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(06)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 70,
                                            height: 70,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: UserController.to
                                                            .userModel!.type ==
                                                        'donor'
                                                    ? his.takerimage
                                                    : his.donorimage,
                                                placeholder: (context, url) =>
                                                    const CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  UserController.to.userModel!
                                                              .type ==
                                                          'donor'
                                                      ? his.takername
                                                      : his.donorname,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  UserController.to.userModel!
                                                              .type ==
                                                          'donor'
                                                      ? his.takeremail
                                                      : his.donoremail,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  UserController.to.userModel!
                                                              .type ==
                                                          'donor'
                                                      ? 'blood-type: ${his.takerblood}'
                                                      : 'blood-type: ${his.donorblood}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
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
