// ignore_for_file: file_names

import 'package:badges/badges.dart' as badge;
import 'package:blood_donor/core/utils/services/notification_storage.dart';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/core/utils/console_logs.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/auth/presentation/screens/card_scanning_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_banks_update/taker_blood_bank_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_journey/donor_location_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/dashboatd.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/see_more/taker_analysis_screen.dart';
import 'package:blood_donor/features/dashboard/notifications/presentation/constroller/notification_controller.dart';
import 'package:blood_donor/features/dashboard/notifications/presentation/screens/notification_screen.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';
import 'package:blood_donor/features/dashboard/home/presentation/controllers/home_controller.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/blood_banks_update/blood_bank_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/donate_blood/donate_bood_screen.dart';
import 'package:blood_donor/features/dashboard/home/presentation/screens/emergency_help/emergency_taker_screen.dart';
import 'package:blood_donor/features/dashboard/post_blood/presentation/screens/post_request_screen.dart';
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

import 'emergency_help/emergency_donor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Color?> colorAnimation;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animationController.dispose();
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
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    colorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.green.withValues(alpha: .3),
    ).animate(animationController);
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
              // ignore: deprecated_member_use
              return WillPopScope(
                onWillPop: () => homeController.onWillPop(context),
                child: RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  color: PRIMARY_COLOR,
                  onRefresh: () async {
                    await homeController.refreshData();
                  },
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
                            // GestureDetector(
                            //   onTap: () async {
                            //     await homeController.refreshData();
                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: CircleAvatar(
                            //       radius: 14,
                            //       backgroundColor: const Color(0xFFDE0A1E),
                            //       child: homeController.isRefreshHome
                            //           ? const SizedBox(
                            //               height: 16,
                            //               width: 16,
                            //               child: CircularProgressIndicator(
                            //                 strokeWidth: 2.0,
                            //                 valueColor:
                            //                     AlwaysStoppedAnimation<Color>(
                            //                         Colors.white),
                            //               ),
                            //             )
                            //           : const Icon(
                            //               Icons.refresh,
                            //               color: Colors.white,
                            //               size: 18,
                            //             ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              width: 5,
                            ),
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
                              child:
                                  GetBuilder<NotificationsProvider>(builder: (
                                cont,
                              ) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: badge.Badge(
                                      showBadge: cont.notifications
                                          .where((element) =>
                                              element.read == false)
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
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.5),
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
                            bool result = await homeController
                                .checkUserCnicVerification();
                            if (result) {
                              Map<String, dynamic> payload = {
                                'email': userController.userModel!.email
                              };
                              bool result = await homeController
                                  .checkTakerBloodRequest(payload);
                              if (result) {
                                String blood =
                                    homeController.selectedBloodGroup;
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
                                    icon:
                                        Icon(Icons.error, color: Colors.white),
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
                                                margin:
                                                    EdgeInsets.only(top: 40),
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
                                            final dashboardState =
                                                context.findAncestorStateOfType<
                                                    DashboardState>();
                                            dashboardState?.navigateToFeedTab();
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            3.w, 0.h, 2.w, 0),
                                                    child: Text(
                                                      'Donate',
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black54),
                                                    )),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            3.w, 0.h, 2.w, 0),
                                                    child: Text(
                                                      'Blood',
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black54),
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
                                                        const begin = Offset(
                                                            10.0,
                                                            0.0); // slide in from the right
                                                        const end = Offset.zero;
                                                        const curve = Curves
                                                            .easeInOutQuart;

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
                                              showDialog(
                                                context: navigatorKey
                                                    .currentContext!,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Icon(
                                                            Icons.verified_user,
                                                            color: Colors
                                                                .redAccent),
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
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isDismissible:
                                                                false,
                                                            enableDrag: false,
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            40),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              20)),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top: Radius.circular(
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            3.w, 0.h, 2.w, 0),
                                                    child: Text(
                                                      'Post Blood',
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black54),
                                                    )),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            3.w, 0.h, 2.w, 0),
                                                    child: Text(
                                                      'Request',
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black54),
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
                                            transitionDuration: const Duration(
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
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text("Later",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
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
                                                pageBuilder: (context,
                                                    animation,
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
                                                          begin: begin,
                                                          end: end)
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
                                                pageBuilder: (context,
                                                    animation,
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
                                                          begin: begin,
                                                          end: end)
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.w),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                )),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    35.w, 1.h, 0, 0.h),
                                                child: const Icon(Icons
                                                    .location_on_outlined)),
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
                                                          color:
                                                              Colors.black26)),
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  // Navigator.of(context).push(
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             EmergencyTakerScreen()));
                                                  // final dashboardState = context
                                                  //     .findAncestorStateOfType<
                                                  //         DashboardState>();
                                                  // dashboardState
                                                  //     ?.navigateToFeedTab();
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
                                                          color:
                                                              Colors.black26)),
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  // final dashboardState = context
                                                  //     .findAncestorStateOfType<
                                                  //         DashboardState>();
                                                  // dashboardState
                                                  //     ?.navigateToFeedTab();
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
                                                          color:
                                                              Colors.black26)),
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  // final dashboardState = context
                                                  //     .findAncestorStateOfType<
                                                  //         DashboardState>();
                                                  // dashboardState
                                                  //     ?.navigateToFeedTab();
                                                },
                                              )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: GestureDetector(
                                                onTap: () {
                                                  // final dashboardState = context
                                                  //     .findAncestorStateOfType<
                                                  //         DashboardState>();
                                                  // dashboardState
                                                  //     ?.navigateToFeedTab();
                                                },
                                                child: Container(
                                                  height: 65,
                                                  width: 25.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                                FontWeight
                                                                    .bold),
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
                        SizedBox(
                          height: 10,
                        ),

                        userController.userModel == null
                            ? SizedBox()
                            : userController.userModel!.type == 'donor' &&
                                    homeController.donorData == null &&
                                    homeController.isBloodJourney
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 180,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: ShapeDecoration(
                                        color: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                : homeController.donorData != null &&
                                        !homeController.isBloodJourney
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text('Blood Journey Map',
                                                  style: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.left),
                                            ),
                                          ),
                                          homeController.donorData == null
                                              ? SizedBox()
                                              : Container(
                                                  width: double.infinity,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 6),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 14,
                                                      vertical: 16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey
                                                          .withValues(
                                                              alpha: .2),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withValues(
                                                                alpha: 0.15),
                                                        blurRadius: 8,
                                                        offset:
                                                            const Offset(0, 4),
                                                        spreadRadius: 2,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      /// TOP ROW: Profile + Info
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          /// Profile Image
                                                          Container(
                                                            width: 70,
                                                            height: 70,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  width: 2),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child:
                                                                  CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl: homeController
                                                                        .donorData!
                                                                        .image
                                                                        .isNotEmpty
                                                                    ? homeController
                                                                        .donorData!
                                                                        .image
                                                                    : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const Center(
                                                                  child:
                                                                      CupertinoActivityIndicator(),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .redAccent),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 12),

                                                          /// Donor Info
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                /// Full name
                                                                Text(
                                                                  homeController
                                                                      .donorData!
                                                                      .fullname,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
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
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        homeController
                                                                            .donorData!
                                                                            .location,
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
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        homeController
                                                                            .donorData!
                                                                            .hospitalName,
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
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        homeController
                                                                            .donorData!
                                                                            .blood,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.redAccent,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        homeController
                                                                            .donorData!
                                                                            .date,
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
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        homeController
                                                                            .donorData!
                                                                            .time,
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

                                                      const SizedBox(
                                                          height: 14),

                                                      /// ACTION BUTTON

                                                      if (colorAnimation
                                                              .isAnimating ==
                                                          false)
                                                        const SizedBox.shrink()
                                                      else // wait until initialized

                                                        AnimatedBuilder(
                                                          animation:
                                                              colorAnimation,
                                                          builder:
                                                              (context, child) {
                                                            return Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                splashFactory:
                                                                    NoSplash
                                                                        .splashFactory,
                                                                onTap:
                                                                    () async {
                                                                  bool result =
                                                                      await homeController
                                                                          .checkUserCnicVerification();
                                                                  if (result) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageRouteBuilder(
                                                                        pageBuilder: (context,
                                                                            animation,
                                                                            secondaryAnimation) {
                                                                          return DonorLocationScreen(
                                                                            donateModel:
                                                                                homeController.donorData!,
                                                                            mapController:
                                                                                homeController.controllers,
                                                                          );
                                                                        },
                                                                        transitionDuration:
                                                                            const Duration(milliseconds: 300),
                                                                        transitionsBuilder: (context,
                                                                            animation,
                                                                            secondaryAnimation,
                                                                            child) {
                                                                          const begin = Offset(
                                                                              1.0,
                                                                              0.0);
                                                                          const end =
                                                                              Offset.zero;
                                                                          const curve =
                                                                              Curves.easeInOutCubic;

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
                                                                  } else {
                                                                    showDialog(
                                                                      context:
                                                                          navigatorKey
                                                                              .currentContext!,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                          ),
                                                                          title:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.verified_user, color: Colors.redAccent),
                                                                              SizedBox(width: 8),
                                                                              Text(
                                                                                "CNIC Verification Required",
                                                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          content:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Please verify your CNIC before proceeding.",
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                                                              ),
                                                                              SizedBox(height: 12),
                                                                              Text(
                                                                                "• If you are a Taker: You cannot request blood without CNIC verification.\n\n"
                                                                                "• If you are a Donor: You cannot donate blood without verifying your CNIC.\n\n"
                                                                                "👉 Go to your account section and verify your CNIC to continue.",
                                                                                style: TextStyle(fontSize: 14, color: Colors.black87),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                              child: Text("Later", style: TextStyle(color: Colors.black)),
                                                                            ),
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.redAccent,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
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
                                                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                                                      ),
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                                                        child: CardScanningScreen(),
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
                                                                child:
                                                                    AnimatedContainer(
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: colorAnimation
                                                                        .value,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .transparent),
                                                                  ),
                                                                  child: Text(
                                                                    'Start Journey',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      )
                                    : SizedBox(),

                        userController.userModel == null
                            ? SizedBox()
                            : userController.userModel!.type == 'donor' &&
                                    homeController.takerList.isEmpty &&
                                    homeController.isLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 180,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: ShapeDecoration(
                                        color: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                : homeController.takerList.isNotEmpty &&
                                        !homeController.isLoading
                                    ? Column(
                                        children: [
                                          Container(
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            // height: 33.h,
                                            child: ListView.builder(
                                                controller: homeController
                                                    .scrollController,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                itemCount:
                                                    homeController.isLoading
                                                        ? 3
                                                        : homeController
                                                            .takerList.length,
                                                // physics: AlwaysScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  if (homeController
                                                          .isLoading &&
                                                      homeController
                                                          .takerList.isEmpty) {
                                                    return Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        height: 23.5.h,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 0,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            ShapeDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (!homeController
                                                          .isLoading &&
                                                      homeController
                                                          .takerList.isEmpty) {
                                                    return Center(
                                                        child: Text(
                                                            'no data found'));
                                                  } else {
                                                    FeedTakerModel takerFeed =
                                                        homeController
                                                            .takerList[index];
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: const Color(
                                                                    0xFFDDDDDD),
                                                                width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: Colors.white,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              /// TOP IMAGE
                                                              Container(
                                                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                                child: Row(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        width: 65,
                                                                        height:
                                                                            65,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        imageUrl: takerFeed
                                                                                .image!
                                                                                .isNotEmpty
                                                                            ? takerFeed
                                                                                .image!
                                                                            : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                const CupertinoActivityIndicator(),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            const Icon(
                                                                                Icons.error),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 20,),
                                                                    Text(
                                                                      takerFeed
                                                                          .name!,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    Spacer(),
                                                                    CustomPaint(
                                                                      size:
                                                                          const Size(
                                                                              40,
                                                                              30),
                                                                      painter:
                                                                          BloodDropPainter(
                                                                        blood: takerFeed
                                                                            .blood!,
                                                                      ),
                                                                    ),
                                                                   
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    /// NAME + BLOOD GROUP
                                                                
                                                                    const SizedBox(
                                                                        height:
                                                                            12),
                                                                
                                                                    /// HOSPITAL
                                                                    _iconInfoRow(
                                                                      icon: Icons
                                                                          .local_hospital,
                                                                      title:
                                                                          "Hospital",
                                                                      value: takerFeed
                                                                          .hospitalName!,
                                                                    ),
                                                                
                                                                    /// LOCATION
                                                                    _iconInfoRowWidget(
                                                                      icon: Icons
                                                                          .location_on,
                                                                      title:
                                                                          "Location",
                                                                      valueWidget: buildLocationText(
                                                                          context,
                                                                          takerFeed
                                                                              .location!),
                                                                    ),
                                                                
                                                                    const SizedBox(
                                                                        height:
                                                                            6),
                                                                
                                                                    /// DATE & TIME
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              _iconInfoRow(
                                                                            icon:
                                                                                Icons.calendar_today,
                                                                            title:
                                                                                "Date",
                                                                            value:
                                                                                takerFeed.date!,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              _iconInfoRow(
                                                                            icon:
                                                                                Icons.access_time,
                                                                            title:
                                                                                "Time",
                                                                            value:
                                                                                takerFeed.time!,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                
                                                                    
                                                                
                                                                    /// ACTION BUTTON
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (UserController.to.userModel!.bloodgroup !=
                                                                              takerFeed.blood) {
                                                                            Get.snackbar(
                                                                              "Info",
                                                                              "You cannot donate blood because your blood group is ${UserController.to.userModel!.bloodgroup} while the blood request requires ${takerFeed.blood}.",
                                                                              snackPosition: SnackPosition.TOP,
                                                                              snackStyle: SnackStyle.FLOATING,
                                                                              backgroundColor: Colors.blue.withValues(alpha: 0.9),
                                                                              colorText: Colors.white,
                                                                              margin: const EdgeInsets.all(10),
                                                                              duration: const Duration(seconds: 3),
                                                                              borderRadius: 8,
                                                                              icon: const Icon(Icons.info, color: Colors.white),
                                                                            );
                                                                          } else {
                                                                            if (homeController.isAvailability ==
                                                                                true) {
                                                                              Get.snackbar(
                                                                                "Error",
                                                                                "You have already donated blood. If you want to donate again, please wait for 90 days.",
                                                                                snackPosition: SnackPosition.TOP,
                                                                                snackStyle: SnackStyle.FLOATING,
                                                                                backgroundColor: Colors.red.withValues(alpha: 0.9),
                                                                                colorText: Colors.white,
                                                                                margin: const EdgeInsets.all(10),
                                                                                duration: const Duration(seconds: 3),
                                                                                borderRadius: 8,
                                                                                icon: const Icon(Icons.error, color: Colors.white),
                                                                              );
                                                                            } else {
                                                                              Navigator.push(
                                                                                context,
                                                                                PageRouteBuilder(
                                                                                  pageBuilder: (_, animation, __) => DonateBoodScreen(
                                                                                    payload: takerFeed,
                                                                                    mapController: homeController.controllers,
                                                                                  ),
                                                                                  transitionDuration: const Duration(milliseconds: 200),
                                                                                  transitionsBuilder: (_, animation, __, child) {
                                                                                    final tween = Tween(
                                                                                      begin: const Offset(1, 0),
                                                                                      end: Offset.zero,
                                                                                    ).chain(CurveTween(curve: Curves.easeOut));
                                                                                    return SlideTransition(
                                                                                      position: animation.drive(tween),
                                                                                      child: child,
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              );
                                                                            }
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 28,
                                                                              vertical: 10),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.green,
                                                                            borderRadius:
                                                                                BorderRadius.circular(6),
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            "Accept",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10,)
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 12),
                                                      ],
                                                    );
                                                  }
                                                }),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),

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
                                        horizontal: 20, vertical: 0),
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
                                ? homeController.seeList == null
                                    ? Center(
                                        child: Text(
                                          'no data found',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      )
                                    : Card(
                                        color: Colors.white,
                                        elevation: 3,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 20),
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
                                                  imageUrl: homeController
                                                          .seeList!
                                                          .donorImage
                                                          .isNotEmpty
                                                      ? homeController
                                                          .seeList!.donorImage
                                                      : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                  placeholder: (context, url) =>
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Name + Blood type
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            homeController
                                                                .seeList!
                                                                .donorName,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        CustomPaint(
                                                          size: const Size(
                                                              45, 30),
                                                          painter: BloodDropPainter(
                                                              blood:
                                                                  homeController
                                                                      .seeList!
                                                                      .blood),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),

                                                    // Details with icons
                                                    _infoRow(
                                                        Icons.local_hospital,
                                                        homeController.seeList!
                                                            .hospitalName),
                                                    const SizedBox(height: 6),
                                                    _infoRow(
                                                        Icons.location_on,
                                                        homeController
                                                            .seeList!.location),
                                                    const SizedBox(height: 6),
                                                    _infoRow(
                                                        Icons.date_range,
                                                        homeController
                                                            .seeList!.date),
                                                    const SizedBox(height: 6),
                                                    _infoRow(
                                                        Icons.access_time,
                                                        homeController
                                                            .seeList!.time),

                                                    const SizedBox(height: 12),

                                                    // See more button
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context,
                                                                  animation,
                                                                  secondaryAnimation) {
                                                                return TakerAnalysisScreen(
                                                                  donateModel:
                                                                      homeController
                                                                          .seeList!,
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
                                                                        curve: Curves
                                                                            .easeInOut));
                                                                return SlideTransition(
                                                                  position: animation
                                                                      .drive(
                                                                          tween),
                                                                  child: child,
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
                                                                  vertical: 8),
                                                        ),
                                                        child: const Text(
                                                          "See More",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )

                                // Reusable info row widget\
                                : SizedBox(),

                        SizedBox(
                          height: 13.h,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _iconInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.redAccent),
          const SizedBox(width: 8),
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5A5A5A),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconInfoRowWidget({
    required IconData icon,
    required String title,
    required Widget valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.redAccent),
          const SizedBox(width: 8),
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5A5A5A),
            ),
          ),
          Expanded(child: valueWidget),
        ],
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

Widget buildLocationText(BuildContext context, String location) {
  // Trimmed text if longer than 20 characters
  final bool isLongText = location.length > 20;
  final String displayedText =
      isLongText ? '${location.substring(0, 13)}' : location;

  return InkWell(
    onTap: isLongText
        ? () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  insetPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Full Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.grey[700]),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                            ),
                            icon: Icon(Icons.location_on_outlined,
                                color: Colors.white),
                            label: Text(
                              'Close',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        : null,
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: displayedText,
            style: const TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              height: 0.13,
            ),
          ),
          if (isLongText)
            const TextSpan(
              text: ' Read more',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
        ],
      ),
    ),
  );
}
