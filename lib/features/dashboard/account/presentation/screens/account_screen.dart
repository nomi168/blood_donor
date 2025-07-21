// ignore_for_file: file_names

import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/auth/presentation/controllers/user_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/controllers/account_controller.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/edit_profile_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/history_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/manage_address_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/payment_info_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/refferral_screen.dart';
import 'package:blood_donor/features/dashboard/account/presentation/screens/reward_points_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
          return Column(children: [
            Container(
              child: Stack(
                children: [
                  Container(
                      color: const Color.fromRGBO(244, 67, 54, 1),
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
                    margin: EdgeInsets.only(top: 29.h, left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 11.h,
                    width: 100.w,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.w, 0, 0, 3.h),
                          child: Image.network(
                            'https://t4.ftcdn.net/jpg/01/05/48/99/360_F_105489957_HLDAbr6hatX6iKvR4DEZ38YVZJHXl8As.jpg',
                            width: 13.w,
                            height: 13.h,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35.w, 0, 0, 3.h),
                          child: Image.network(
                            'https://img.freepik.com/free-vector/blood-donor-day-poster-with-heart-blood-drop_1017-25357.jpg',
                            width: 13.w,
                            height: 13.h,
                          ),
                        ),
                        UserController.to.userModel!.type == 'donor'
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(57.w, 2.h, 0, 0.h),
                                child: controller.nextDonationDate == null
                                    ? Text(
                                        'donate now',
                                        style: TextStyle(
                                            color: PRIMARY_COLOR,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        controller.remainingTime.isNegative
                                            ? "You are eligible to donate now!"
                                            : " ${controller.remainingTime.inDays} d, "
                                                "${controller.remainingTime.inHours % 24} h, ${controller.remainingTime.inMinutes % 60} minutes, "
                                                "${controller.remainingTime.inSeconds % 60} sec",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                              )
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.w, 7.5.h, 0, 0.h),
                          child: Text(
                            '${UserController.to.userModel!.bloodgroup} Group',
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(32.w, 7.5.h, 0, 0.h),
                            child: Text(
                              UserController.to.userModel!.type == 'taker'
                                  ? 'taker blood'
                                  : '${UserController.to.userModel!.bloodcount.toString()} life save',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            )),
                        UserController.to.userModel!.type == 'donor'
                            ? Padding(
                                padding:
                                    EdgeInsets.fromLTRB(58.w, 7.5.h, 0, 0.h),
                                child: Text(
                                  'Next Donation',
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ))
                            : SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            UserController.to.userModel!.type == 'donor' ||
                    controller.checkExistDonor == true
                ? Container(
                    height: 6.h,
                    margin: EdgeInsets.symmetric(horizontal: 22.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            controller.selectedOption = 'taker';
                            controller.update();

                            bool? response =
                                await controller.addingDonorSwitcher(
                                    UserController.to.userModel!.email);

                            if (response == true) {
                              bool? result = await controller.updateUserType(
                                  'taker', UserController.to.userModel!.email);

                              if (result == true) {
                                SystemNavigator.pop();
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Could not update user. Please try again.",
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
                                "Failed to create donor switcher. Please check your details and try again.'",
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
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 25.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: controller.selectedOption == 'taker'
                                  ? PRIMARY_COLOR
                                  : Colors.white,
                            ),
                            child: Text(
                              'Taker',
                              style: TextStyle(
                                fontSize: 14,
                                color: controller.selectedOption == 'taker'
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            controller.selectedOption = 'donor';
                            controller.update();

                            bool? result = await controller.updateUserType(
                                'donor', UserController.to.userModel!.email);

                            if (result == true) {
                              SystemNavigator.pop();
                            } else {
                              Get.snackbar(
                                "Error",
                                "Could not update user. Please try again.",
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
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 25.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: controller.selectedOption == 'donor'
                                  ? PRIMARY_COLOR
                                  : Colors.white,
                            ),
                            child: Text(
                              'Donor',
                              style: TextStyle(
                                fontSize: 14,
                                color: controller.selectedOption == 'donor'
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            UserController.to.userModel!.type == 'donor'
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_available,
                          color: Colors.red,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Available To Donate',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(08)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // First container

                              // Second container
                              Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: controller.availablility == true
                                      ? PRIMARY_COLOR
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text('No',
                                      style: TextStyle(
                                          color:
                                              controller.availablility == true
                                                  ? Colors.white
                                                  : Colors.black)),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: controller.availablility == false
                                      ? PRIMARY_COLOR
                                      : Colors
                                          .white, // Grey if condition is true, Red otherwise
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text('Yes',
                                      style: TextStyle(
                                          color:
                                              controller.availablility == false
                                                  ? Colors.white
                                                  : Colors.black)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Manage Address',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const ManageAddressScreen();
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
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.point_of_sale,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Reward Points',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const RewardPointsScreen();
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
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_membership,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Refferral Invitation',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const RefferalInvitationScreen();
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
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'History',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const HistoryScreen();
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
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.payment,
                    color: Colors.red,
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Payment Info',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const PaymentInfoScreen();
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
                    },
                  ),
                ],
              ),
            )
          ]);
        },
      ),
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
