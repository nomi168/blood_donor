// ignore_for_file: file_names

import 'package:blood_donor/common/widgets/profile_icons.dart';
import 'package:blood_donor/core/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/auth/presentation/screens/card_scanning_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/controllers/account_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/edit_profile_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/history_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/refferral_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/voucher_screen.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/faqs_screen.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/logout_screen.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/privacy_policy_screen.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/setting_screen.dart';
import 'package:blood_donor/features/dashboard/menus/presentation/screens/terms_conditions_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      UserController.to.updateAppStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      UserController.to.updateAppStatus(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AccountController>(
        init: AccountController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                        color: PRIMARY_COLOR,
                        height: 35.h,
                        width: 100.w,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 3.h,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                // ignore: prefer_const_constructors
                                icon: Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return EditProfileScreen(
                                          model: UserController.to.userModel!,
                                        );
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
                                },
                              ),
                            ),
                            Align(
                              child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          UserController.to.userModel!.image,
                                      placeholder: (context, url) =>
                                          const CupertinoActivityIndicator(
                                        color: Colors.white,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${UserController.to.userModel!.firstname} ${UserController.to.userModel!.lastname}',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                if (UserController.to.userModel!.status)
                                  Container(
                                    width: 10.0,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UserController.to.userModel!.status
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                            if (UserController
                                .to.userModel!.phonenumber.isNotEmpty)
                              Text(
                                UserController.to.userModel!.phonenumber,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                          ],
                        )),
                    Container(
                      margin:
                          EdgeInsets.only(top: 29.h, left: 10.w, right: 10.w),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Blood Group
                          Column(
                            children: [
                              Text(
                                '${UserController.to.userModel!.bloodgroup} Group',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                UserController.to.userModel!.type == 'taker'
                                    ? 'Taker'
                                    : '${UserController.to.userModel!.bloodcount} lives saved',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          // Center Image (Decorative)
                          Image.network(
                            'https://img.freepik.com/free-vector/blood-donor-day-poster-with-heart-blood-drop_1017-25357.jpg',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          // Donor Info
                          if (UserController.to.userModel!.type == 'donor')
                            Column(
                              children: [
                                Text(
                                  controller.nextDonationDate == null
                                      ? 'Donate Now'
                                      : controller.remainingTime.inDays == 0 &&
                                              controller
                                                      .remainingTime.inHours ==
                                                  0
                                          ? 'Eligible to Donate'
                                          : '${controller.remainingTime.inDays} days left',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Next Donation',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // UserController.to.userModel!.type == 'donor' ||
              //         controller.checkExistDonor == true
              //     ? Container(
              //         height: 6.h,
              //         margin: EdgeInsets.symmetric(horizontal: 22.w),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: Colors.grey.shade200,
              //         ),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             GestureDetector(
              //               onTap: () async {
              //                 if (controller.selectedOption == 'taker') {
              //                   Get.snackbar(
              //                     "Error",
              //                     "You are already taker",
              //                     snackPosition: SnackPosition.TOP,
              //                     snackStyle: SnackStyle.FLOATING,
              //                     backgroundColor:
              //                         Colors.red.withValues(alpha: 0.9),
              //                     colorText: Colors.white,
              //                     margin: EdgeInsets.all(10),
              //                     duration: Duration(seconds: 3),
              //                     borderRadius: 8,
              //                     icon: Icon(Icons.error, color: Colors.white),
              //                   );
              //                 } else {
              //                   controller.selectedOption = 'taker';
              //                   controller.update();

              //                   bool? response =
              //                       await controller.addingDonorSwitcher(
              //                           UserController.to.userModel!.email);

              //                   if (response == true) {
              //                     bool? result =
              //                         await controller.updateUserType('taker',
              //                             UserController.to.userModel!.email);

              //                     if (result == true) {
              //                       Restart.restartApp();
              //                     } else {
              //                       Get.snackbar(
              //                         "Error",
              //                         "Could not update user. Please try again.",
              //                         snackPosition: SnackPosition.TOP,
              //                         snackStyle: SnackStyle.FLOATING,
              //                         backgroundColor: Colors.white38,
              //                         colorText: Colors.white,
              //                         margin: EdgeInsets.all(10),
              //                         duration: Duration(seconds: 3),
              //                         borderRadius: 8,
              //                         icon: Icon(Icons.error,
              //                             color: Colors.white),
              //                       );
              //                     }
              //                   } else {
              //                     Get.snackbar(
              //                       "Error",
              //                       "Failed to create donor switcher. Please check your details and try again.'",
              //                       snackPosition: SnackPosition.TOP,
              //                       snackStyle: SnackStyle.FLOATING,
              //                       backgroundColor: Colors.white38,
              //                       colorText: Colors.white,
              //                       margin: EdgeInsets.all(10),
              //                       duration: Duration(seconds: 3),
              //                       borderRadius: 8,
              //                       icon:
              //                           Icon(Icons.error, color: Colors.white),
              //                     );
              //                   }
              //                 }
              //               },
              //               child: Container(
              //                 alignment: Alignment.center,
              //                 width: 25.w,
              //                 height: 5.h,
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(30),
              //                   color: controller.selectedOption == 'taker'
              //                       ? PRIMARY_COLOR
              //                       : Colors.white,
              //                 ),
              //                 child: Text(
              //                   'Taker',
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     color: controller.selectedOption == 'taker'
              //                         ? Colors.white
              //                         : Colors.black,
              //                     fontWeight: FontWeight.w500,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             SizedBox(width: 10),
              //             GestureDetector(
              //               onTap: () async {
              //                 if (controller.selectedOption == 'donor') {
              //                   Get.snackbar(
              //                     "Error",
              //                     "You are already donor",
              //                     snackPosition: SnackPosition.TOP,
              //                     snackStyle: SnackStyle.FLOATING,
              //                     backgroundColor: Colors.white38,
              //                     colorText: Colors.white,
              //                     margin: EdgeInsets.all(10),
              //                     duration: Duration(seconds: 3),
              //                     borderRadius: 8,
              //                     icon: Icon(Icons.error, color: Colors.white),
              //                   );
              //                 } else {
              //                   controller.selectedOption = 'donor';
              //                   controller.update();

              //                   bool? result = await controller.updateUserType(
              //                       'donor',
              //                       UserController.to.userModel!.email);

              //                   if (result == true) {
              //                     Restart.restartApp();
              //                   } else {
              //                     Get.snackbar(
              //                       "Error",
              //                       "Could not update user. Please try again.",
              //                       snackPosition: SnackPosition.TOP,
              //                       snackStyle: SnackStyle.FLOATING,
              //                       backgroundColor: Colors.white38,
              //                       colorText: Colors.white,
              //                       margin: EdgeInsets.all(10),
              //                       duration: Duration(seconds: 3),
              //                       borderRadius: 8,
              //                       icon:
              //                           Icon(Icons.error, color: Colors.white),
              //                     );
              //                   }
              //                 }
              //               },
              //               child: Container(
              //                 alignment: Alignment.center,
              //                 width: 25.w,
              //                 height: 5.h,
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(30),
              //                   color: controller.selectedOption == 'donor'
              //                       ? PRIMARY_COLOR
              //                       : Colors.white,
              //                 ),
              //                 child: Text(
              //                   'Donor',
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     color: controller.selectedOption == 'donor'
              //                         ? Colors.white
              //                         : Colors.black,
              //                     fontWeight: FontWeight.w500,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : SizedBox(),

              UserController.to.userModel!.type == 'donor'
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_available,
                              color: Colors.red, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Available To Donate',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: !controller.availablility
                                          ? PRIMARY_COLOR
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: !controller.availablility
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: controller.availablility == true
                                          ? PRIMARY_COLOR
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        color: controller.availablility == true
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              ProfileMenuTile(
                icon: Icons.verified,
                title: "CNIC Verification",
                onTap: () async {
                  bool result = await controller.checkUserCnicVerification(
                      UserController.to.userModel!.email);
                  if (result) {
                    Get.snackbar(
                      "Info",
                      "CNIC verification is already done",
                      snackPosition: SnackPosition.TOP,
                      snackStyle: SnackStyle.FLOATING,
                      backgroundColor: Colors.blue.withValues(alpha: 0.9),
                      colorText: Colors.white,
                      margin: EdgeInsets.all(10),
                      duration: Duration(seconds: 3),
                      borderRadius: 8,
                      icon: Icon(Icons.info, color: Colors.white),
                    );
                  } else {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              const CardScanningScreen(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutQuart)),
                              child: child,
                            );
                          },
                        ));
                  }
                },
              ),

              // Reward Points
              // ProfileMenuTile(
              //   icon: Icons.point_of_sale,
              //   title: "Reward Points",
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         PageRouteBuilder(
              //           pageBuilder: (_, __, ___) => const RewardPointsScreen(),
              //           transitionsBuilder: (_, animation, __, child) {
              //             return SlideTransition(
              //               position: Tween(
              //                       begin: const Offset(1, 0), end: Offset.zero)
              //                   .animate(CurvedAnimation(
              //                       parent: animation,
              //                       curve: Curves.easeInOutQuart)),
              //               child: child,
              //             );
              //           },
              //         ));
              //   },
              // ),

              // History
              ProfileMenuTile(
                icon: Icons.history,
                title: "History",
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HistoryScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween(
                                    begin: const Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOutQuart)),
                            child: child,
                          );
                        },
                      ));
                },
              ),

              if (UserController.to.userModel!.type == 'donor')
                ProfileMenuTile(
                  icon: Icons.payment,
                  title: "Vouchers",
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const VoucherScreen(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutQuart)),
                              child: child,
                            );
                          },
                        ));
                  },
                ),
              ProfileMenuTile(
                icon: Icons.card_membership,
                title: "Referral Invitation",
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const RefferalInvitationScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween(
                                    begin: const Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOutQuart)),
                            child: child,
                          );
                        },
                      ));
                },
              ),
              ProfileMenuTile(
                icon: Icons.policy,
                title: "Terms & Condition",
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const TermsConditionScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween(
                                    begin: const Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOutQuart)),
                            child: child,
                          );
                        },
                      ));
                },
              ),
              ProfileMenuTile(
                icon: Icons.question_mark,
                title: "FAQs",
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const FAQsScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween(
                                    begin: const Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOutQuart)),
                            child: child,
                          );
                        },
                      ));
                },
              ),
              ProfileMenuTile(
                icon: Icons.privacy_tip,
                title: "Privacy & Policy",
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const PrivacyPolicyScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween(
                                    begin: const Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOutQuart)),
                            child: child,
                          );
                        },
                      ));
                },
              ),

              ProfileMenuTile(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const SettingsScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween(
                                    begin: const Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOutQuart)),
                            child: child,
                          );
                        },
                      ));
                },
              ),
              ProfileMenuTile(
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () {
                    _showLogoutDialog(context);
                  }),
            ]),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: PRIMARY_COLOR),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('user_uid');
                prefs.remove('user_email');
                await prefs.clear();

                UserController.to.updateAppStatus(false);
                Get.delete<UserController>(force: true);

                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const LogoutScreen();
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
                  (Route<dynamic> route) =>
                      false, // Predicate that removes all the routes
                );
              },
              child: Text(
                "Logout",
                style: TextStyle(color: PRIMARY_COLOR),
              ),
            ),
          ],
        );
      },
    );
  }

  void showReferralPopup(BuildContext context) {
    String appLink =
        'https://play.google.com/store/apps/details?id=com.pakistan.Ebloodpakistan&pcampaignid=web_share'; // Your app link
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Container(
            height: 220,
            width: 300, // Adjust height based on your design
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'E Blood App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: TextEditingController(text: appLink),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'App Link',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        // Copy app link to clipboard
                        Clipboard.setData(ClipboardData(text: appLink));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('App link copied to clipboard!'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the popup
                    },
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
