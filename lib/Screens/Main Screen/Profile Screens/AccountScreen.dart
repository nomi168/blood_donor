// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';

import 'package:blood_donor/Provider/Profile.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/EditProfile.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/History.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/ManageAddress.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/PaymentInfo.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/Refferral.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/RewardPoints.dart';
import 'package:blood_donor/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

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
  String location = '';
  bool checkboxslider = false;
  bool availablility = false;
  String userType = '';
  String selectedOption = '';
  bool checkExistDonor = false;

  DateTime? nextDonationDate;
  Duration remainingTime = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getuserData();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
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
                                  const begin = Offset(
                                      10.0, 0.0); // slide in from the right
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$fullname',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          if (useractive)
                            Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: useractive ? Colors.green : Colors.white,
                              ),
                            ),
                        ],
                      ),
                      if (phonenumber.isNotEmpty)
                        Text(
                          '$phonenumber',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 250, left: 30, right: 30),
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
                    userType == 'donor'
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(57.w, 2.h, 0, 0.h),
                            child: nextDonationDate == null
                                ? Text(
                                    'donate now',
                                    style: TextStyle(
                                        color: PRIMARY_COLOR,
                                        fontWeight: FontWeight.w500),
                                  )
                                : Text(
                                    remainingTime.isNegative
                                        ? "You are eligible to donate now!"
                                        : " ${remainingTime.inDays} d, "
                                            "${remainingTime.inHours % 24} h, ${remainingTime.inMinutes % 60} minutes, "
                                            "${remainingTime.inSeconds % 60} sec",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 7.5.h, 0, 0.h),
                      child: Text(
                        '$blood Group',
                        style: TextStyle(
                            fontSize: 15.sp,
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
                                  fontSize: 15.sp,
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
                              fontSize: 15.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        userType == 'donor' || checkExistDonor == true
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
                        setState(() {
                          selectedOption = 'taker';
                        });
                        try {
                          bool? response = await createDonorSwitcher();

                          if (response == true) {
                            bool? result = await updateUserType('taker');

                            if (result == true) {
                              SystemNavigator.pop();
                            } else {
                              EasyLoading.showError(
                                  'Could not update user. Please try again.');
                            }
                          } else {
                            EasyLoading.showError(
                                'Failed to create donor switcher. Please check your details and try again.');
                          }
                        } catch (e) {
                          EasyLoading.showError(
                              'An unexpected error occurred: $e');
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 25.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: selectedOption == 'taker'
                              ? PRIMARY_COLOR
                              : Colors.white,
                        ),
                        child: Text(
                          'Taker',
                          style: TextStyle(
                            fontSize: 14,
                            color: selectedOption == 'taker'
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
                        setState(() {
                          selectedOption = 'donor';
                        });
                        try {
                          bool? result = await updateUserType('donor');

                          if (result == true) {
                            SystemNavigator.pop();
                          } else {
                            EasyLoading.showError(
                                'Could not update user. Please try again.');
                          }
                        } catch (e) {
                          EasyLoading.showError(
                              'An unexpected error occurred: $e');
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 25.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: selectedOption == 'donor'
                              ? PRIMARY_COLOR
                              : Colors.white,
                        ),
                        child: Text(
                          'Donor',
                          style: TextStyle(
                            fontSize: 14,
                            color: selectedOption == 'donor'
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
        userType == 'donor'
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
                              color: availablility == true
                                  ? PRIMARY_COLOR
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text('No',
                                  style: TextStyle(
                                      color: availablility == true
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                              color: availablility == false
                                  ? PRIMARY_COLOR
                                  : Colors
                                      .white, // Grey if condition is true, Red otherwise
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text('Yes',
                                  style: TextStyle(
                                      color: availablility == false
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
                height: 5.h,
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
                      pageBuilder: (context, animation, secondaryAnimation) {
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
                      pageBuilder: (context, animation, secondaryAnimation) {
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
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const RefferalInvitation();
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
                      pageBuilder: (context, animation, secondaryAnimation) {
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
                      pageBuilder: (context, animation, secondaryAnimation) {
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
              ),
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

        String usertype = userDoc['type'];

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

          userType = usertype;
          selectedOption = userType;
        });

        // await displayImage(image);

        // Fetch and display the image from Firebase Storage
        // await displayImage(image);
        bool? result = await DonorSwitcher();
        if (result == true) {
          setState(() {
            checkExistDonor = true;
          });
        }
        await getavailableDonor();
        await getDonorBackToDonate();
        print(fullname);
      } else {
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getavailableDonor() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print(userEmail);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('available_donor')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        bool status = userDoc['status'];

        setState(() {
          availablility = status;
        });
        print("Availability is $availablility");
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
          .collection('available_donor')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        log("My Statis is $isActive");
      }
    } catch (e) {
      print('Error updating status: $e');
    }
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

  Future<void> getDonorBackToDonate() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print('User email: $userEmail');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('available_donor')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Retrieve the `createdAt` Timestamp from Firestore
        Timestamp createdAt = userDoc['createdAt'];
        DateTime createdAtDateTime = createdAt.toDate();

        // Calculate the next eligible donation date
        nextDonationDate = createdAtDateTime.add(Duration(days: 90));

        // Start the countdown
        startCountdown();
      } else {
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void startCountdown() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          final now = DateTime.now();
          if (nextDonationDate != null && nextDonationDate!.isAfter(now)) {
            remainingTime = nextDonationDate!.difference(now);
          } else {
            remainingTime = Duration.zero; // Countdown reached zero
            timer.cancel();
          }
        });
      }
    });
  }

  Future<bool> createDonorSwitcher() async {
    try {
      showLoader('please wait ');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('user_email');

      await FirebaseFirestore.instance.collection('donor_switcher').add({
        'email': email,
        'status': true,
      });

      return true;
    } catch (error) {
      print("Error in createDonorSwitcher: $error");
      return false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<bool> updateUserType(String userTypeq) async {
    try {
      showLoader('please wait');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .update({
          'type': userTypeq,
        });
        EasyLoading.dismiss();
        return true;
      } else {
        EasyLoading.dismiss();
        log("No user found with the email: $userEmail");
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      log('Error updating userType: $e');
      return false;
    }
  }

  Future<bool> DonorSwitcher() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('user_email');

      if (email == null || email.isEmpty) {
        EasyLoading.showError('Email not found in preferences.');
        return false;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('donor_switcher')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // EasyLoading.showInfo('Email already exists in donor switcher.');
        return true;
      }

      return true;
    } catch (error) {
      EasyLoading.showError(
          'Failed to create donor switcher. Please try again.');
      return false;
    }
  }
}
