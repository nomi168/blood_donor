// ignore_for_file: file_names

import 'dart:developer';

import 'package:blood_donor/Provider/Profile.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/DonorCard.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/EditProfile.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/History.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/ManageAddress.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/PaymentInfo.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/RewardPoints.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_switch/sliding_switch.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with WidgetsBindingObserver {
  bool? isSwitched;
  String fullname = '';
  String firstname = '';
  String lastname = '';
  String phonenumber = '';
  String blood = '';
  String picture = '';
  String nammm = '';
  String id = '';
  bool active = true;
  bool useractive = false;
  bool availabledonor = false;
  String location = '';
  bool checkboxslider = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getuserData();
    isSwitched = availabledonor;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  getuserData() async {
    await Future.delayed(Duration(milliseconds: 500));
    await getUserDataByEmail();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      updateStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      updateStatus(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = Provider.of<Profile>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
            color: const Color.fromRGBO(244, 67, 54, 1),
            height: 35.h,
            width: 100.w,
            child: Stack(
              children: [
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
                          imageUrl: picture,
                          placeholder: (context, url) =>
                              const CupertinoActivityIndicator(
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )),
                ),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(33.w, 15.h, 0, 0),
                        child: Center(
                          child: Text(
                            '$fullname',
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                    if (useractive)
                      Padding(
                          padding: EdgeInsets.fromLTRB(2.w, 15.h, 0, 0),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: useractive ? Colors.green : Colors.white,
                            ),
                          )),
                  ],
                ),
                if (phonenumber.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 21.5.h, 0, 0),
                      child: Center(
                          child: Text(
                        '0$phonenumber',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))),
                Padding(
                    padding: EdgeInsets.fromLTRB(85.w, 4.5.h, 0, 0),
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return EditProfile(
                                  image: picture,
                                  firstname: firstname,
                                  lastname: lastname,
                                  location: location,
                                  blood: blood,
                                  id: id);
                            },
                            transitionDuration: const Duration(seconds: 1),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                    ))
              ],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 30.h, 5.w, 0),
          child: Container(
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
                Padding(
                  padding: EdgeInsets.fromLTRB(68.w, 2.h, 0, 0.h),
                  child: Text(
                    '0',
                    style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 7.5.h, 0, 0.h),
                  child: Text(
                    '$blood Group',
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(32.w, 7.5.h, 0, 0.h),
                    child: Consumer<Profile>(
                      builder: (context, value, child) {
                        return Text(
                          value.life,
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        );
                      },
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(58.w, 7.5.h, 0, 0.h),
                    child: Text(
                      'Next Donation',
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ),
//

        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 47.h, 0, 0),
              child: const Icon(
                Icons.event_available,
                color: Colors.red,
                size: 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 46.5.h, 0, 0.h),
              child: Text(
                'Available To Donate',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(0.w, 46.5.h, 5.w, 0.h),
              child: SlidingSwitch(
                width: 20.w,
                height: 4.h,
                value: isSwitched!,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    updateStatusAvailble(isSwitched!);
                  });
                },
                animationDuration: const Duration(milliseconds: 400),
                onTap: () {},
                onDoubleTap: () {},
                onSwipe: () {},
                textOff: "off",
                textOn: "on",
                iconOff: Icons.offline_bolt,
                iconOn: Icons.light_mode,
                contentSize: 14,
                colorOn: Colors.red,
                colorOff: const Color(0xff6682c0),
              ),
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(0, 11.h, 0, 0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 43.h, 0, 0),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 42.5.h, 0, 0.h),
                  child: Text(
                    'Manage Address',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(30.w, 42.5.h, 0, 0.h),
                  child: IconButton(
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
                          transitionDuration: const Duration(seconds: 1),
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
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 18.h, 0, 0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 43.h, 0, 0),
                child: const Icon(
                  Icons.point_of_sale,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 42.5.h, 0, 0.h),
                  child: Text(
                    'Reward Points',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(35.w, 42.5.h, 0, 0.h),
                  child: IconButton(
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
                          transitionDuration: const Duration(seconds: 1),
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
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 25.h, 0, 0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 43.h, 0, 0),
                child: const Icon(
                  Icons.card_membership,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 42.5.h, 0, 0.h),
                  child: Text(
                    'Donor Card',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(41.w, 42.5.h, 0, 0.h),
                  child: IconButton(
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
                            return const DonorCardScreen();
                          },
                          transitionDuration: const Duration(seconds: 1),
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
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 32.h, 0, 0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 43.h, 0, 0),
                child: const Icon(
                  Icons.history,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 42.5.h, 0, 0.h),
                  child: Text(
                    'History',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(49.5.w, 42.5.h, 0, 0.h),
                  child: IconButton(
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
                          transitionDuration: const Duration(seconds: 1),
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
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 39.h, 0, 0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 43.h, 0, 0),
                child: const Icon(
                  Icons.payment,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 42.5.h, 0, 0.h),
                  child: Text(
                    'Payment Info',
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(37.w, 42.5.h, 0, 0.h),
                  child: IconButton(
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
                          transitionDuration: const Duration(seconds: 1),
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
                  )),
            ],
          ),
        )
      ]),
    );
  }

  Future<void> getUserDataByEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print(userEmail);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        String name = userDoc['firstname'];
        String name1 = userDoc['lastname'];
        String image1 = userDoc['image'];
        String number = userDoc['phonenumber'];
        String blood1 = userDoc['bloodgroup'];
        String loc = userDoc['location'];
        String idd = userDoc['id'];
        bool act = userDoc['status'];
        bool av = userDoc['availabledonate'];

        setState(() {
          fullname = name + " $name1";
          firstname = name;
          lastname = name1;
          phonenumber = number;
          blood = blood1;
          picture = image1;
          location = loc;
          id = idd;
          useractive = act;

          availabledonor = av;
        });

        // await displayImage(image);

        // Fetch and display the image from Firebase Storage
        // await displayImage(image);

        print(fullname);
      } else {
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateStatus(bool isActive) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'status': isActive});
        log("My Statis is $isActive");
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> updateStatusAvailble(bool isActive) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'availabledonate': isActive});
        log("My Statis is $isActive");
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
