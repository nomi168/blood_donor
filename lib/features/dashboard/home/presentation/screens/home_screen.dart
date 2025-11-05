// ignore_for_file: file_names

import 'package:badges/badges.dart' as badge;
import 'package:blood_donor/core/utils/services/notification_storage.dart';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/auth/presentation/screens/card_scanning_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_banks_update/taker_blood_bank_screen.dart';
import 'package:blood_donor/features/dashboard/notifications/presentation/constroller/notification_controller.dart';
import 'package:blood_donor/features/dashboard/notifications/presentation/screens/notification_screen.dart';
import 'package:blood_donor/features/dashboard/feeds/presentation/screens/feed_tab_screen.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/home_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_banks_update/blood_bank_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_journey/blood_journey_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/donate_blood/donate_bood_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/emergency_help/emergency_taker_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/see_more/taker_reach.dart';
import 'package:blood_donor/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../post_blood/presentation/screens/post_request_screen.dart';
import 'emergency_help/emergency_donor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // late HomeController _controller;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      logSuccess("My State is $state");
      UserController.to.updateAppStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      logSuccess("My State is $state");
      await NotificationsProvider.to.loadNotifications();
      UserController.to.updateAppStatus(true);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // if (user == null) return const SizedBox();
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: GetBuilder<UserController>(
        builder: (userController) {
          return GetBuilder<HomeController>(
            init: HomeController(),
            builder: (homeController) {
              return WillPopScope(
                onWillPop: () => homeController.onWillPop(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Hello!  ${userController.userModel == null ? "" : userController.userModel!.firstname} ${userController.userModel == null ? "" : userController.userModel!.lastname}',
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              showBarModalBottomSheet(
                                animationCurve: Curves.easeInBack,
                                barrierColor:
                                    Colors.black.withValues(alpha: 0.5),
                                context: context,
                                builder: (context) {
                                  return const NotificationScreen();
                                },
                              );
                            },
                            child: GetBuilder<NotificationsProvider>(builder: (
                              cont,
                            ) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: badge.Badge(
                                    showBadge: cont.notifications
                                        .where(
                                            (element) => element.read == false)
                                        .toList()
                                        .isNotEmpty,
                                    badgeStyle: const badge.BadgeStyle(
                                      shape: badge.BadgeShape.circle,
                                      badgeColor: PRIMARY_COLOR,
                                      padding: EdgeInsets.all(5 < 10 ? 5 : 2),
                                      elevation: 0,
                                    ),
                                    badgeContent: Text(
                                      NotificationStorage.notificationsData
                                          .where((element) =>
                                              element.read == false)
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Colors.white),
                                    ),
                                    child: FaIcon(FontAwesomeIcons.bell,
                                        size: 22, color: Colors.black),
                                  ));
                            }),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          'Are you looking for blood?',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
                      //   child: Material(
                      //     elevation: 7.0, // Add shadow/elevation
                      //     borderRadius:
                      //         BorderRadius.circular(10.0), // Add border radius
                      //     child: TextFormField(
                      //       controller: hospital,
                      //       decoration: InputDecoration(
                      //         label: const Text('Search Hospital'),
                      //         contentPadding: const EdgeInsets.symmetric(
                      //             horizontal: 16.0), // Adjust padding
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           borderSide: const BorderSide(
                      //               color: Colors.grey), // Border color
                      //         ),
                      //         suffixIcon: const Icon(Icons.local_hospital),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           borderSide: const BorderSide(
                      //               color: Colors.blue), // Border color when focused
                      //         ),
                      //         hintText: 'Search Hospital',
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 13.0),
                              labelText: "Select Blood",
                              suffixIcon: Icon(Icons.bloodtype),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            items: homeController.bloodGroups
                                .map((e) => DropdownMenuItem(
                                      // ignore: sort_child_properties_last
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (v) {
                              homeController.selectedBloodGroup = v!;
                              homeController.update();
                            },
                          )),
                      SizedBox(
                        height: 10,
                      ),

                      InkWell(
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        onTap: () async {
                          bool result =
                              await homeController.checkUserCnicVerification();
                          if (result) {
                            Map<String, dynamic> payload = {
                              'email': userController.userModel!.email
                            };
                            bool result = await homeController
                                .checkTakerBloodRequest(payload);
                            if (result) {
                              String blood = homeController.selectedBloodGroup;
                              if (userController.userModel!.type == 'taker') {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return PostRequestScreen(blood: blood);
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(
                                          10.0, 0.0); // slide in from the right
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOutQuart;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

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
                                  "Please login using a taker account",
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
                            } else {
                              Get.snackbar(
                                "Error",
                                "Blood request is already posted",
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
                          } else {
                            showDialog(
                              context: navigatorKey.currentContext!,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Row(
                                    children: [
                                      Icon(Icons.verified_user,
                                          color: Colors.redAccent),
                                      SizedBox(width: 8),
                                      Text(
                                        "CNIC Verification Required",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Please verify your CNIC before proceeding.",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "• If you are a Taker: You cannot request blood without CNIC verification.\n\n"
                                        "• If you are a Donor: You cannot donate blood without verifying your CNIC.\n\n"
                                        "👉 Go to your account section and verify your CNIC to continue.",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text("Later",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showModalBottomSheet(
                                          context: context,
                                          isDismissible: false,
                                          enableDrag: false,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext context) {
                                            return Container(
                                              margin: EdgeInsets.only(top: 40),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                                child:
                                                    CardScanningScreen(), // 👈 your screen
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        "Verify Now",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Send Request',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      CarouselSlider(
                        items: homeController.bannerList.map((url) {
                          return Image.network(url.path, fit: BoxFit.contain);
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            homeController.currentIndex = index;
                            homeController.update();
                          },
                        ),
                        // carouselController: _carouselController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: homeController.bannerList.map((url) {
                          int index = homeController.bannerList.indexOf(url);
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: homeController.currentIndex == index
                                    ? const Color(0xFFDE0A1E)
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            userController.userModel == null
                                ? SizedBox()
                                : userController.userModel!.type == 'donor'
                                    ? GestureDetector(
                                        onTap: () {
                                          // ignore: avoid_print
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return FeedScreen(
                                                  id: '12345',
                                                );
                                              },
                                              transitionDuration:
                                                  const Duration(
                                                      microseconds: 100),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(10.0,
                                                    0.0); // slide in from the right
                                                const end = Offset.zero;
                                                const curve =
                                                    Curves.easeInOutQuart;

                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));
                                                var offsetAnimation =
                                                    animation.drive(tween);

                                                return SlideTransition(
                                                  position: offsetAnimation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 120,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.w, 3.h, 5.w, 0),
                                                child: Center(
                                                  child: Image.network(
                                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQigoM43RUySVjX6VVeTVg2xcXGuk7SOoTw_A&usqp=CAU',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      3.w, 0.h, 2.w, 0),
                                                  child: Text(
                                                    'Donate',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      3.w, 0.h, 2.w, 0),
                                                  child: Text(
                                                    'Blood',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54),
                                                  )),
                                            ],
                                          ),
                                        ))
                                    : GestureDetector(
                                        onTap: () async {
                                          bool result = await homeController
                                              .checkUserCnicVerification();
                                          if (result) {
                                            Map<String, dynamic> payload = {
                                              'email': userController
                                                  .userModel!.email
                                            };
                                            bool result = await homeController
                                                .checkTakerBloodRequest(
                                                    payload);
                                            if (result) {
                                              String blood = homeController
                                                  .selectedBloodGroup;
                                              if (userController
                                                      .userModel!.type ==
                                                  'taker') {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return PostRequestScreen(
                                                          blood: blood);
                                                    },
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      const begin = Offset(10.0,
                                                          0.0); // slide in from the right
                                                      const end = Offset.zero;
                                                      const curve =
                                                          Curves.easeInOutQuart;

                                                      var tween = Tween(
                                                              begin: begin,
                                                              end: end)
                                                          .chain(CurveTween(
                                                              curve: curve));
                                                      var offsetAnimation =
                                                          animation
                                                              .drive(tween);

                                                      return SlideTransition(
                                                        position:
                                                            offsetAnimation,
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                Get.snackbar(
                                                  "Error",
                                                  "Please login using a taker account",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  snackStyle:
                                                      SnackStyle.FLOATING,
                                                  backgroundColor: Colors.red
                                                      .withValues(alpha: 0.9),
                                                  colorText: Colors.white,
                                                  margin: EdgeInsets.all(10),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  borderRadius: 8,
                                                  icon: Icon(Icons.error,
                                                      color: Colors.white),
                                                );
                                              }
                                            } else {
                                              Get.snackbar(
                                                "Error",
                                                "Blood request is already posted",
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                snackStyle: SnackStyle.FLOATING,
                                                backgroundColor: Colors.red
                                                    .withValues(alpha: 0.9),
                                                colorText: Colors.white,
                                                margin: EdgeInsets.all(10),
                                                duration: Duration(seconds: 3),
                                                borderRadius: 8,
                                                icon: Icon(Icons.error,
                                                    color: Colors.white),
                                              );
                                            }
                                          } else {
                                            showDialog(
                                              context:
                                                  navigatorKey.currentContext!,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      Icon(Icons.verified_user,
                                                          color:
                                                              Colors.redAccent),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "CNIC Verification Required",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Please verify your CNIC before proceeding.",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(height: 12),
                                                      Text(
                                                        "• If you are a Taker: You cannot request blood without CNIC verification.\n\n"
                                                        "• If you are a Donor: You cannot donate blood without verifying your CNIC.\n\n"
                                                        "👉 Go to your account section and verify your CNIC to continue.",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text("Later",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showModalBottomSheet(
                                                          context: context,
                                                          isDismissible: false,
                                                          enableDrag: false,
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 40),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                            top:
                                                                                Radius.circular(20)),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                            top:
                                                                                Radius.circular(20)),
                                                                child:
                                                                    CardScanningScreen(),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        "Verify Now",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 120,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.w, 3.h, 5.w, 0),
                                                child: Center(
                                                  child: Image.network(
                                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQigoM43RUySVjX6VVeTVg2xcXGuk7SOoTw_A&usqp=CAU',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      3.w, 0.h, 2.w, 0),
                                                  child: Text(
                                                    'Post Blood',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54),
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      3.w, 0.h, 2.w, 0),
                                                  child: Text(
                                                    'Request',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54),
                                                  )),
                                            ],
                                          ),
                                        )),
                            GestureDetector(
                                onTap: () async {
                                  if (UserController.to.userModel!.type ==
                                      'taker') {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return const TakerBloodBankScreen();
                                        },
                                        transitionDuration:
                                            const Duration(microseconds: 100),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(10.0,
                                              0.0); // slide in from the right
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOutQuart;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var offsetAnimation =
                                              animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    bool result = await homeController
                                        .checkUserCnicVerification();
                                    if (result) {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return const BloodBankScreen();
                                          },
                                          transitionDuration:
                                              const Duration(microseconds: 100),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(10.0,
                                                0.0); // slide in from the right
                                            const end = Offset.zero;
                                            const curve = Curves.easeInOutQuart;

                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));
                                            var offsetAnimation =
                                                animation.drive(tween);

                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: navigatorKey.currentContext!,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: Row(
                                              children: [
                                                Icon(Icons.verified_user,
                                                    color: Colors.redAccent),
                                                SizedBox(width: 8),
                                                Text(
                                                  "CNIC Verification Required",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Please verify your CNIC before proceeding.",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  "• If you are a Taker: You cannot request blood without CNIC verification.\n\n"
                                                  "• If you are a Donor: You cannot donate blood without verifying your CNIC.\n\n"
                                                  "👉 Go to your account section and verify your CNIC to continue.",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text("Later",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isDismissible: false,
                                                    enableDrag: false,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            top: 40),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20)),
                                                          child:
                                                              CardScanningScreen(),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  "Verify Now",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  height: 120,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 3.h, 5.w, 0),
                                        child: Center(
                                          child: Image.network(
                                            'https://www.shutterstock.com/image-vector/blood-collection-transfusion-icon-donor-600nw-2129911235.jpg',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              3.w, 1.h, 2.w, 0),
                                          child: Text(
                                            'Blood',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              3.w, 0.h, 2.w, 0),
                                          child: Text(
                                            'Bank',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                          )),
                                    ],
                                  ),
                                )),
                            GestureDetector(
                                onTap: () async {
                                  bool result = await homeController
                                      .checkUserCnicVerification();
                                  if (result) {
                                    userController.userModel!.type == 'donor'
                                        ? Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return const EmergencyDonorScreen();
                                              },
                                              transitionDuration:
                                                  const Duration(
                                                      microseconds: 100),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(10.0,
                                                    0.0); // slide in from the right
                                                const end = Offset.zero;
                                                const curve =
                                                    Curves.easeInOutQuart;

                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));
                                                var offsetAnimation =
                                                    animation.drive(tween);

                                                return SlideTransition(
                                                  position: offsetAnimation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          )
                                        : Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return const EmergencyTakerScreen();
                                              },
                                              transitionDuration:
                                                  const Duration(
                                                      microseconds: 100),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(10.0,
                                                    0.0); // slide in from the right
                                                const end = Offset.zero;
                                                const curve =
                                                    Curves.easeInOutQuart;

                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));
                                                var offsetAnimation =
                                                    animation.drive(tween);

                                                return SlideTransition(
                                                  position: offsetAnimation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                  } else {
                                    showDialog(
                                      context: navigatorKey.currentContext!,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          title: Row(
                                            children: [
                                              Icon(Icons.verified_user,
                                                  color: Colors.redAccent),
                                              SizedBox(width: 8),
                                              Text(
                                                "CNIC Verification Required",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Please verify your CNIC before proceeding.",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                "• If you are a Taker: You cannot request blood without CNIC verification.\n\n"
                                                "• If you are a Donor: You cannot donate blood without verifying your CNIC.\n\n"
                                                "👉 Go to your account section and verify your CNIC to continue.",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text("Later",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                showModalBottomSheet(
                                                  context: context,
                                                  isDismissible: false,
                                                  enableDrag: false,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          top: 40),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20)),
                                                        child:
                                                            CardScanningScreen(),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text(
                                                "Verify Now",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  height: 120,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 0.h, 5.w, 0),
                                        child: Center(
                                          child: Image.network(
                                            'https://www.shutterstock.com/image-vector/blood-drop-plus-heart-shape-600nw-2238094877.jpg',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              3.w, 0.h, 2.w, 0),
                                          child: Text(
                                            'Emergency',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              3.w, 0.h, 2.w, 0),
                                          child: Text(
                                            'Help',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                          )),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      userController.userModel == null
                          ? SizedBox()
                          : userController.userModel!.type == 'taker'
                              ? SizedBox(
                                  height: 15,
                                )
                              : SizedBox(),

                      userController.userModel == null
                          ? SizedBox()
                          : userController.userModel!.type == 'taker'
                              ? Container(
                                  height: 14.h,
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  3.w, 1.h, 0, 0.h),
                                              child: Text(
                                                'Blood Donor',
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  35.w, 1.h, 0, 0.h),
                                              child: const Icon(
                                                  Icons.location_on_outlined)),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 65,
                                                width: 18.w,
                                                // padding: EdgeInsets.,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.black26)),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                          'images/SVGRepo_iconCarrier.png',
                                                          height: 30),
                                                    ),
                                                    Text(
                                                      'O',
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                String blood = 'O';
                                                // Navigator.push(
                                                //   context,
                                                //   PageRouteBuilder(
                                                //     pageBuilder: (context, animation,
                                                //         secondaryAnimation) {
                                                //       return BloodOptionScreen(blood: blood);
                                                //     },
                                                //     transitionDuration:
                                                //         const Duration(
                                                //             microseconds: 100),
                                                //     transitionsBuilder: (context,
                                                //         animation,
                                                //         secondaryAnimation,
                                                //         child) {
                                                //       const begin = Offset(5.0,
                                                //           0.0); // slide in from the right
                                                //       const end = Offset.zero;
                                                //       const curve =
                                                //           Curves.easeInOutQuart;

                                                //       var tween = Tween(
                                                //               begin: begin, end: end)
                                                //           .chain(CurveTween(
                                                //               curve: curve));
                                                //       var offsetAnimation =
                                                //           animation.drive(tween);

                                                //       return SlideTransition(
                                                //         position: offsetAnimation,
                                                //         child: child,
                                                //       );
                                                //     },
                                                //   ),
                                                // );
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: GestureDetector(
                                              child: Container(
                                                height: 65,
                                                width: 20.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.black26)),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                          'images/SVGRepo_iconCarrier.png',
                                                          height: 30),
                                                    ),
                                                    Text(
                                                      'AB',
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                String blood = 'AB';
                                                // Navigator.push(
                                                //   context,
                                                //   PageRouteBuilder(
                                                //     pageBuilder: (context, animation,
                                                //         secondaryAnimation) {
                                                //       return BloodDonor(blood: blood);
                                                //     },
                                                //     transitionDuration:
                                                //         const Duration(
                                                //             microseconds: 100),
                                                //     transitionsBuilder: (context,
                                                //         animation,
                                                //         secondaryAnimation,
                                                //         child) {
                                                //       const begin = Offset(5.0,
                                                //           0.0); // slide in from the right
                                                //       const end = Offset.zero;
                                                //       const curve =
                                                //           Curves.easeInOutQuart;

                                                //       var tween = Tween(
                                                //               begin: begin, end: end)
                                                //           .chain(CurveTween(
                                                //               curve: curve));
                                                //       var offsetAnimation =
                                                //           animation.drive(tween);

                                                //       return SlideTransition(
                                                //         position: offsetAnimation,
                                                //         child: child,
                                                //       );
                                                //     },
                                                //   ),
                                                // );
                                              },
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: GestureDetector(
                                              child: Container(
                                                height: 65,
                                                width: 20.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.black26)),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                          'images/SVGRepo_iconCarrier.png',
                                                          height: 30),
                                                    ),
                                                    Text(
                                                      'B',
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                String blood = 'B';
                                                // Navigator.push(
                                                //   context,
                                                //   PageRouteBuilder(
                                                //     pageBuilder: (context, animation,
                                                //         secondaryAnimation) {
                                                //       return BloodDonor(blood: blood);
                                                //     },
                                                //     transitionDuration:
                                                //         const Duration(
                                                //             microseconds: 100),
                                                //     transitionsBuilder: (context,
                                                //         animation,
                                                //         secondaryAnimation,
                                                //         child) {
                                                //       const begin = Offset(5.0,
                                                //           0.0); // slide in from the right
                                                //       const end = Offset.zero;
                                                //       const curve =
                                                //           Curves.easeInOutQuart;

                                                //       var tween = Tween(
                                                //               begin: begin, end: end)
                                                //           .chain(CurveTween(
                                                //               curve: curve));
                                                //       var offsetAnimation =
                                                //           animation.drive(tween);

                                                //       return SlideTransition(
                                                //         position: offsetAnimation,
                                                //         child: child,
                                                //       );
                                                //     },
                                                //   ),
                                                // );
                                              },
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: GestureDetector(
                                              onTap: () {
                                                String blood = 'A-';
                                                // Navigator.push(
                                                //   context,
                                                //   PageRouteBuilder(
                                                //     pageBuilder: (context, animation,
                                                //         secondaryAnimation) {
                                                //       return BloodDonor(
                                                //         blood: blood,
                                                //       );
                                                //     },
                                                //     transitionDuration:
                                                //         const Duration(
                                                //             microseconds: 100),
                                                //     transitionsBuilder: (context,
                                                //         animation,
                                                //         secondaryAnimation,
                                                //         child) {
                                                //       const begin = Offset(5.0,
                                                //           0.0); // slide in from the right
                                                //       const end = Offset.zero;
                                                //       const curve =
                                                //           Curves.easeInOutQuart;

                                                //       var tween = Tween(
                                                //               begin: begin, end: end)
                                                //           .chain(CurveTween(
                                                //               curve: curve));
                                                //       var offsetAnimation =
                                                //           animation.drive(tween);

                                                //       return SlideTransition(
                                                //         position: offsetAnimation,
                                                //         child: child,
                                                //       );
                                                //     },
                                                //   ),
                                                // );
                                              },
                                              child: Container(
                                                height: 65,
                                                width: 25.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      child: Image.asset(
                                                          'images/SVGRepo_iconCarrier.png',
                                                          height: 30),
                                                    ),
                                                    Text(
                                                      'A-',
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                              : SizedBox(),

                      userController.userModel == null
                          ? SizedBox()
                          : userController.userModel!.type == 'donor'
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Donation Request',
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                      userController.userModel != null &&
                              userController.userModel!.type == 'donor' &&
                              !homeController.isLoading &&
                              homeController.takerList.isEmpty
                          ? Center(child: Text('no data found'))
                          : SizedBox(
                              height: 27.h,
                              child: ListView.builder(
                                  controller: homeController.scrollController,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  itemCount: homeController.isLoading
                                      ? 3
                                      : homeController.takerList.length,
                                  // physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (homeController.isLoading &&
                                        homeController.takerList.isEmpty) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 23.5.h,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 5.w),
                                          decoration: ShapeDecoration(
                                            color: Colors.grey[300],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (!homeController.isLoading &&
                                        homeController.takerList.isEmpty) {
                                      return Center(
                                          child: Text('no data found'));
                                    } else {
                                      FeedTakerModel takerFeed =
                                          homeController.takerList[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 23.5.h,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 12),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Color(0xFFDDDDDD)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: takerFeed
                                                                .image!
                                                                .isNotEmpty
                                                            ? takerFeed.image!
                                                            : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                        placeholder: (context,
                                                                url) =>
                                                            const CupertinoActivityIndicator(
                                                          color: Colors.white,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              takerFeed.name!,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          15.w),
                                                              child:
                                                                  CustomPaint(
                                                                size: Size(
                                                                    40, 30),
                                                                painter: BloodDropPainter(
                                                                    blood: takerFeed
                                                                        .blood!),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 12),
                                                        Container(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 220,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Hospital :',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF5A5A5A),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            0.13,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        child:
                                                                            Text(
                                                                          takerFeed
                                                                              .hospitalName!,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFF5A5A5A),
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            height:
                                                                                0.13,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Location :',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF5A5A5A),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            0.13,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      takerFeed
                                                                          .location!,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF5A5A5A),
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            0.13,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Date :',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF5A5A5A),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            0.13,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      takerFeed
                                                                          .date!,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF5A5A5A),
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            0.13,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Time :',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF5A5A5A),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            0.13,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      takerFeed
                                                                          .time!,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF5A5A5A),
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            0.13,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SizedBox(
                                                              width: 25.w,
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  if (homeController
                                                                          .isAvailability ==
                                                                      true) {
                                                                    Get.snackbar(
                                                                      "Error",
                                                                      "You have already donated blood. If you want to donate again, please wait for 90 days.",
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                      snackStyle:
                                                                          SnackStyle
                                                                              .FLOATING,
                                                                      backgroundColor: Colors
                                                                          .red
                                                                          .withValues(
                                                                              alpha: 0.9),
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              10),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                      borderRadius:
                                                                          8,
                                                                      icon: Icon(
                                                                          Icons
                                                                              .error,
                                                                          color:
                                                                              Colors.white),
                                                                    );
                                                                  } else {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageRouteBuilder(
                                                                        pageBuilder: (context,
                                                                            animation,
                                                                            secondaryAnimation) {
                                                                          return DonateBoodScreen(
                                                                            payload:
                                                                                takerFeed,
                                                                            mapController:
                                                                                homeController.controllers,
                                                                          );
                                                                        },
                                                                        transitionDuration:
                                                                            const Duration(microseconds: 100),
                                                                        transitionsBuilder: (context,
                                                                            animation,
                                                                            secondaryAnimation,
                                                                            child) {
                                                                          const begin = Offset(
                                                                              10.0,
                                                                              0.0); // slide in from the right
                                                                          const end =
                                                                              Offset.zero;
                                                                          const curve =
                                                                              Curves.easeInOutQuart;

                                                                          var tween =
                                                                              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                                                          var offsetAnimation =
                                                                              animation.drive(tween);

                                                                          return SlideTransition(
                                                                            position:
                                                                                offsetAnimation,
                                                                            child:
                                                                                child,
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 30,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              25),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child: Text(
                                                                    'Accept',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                            ),

                      if (userController.userModel != null &&
                          userController.userModel!.type == 'taker')
                        SizedBox(
                          height: 10,
                        ),

                      userController.userModel == null
                          ? SizedBox()
                          : userController.userModel!.type == 'taker'
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'See Donor Acceptanace',
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : SizedBox(),

                      userController.userModel == null
                          ? SizedBox()
                          : userController.userModel!.type == 'taker'
                              ? homeController.seeList.isEmpty
                                  ? Center(
                                      child: Text(
                                        'no data found',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      itemCount: homeController.seeList.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        DonateAcceptModel donor =
                                            homeController.seeList[index];

                                        return Card(
                                          color: Colors.white,
                                          elevation: 3,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Avatar
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: CachedNetworkImage(
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                    imageUrl: donor.donorImage
                                                            .isNotEmpty
                                                        ? donor.donorImage
                                                        : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        const CupertinoActivityIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),

                                                // Info Column
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Name + Blood type
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              donor.donorName,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          CustomPaint(
                                                            size: const Size(
                                                                45, 30),
                                                            painter:
                                                                BloodDropPainter(
                                                                    blood: donor
                                                                        .blood),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),

                                                      // Details with icons
                                                      _infoRow(
                                                          Icons.local_hospital,
                                                          donor.hospitalName),
                                                      const SizedBox(height: 6),
                                                      _infoRow(
                                                          Icons.location_on,
                                                          donor.location),
                                                      const SizedBox(height: 6),
                                                      _infoRow(Icons.date_range,
                                                          donor.date),
                                                      const SizedBox(height: 6),
                                                      _infoRow(
                                                          Icons.access_time,
                                                          donor.time),

                                                      const SizedBox(
                                                          height: 12),

                                                      // See more button
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (context,
                                                                    animation,
                                                                    secondaryAnimation) {
                                                                  return TakerReachScreen(
                                                                    acceptModel:
                                                                        donor,
                                                                    mapController:
                                                                        homeController
                                                                            .controllers,
                                                                  );
                                                                },
                                                                transitionsBuilder:
                                                                    (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                  var tween = Tween(
                                                                          begin: const Offset(
                                                                              1.0,
                                                                              0.0),
                                                                          end: Offset
                                                                              .zero)
                                                                      .chain(CurveTween(
                                                                          curve:
                                                                              Curves.easeInOut));
                                                                  return SlideTransition(
                                                                    position: animation
                                                                        .drive(
                                                                            tween),
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                PRIMARY_COLOR,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        8),
                                                          ),
                                                          child: const Text(
                                                            "See More",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
// Reusable info row widget

                              : SizedBox(),

                      userController.userModel == null
                          ? SizedBox()
                          : userController.userModel!.type == 'donor'
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('Blood Journey Map',
                                            style: TextStyle(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      ),
                                    ),
                                    ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      itemCount:
                                          homeController.donorList.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        if (homeController.donorList.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              'No data found',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          );
                                        } else {
                                          DonateAcceptModel list =
                                              homeController.donorList[index];
                                          return Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 6),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.grey
                                                    .withValues(alpha: .2),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withValues(alpha: 0.15),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                /// TOP ROW: Profile + Info
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    /// Profile Image
                                                    Container(
                                                      width: 70,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueAccent,
                                                            width: 2),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: list.image
                                                                  .isNotEmpty
                                                              ? list.image
                                                              : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Center(
                                                            child:
                                                                CupertinoActivityIndicator(),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .redAccent),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),

                                                    /// Donor Info
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          /// Full name
                                                          Text(
                                                            list.fullname,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),

                                                          /// Location
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Location: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  list.location,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),

                                                          /// Hospital Name
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Hospital: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  list.hospitalName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),

                                                          /// Blood Group
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Blood Group: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  list.blood,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .redAccent,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),

                                                          /// Date
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Date: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  list.date,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 6),

                                                          /// Time
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Time: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  list.time,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 14),

                                                /// ACTION BUTTON
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      bool result =
                                                          await homeController
                                                              .checkUserCnicVerification();
                                                      if (result) {
                                                        Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) {
                                                              return BloodJourneyScreen(
                                                                donateModel:
                                                                    list,
                                                                mapController:
                                                                    homeController
                                                                        .controllers,
                                                              );
                                                            },
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            transitionsBuilder:
                                                                (context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child) {
                                                              const begin =
                                                                  Offset(
                                                                      1.0, 0.0);
                                                              const end =
                                                                  Offset.zero;
                                                              const curve = Curves
                                                                  .easeInOutCubic;

                                                              var tween = Tween(
                                                                      begin:
                                                                          begin,
                                                                      end: end)
                                                                  .chain(CurveTween(
                                                                      curve:
                                                                          curve));
                                                              var offsetAnimation =
                                                                  animation
                                                                      .drive(
                                                                          tween);

                                                              return SlideTransition(
                                                                position:
                                                                    offsetAnimation,
                                                                child: child,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      } else {
                                                        showDialog(
                                                          context: navigatorKey
                                                              .currentContext!,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                              title: Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .verified_user,
                                                                      color: Colors
                                                                          .redAccent),
                                                                  SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                    "CNIC Verification Required",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Please verify your CNIC before proceeding.",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          12),
                                                                  Text(
                                                                    "• If you are a Taker: You cannot request blood without CNIC verification.\n\n"
                                                                    "• If you are a Donor: You cannot donate blood without verifying your CNIC.\n\n"
                                                                    "👉 Go to your account section and verify your CNIC to continue.",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: Text(
                                                                      "Later",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black)),
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .redAccent,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      isDismissible:
                                                                          false,
                                                                      enableDrag:
                                                                          false,
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: 40),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.vertical(top: Radius.circular(20)),
                                                                          ),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.vertical(top: Radius.circular(20)),
                                                                            child:
                                                                                CardScanningScreen(),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    "Verify Now",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 140,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .green.shade600,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.green
                                                                .withValues(
                                                                    alpha: 0.2),
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Text(
                                                        'Accepted',
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                )
                              : SizedBox(),
                      SizedBox(
                        height: 13.h,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}

class BloodDropPainter extends CustomPainter {
  final String blood;

  BloodDropPainter({required this.blood});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = PRIMARY_COLOR
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
        size.width, size.height * 0.25, size.width / 2, size.height);
    path.quadraticBezierTo(0, size.height * 0.25, size.width / 2, 0);

    canvas.drawPath(path, paint);

    // Adding text inside the blood drop
    TextSpan span = new TextSpan(
      style: new TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      text: blood,
    );
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas,
        new Offset(
            size.width / 2 - tp.width / 2, size.height / 2 - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
