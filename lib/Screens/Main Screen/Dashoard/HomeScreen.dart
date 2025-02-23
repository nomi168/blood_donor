// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';

import 'package:blood_donor/Modals/acceptance_model.dart';
import 'package:blood_donor/Provider/FirebaseAuth.dart';
import 'package:blood_donor/Provider/Page.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Blood%20Dnor/Blood.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/DonateNow.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/Feed1.dart';
import 'package:blood_donor/Screens/Main%20Screen/Dashoard/taker_more.dart';
import 'package:blood_donor/Screens/Main%20Screen/Feed%20Screen/FeedScreen.dart';
import 'package:blood_donor/Screens/Main%20Screen/Feed%20Screen/Notification.dart';
import 'package:blood_donor/Screens/Main%20Screen/SendRequestForBood/Post%20Rquest/post_request.dart';
import 'package:blood_donor/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import 'Blood Bank/Blood_ank.dart';
import 'Emergency Donor/Emergency_Blood.dart';
import 'Post Request/PostRequest.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<String> nomi1 = [
    'A+',
    'B+',
    'O+',
    'AB+',
    'A-',
    'B-',
    'O-',
    'AB-',
  ];
  String selectedIndex1 = '';
  int _currentIndex = 0;
  String profilename = '';
  String user_id = '';
  List<AcceptanceModel> acceptList = [];
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Circle> circles = {};

  final List<String> images = [
    'images/Banners/2.jpeg',
    'images/Banners/3.jpeg',
    'images/Banners/4.jpg',
    'images/Banners/5.jpg',
    'images/Banners/banner_app.jpg'
  ];

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController hospital = TextEditingController();

  String name = '';
  String image = '';
  String blood = '';
  String email = '';
  String hospitaln = '';
  String location = '';
  String date = '';
  String time = '';
  String note = '';
  String rating = '';
  String id = '';
  String userType = '';

  String requestname = '';
  String requesthosname = '';
  String requestdate = '';
  String requesttime = '';
  String requestblood = '';
  String requestbloc = '';
  String requestnote = '';
  String requestid = '';
  String requestrating = '';
  String requestimage = '';
  String requestemail = '';
  String takerNumber = '';

  String donorname = '';

  String donoremail = '';
  String donorimage = '';
  String donorblood = '';
  String takerid = '';
  bool isLoading = true;
  NotificationServices notificationServices = NotificationServices();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  String devicetoken = '';
  bool availability = false;

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
      log("My State is $state");
      updateStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      log("My State is $state");
      updateStatus(true);
    }
  }

  getNotificationToken() async {
    String token1 = await notificationServices.getDeviceToken();
    if (token1 == devicetoken) {
    } else {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: user_id)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the document reference
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          String documentId = documentSnapshot.id;

          // Update the data in the document
          await FirebaseFirestore.instance
              .collection('users')
              .doc(documentId)
              .update({'deviceToken': token1});

          print('Data updated successfully in users table');
        } else {
          print('User not found with email:');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserDataByEmail();
    getFirstTaker();
    getData();
    Future.delayed(Duration(seconds: 3), () {
      isLoading = false;
      // Populate feedsData with actual data
    });
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);

    // notificationServices.getDeviceToken().then((value) {
    //   if (kDebugMode) {
    //     print('device token');
    //     print(value);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, oreintation, deviceType) {
      return WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5.w, 1.h, 0, 0),
                            child: Text(
                              'Hello!  $profilename',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Padding(
                        //       padding: EdgeInsets.fromLTRB(33.w, 1.h, 0, 0),
                        //       child: IconButton(
                        //         icon: Icon(
                        //           Icons.notifications_active,
                        //           size: 23.sp,
                        //         ),
                        //         onPressed: () {
                        //           // notificationServices
                        //           //     .getDeviceToken()
                        //           //     .then((value) async {
                        //           //   try {
                        //           //     var data = {
                        //           //       'to':
                        //           //           'dsnCibn2RXKTdrB_49UktA:APA91bG4o3rq38LPJEEiGU4TO_P3ELzFYNtotWit5XzUlzGMuzFHDaMSveNyU2DXYYeYZMfBjFJqr6p9OkF9Fud-l0QHahGnAFb0e2EOEMyRIJftPchgYXefyX6pG-7Zj3Vm0b79Czre',
                        //           //       'priority': 'high',
                        //           //       'notification': {
                        //           //         'title': 'Nomi',
                        //           //         'body': 'Hay please check'
                        //           //       },
                        //           //       'data': {'type:': 'msj', 'id': 'Nomi12345'}
                        //           //     };
                        //           //     print('nomi');

                        //           //     var response = await http.post(
                        //           //       Uri.parse(
                        //           //           'https://fcm.googleapis.com/fcm/send'),
                        //           //       body: jsonEncode(data),
                        //           //       headers: {
                        //           //         'Content-Type':
                        //           //             'application/json; charset=UTF-8',
                        //           //         'Authorization':
                        //           //             'key=AAAAhM4yLBU:APA91bFYi77T3adopH4ZKF6BwWAMjq0v-zrcByWIs_SukIolxTfIEXBwJLOzxF5GaYiT3xn03Y3gbQ-XWzkESGKMR1awLL3JPoc2x5dHh0uxmi-HSZ8xAHIEcQ0fF6XJ5j6KiYsyDzvU'
                        //           //       },
                        //           //     );
                        //           //     print('nomi');

                        //           //     if (response.statusCode == 200) {
                        //           //       print('Notification sent successfully');
                        //           //     } else {
                        //           //       print(
                        //           //           'Failed to send notification. Status code: ${response.statusCode}');
                        //           //       print('Response body: ${response.body}');
                        //           //     }
                        //           //   } catch (e) {
                        //           //     print('Error sending notification: $e');
                        //           //   }
                        //           // });
                        //         },
                        //       )),
                        // )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
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
                    Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
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
                          items: nomi1
                              .map((e) => DropdownMenuItem(
                                    // ignore: sort_child_properties_last
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedIndex1 = v!;
                            });
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          String blood = selectedIndex1.toString();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return MultipleBloodRequest(blood: blood);
                              },
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
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            // ignore: prefer_const_constructors
                            EdgeInsets.symmetric(
                                vertical: 13.5, horizontal: 32.w),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFFDE0A1E)),
                        ),
                        child: Text(
                          'Send Request',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CarouselSlider(
                      items: images.map((url) {
                        return Image.asset(url, fit: BoxFit.contain);
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      // carouselController: _carouselController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images.map((url) {
                        int index = images.indexOf(url);
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
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
                          userType == 'donor'
                              ? GestureDetector(
                                  onTap: () {
                                    // ignore: avoid_print
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return FeedScreen(
                                            id: '12345',
                                          );
                                        },
                                        transitionDuration:
                                            const Duration(seconds: 1),
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
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            )),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                3.w, 0.h, 2.w, 0),
                                            child: Text(
                                              'Blood',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            )),
                                      ],
                                    ),
                                  ))
                              : GestureDetector(
                                  onTap: () {
                                    if (userType == 'donor') {
                                      EasyLoading.showInfo(
                                          'Donor cannot add the Blood Post');
                                    } else {
                                      // ignore: avoid_print
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return const PostRequest();
                                          },
                                          transitionDuration:
                                              const Duration(seconds: 1),
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
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            )),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                3.w, 0.h, 2.w, 0),
                                            child: Text(
                                              'Request',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            )),
                                      ],
                                    ),
                                  )),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return const Blood_B();
                                    },
                                    transitionDuration:
                                        const Duration(seconds: 1),
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
                              child: Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return const Emerency_Blood();
                                    },
                                    transitionDuration:
                                        const Duration(seconds: 1),
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
                              child: Container(
                                height: 120,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
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
                                          'Donors',
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

                    SizedBox(
                      height: 15,
                    ),

                    if (userType.isNotEmpty && userType == 'taker')
                      Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(3.w, 1.h, 0, 0.h),
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
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(2.w, 1.h, 0, 0.h),
                                      child: Consumer<MyPageProvider>(
                                        builder: (context, value, child) {
                                          return Text(
                                            value.location.toString(),
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          );
                                        },
                                      )),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                                                BorderRadius.circular(10),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        String blood = 'O';
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return BloodDonor(blood: blood);
                                            },
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(5.0,
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
                                                BorderRadius.circular(10),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        String blood = 'AB';
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return BloodDonor(blood: blood);
                                            },
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(5.0,
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
                                                BorderRadius.circular(10),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        String blood = 'B';
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return BloodDonor(blood: blood);
                                            },
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(5.0,
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
                                      },
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        String blood = 'A-';
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return BloodDonor(
                                                blood: blood,
                                              );
                                            },
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(5.0,
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
                                      },
                                      child: Container(
                                        height: 65,
                                        width: 25.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.black26),
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          )),
                    userType == 'donor'
                        ? Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Donation Request',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              TextButton(
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          )
                        : SizedBox(),
                    userType == 'taker'
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'See Donor Acceptanace',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    userType == 'taker'
                        ? acceptList.isEmpty
                            ? Center(
                                child: Text(
                                  'no data found',
                                  style: TextStyle(fontSize: 14),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                itemCount: acceptList.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  AcceptanceModel list = acceptList[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(05),
                                        border:
                                            Border.all(color: Colors.black26)),
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
                                                      BorderRadius.circular(40),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: list.acceptImage!
                                                            .isNotEmpty
                                                        ? list.acceptImage!
                                                        : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        const CupertinoActivityIndicator(
                                                      color: Colors.white,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
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
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          list.acceptName!,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10.w),
                                                          child: CustomPaint(
                                                            size: Size(40, 30),
                                                            painter:
                                                                BloodDropPainter(
                                                                    blood: list
                                                                        .blood!),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
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
                                                                        FontWeight
                                                                            .w500,
                                                                    height:
                                                                        0.13,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Expanded(
                                                                  child:
                                                                      SizedBox(
                                                                    child: Text(
                                                                      list.hospital!,
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
                                                                        FontWeight
                                                                            .w500,
                                                                    height:
                                                                        0.13,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  list.location!,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF5A5A5A),
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                                        FontWeight
                                                                            .w500,
                                                                    height:
                                                                        0.13,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  list.date1!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF5A5A5A),
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                                        FontWeight
                                                                            .w500,
                                                                    height:
                                                                        0.13,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  list.time1!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF5A5A5A),
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                    const SizedBox(height: 15),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context,
                                                                  animation,
                                                                  secondaryAnimation) {
                                                                return TakerMoreInfo(
                                                                  acceptModel:
                                                                      list,
                                                                );
                                                              },
                                                              transitionDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                              transitionsBuilder:
                                                                  (context,
                                                                      animation,
                                                                      secondaryAnimation,
                                                                      child) {
                                                                const begin =
                                                                    Offset(10.0,
                                                                        0.0); // slide in from the right
                                                                const end =
                                                                    Offset.zero;
                                                                const curve = Curves
                                                                    .easeInOutQuart;

                                                                var tween = Tween(
                                                                        begin:
                                                                            begin,
                                                                        end:
                                                                            end)
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
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                              color: Colors.red,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'see more',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87),
                                                          ),
                                                        ),
                                                      ),
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
                                })
                        : SizedBox(),

                    // GestureDetector(
                    //   child: Padding(
                    //     padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0),
                    //     child: Material(
                    //       elevation: 5,
                    //       shadowColor: Colors.grey,
                    //       borderRadius: BorderRadius.circular(12),
                    //       child: Container(
                    //           height: 25.h,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(12),
                    //             border: Border.all(
                    //               color: const Color(0xFFDE0A1E),
                    //               width: 1,
                    //             ),
                    //           ),
                    //           child: Stack(
                    //             children: [
                    //               Padding(
                    //                 padding: EdgeInsets.fromLTRB(
                    //                     0.w, 0.h, 64.w, 10.h),
                    //                 child: Center(
                    //                   child: CircleAvatar(
                    //                     radius: 33,
                    //                     backgroundImage: image != 'null' &&
                    //                             image.isNotEmpty
                    //                         ? NetworkImage(image)
                    //                         : NetworkImage(
                    //                             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnj2TWYskM8Or0ykoHKfKbf8YulsCWgTptlp1XdTjexw&s'),
                    //                     // Fit the image within the CircleAvatar
                    //                     backgroundColor: Colors.black54,
                    //                     foregroundColor: Colors.transparent,

                    //                     // Set the BoxFit to cover the entire CircleAvatar
                    //                   ),
                    //                 ),
                    //               ),
                    //               Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsets.fromLTRB(
                    //                         25.w, 1.5.h, 0, 0),
                    //                     child: Text(
                    //                       name,
                    //                       style: TextStyle(
                    //                           fontSize: 13.sp,
                    //                           fontWeight: FontWeight.bold),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.fromLTRB(
                    //                         25.w, 1.h, 0, 0),
                    //                     child: Text(
                    //                       hospitaln,
                    //                       style: TextStyle(
                    //                           fontSize: 12.sp,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: Colors.black54),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.fromLTRB(
                    //                         25.w, 1.h, 3.w, 0),
                    //                     child: Text(
                    //                       location,
                    //                       style: TextStyle(
                    //                           fontSize: 12.sp,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: Colors.black54),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Padding(
                    //                 padding:
                    //                     EdgeInsets.fromLTRB(65.w, 1.h, 0, 12.h),
                    //                 child: const Icon(
                    //                   Icons.bloodtype_outlined,
                    //                   color: Colors.red,
                    //                   size: 30,
                    //                 ),
                    //               ),
                    //               Padding(
                    //                   padding: EdgeInsets.fromLTRB(
                    //                       75.w, 1.5.h, 0, 12.h),
                    //                   child: Text(
                    //                     blood,
                    //                     style: TextStyle(
                    //                         fontSize: 15.sp,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.black45),
                    //                   )),
                    //               Padding(
                    //                   padding: EdgeInsets.fromLTRB(
                    //                       25.w, 15.h, 0, 0.h),
                    //                   child: Text(
                    //                     'Time: $time, $date',
                    //                     style: TextStyle(
                    //                         fontSize: 11.sp,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.black45),
                    //                   )),
                    //               Padding(
                    //                 padding:
                    //                     EdgeInsets.fromLTRB(5.w, 17.h, 5.w, 0),
                    //                 // ignore: prefer_const_constructors
                    //                 child: Divider(
                    //                   color: Colors.black26,
                    //                   thickness: 2,
                    //                   height: 5,
                    //                 ),
                    //               ),
                    //               Row(
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsets.fromLTRB(
                    //                         10.w, 18.h, 0, 1.h),
                    //                     child: TextButton(
                    //                       // ignore: prefer_const_constructors
                    //                       child: Text(
                    //                         'Decline',
                    //                         style: TextStyle(
                    //                             fontSize: 14.sp,
                    //                             fontWeight: FontWeight.bold,
                    //                             color: Colors.black45),
                    //                       ),
                    //                       onPressed: () {},
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.fromLTRB(
                    //                         9.w, 18.h, 0.w, 9.8),
                    //                     // ignore: prefer_const_constructors
                    //                     child: VerticalDivider(
                    //                       color: Colors.black54,
                    //                       thickness: 2,
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: EdgeInsets.fromLTRB(
                    //                         5.w, 18.h, 0, 1.h),
                    //                     child: TextButton(
                    //                       // ignore: prefer_const_constructors
                    //                       child: Text(
                    //                         'Donate Now',
                    //                         style: TextStyle(
                    //                             fontSize: 14.sp,
                    //                             fontWeight: FontWeight.bold,
                    //                             color: const Color(0xFFDE0A1E)),
                    //                       ),
                    //                       onPressed: () {
                    //                         if (userType == 'donor') {
                    //                           Navigator.push(
                    //                             context,
                    //                             PageRouteBuilder(
                    //                               pageBuilder: (context,
                    //                                   animation,
                    //                                   secondaryAnimation) {
                    //                                 return DonateNow(
                    //                                     name: name,
                    //                                     image: image,
                    //                                     blood: blood,
                    //                                     email: email,
                    //                                     hospital: hospitaln,
                    //                                     location: location,
                    //                                     date: date,
                    //                                     time: time,
                    //                                     rating: rating,
                    //                                     note: note,
                    //                                     id: id);
                    //                               },
                    //                               transitionDuration:
                    //                                   const Duration(
                    //                                       seconds: 1),
                    //                               transitionsBuilder: (context,
                    //                                   animation,
                    //                                   secondaryAnimation,
                    //                                   child) {
                    //                                 const begin = Offset(10.0,
                    //                                     0.0); // slide in from the right
                    //                                 const end = Offset.zero;
                    //                                 const curve =
                    //                                     Curves.easeInOutQuart;

                    //                                 var tween = Tween(
                    //                                         begin: begin,
                    //                                         end: end)
                    //                                     .chain(CurveTween(
                    //                                         curve: curve));
                    //                                 var offsetAnimation =
                    //                                     animation.drive(tween);

                    //                                 return SlideTransition(
                    //                                   position: offsetAnimation,
                    //                                   child: child,
                    //                                 );
                    //                               },
                    //                             ),
                    //                           );
                    //                         } else {
                    //                           EasyLoading.showError(
                    //                               'Taker is doesnot to donate any blood');
                    //                         }
                    //                       },
                    //                     ),
                    //                   )
                    //                 ],
                    //               )
                    //             ],
                    //           )),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     // ignore: avoid_print
                    //     print('Nomi1');
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),

                    if (isLoading)
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 168,
                          margin: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5.w),
                          decoration: ShapeDecoration(
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    if (isLoading == false && userType == 'donor')
                      Container(
                        margin: EdgeInsets.fromLTRB(0.w, 0.w, 0.w, 0),
                        child: Column(
                          children: [
                            Container(
                              height: 168,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 12),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2, color: Color(0xFFDDDDDD)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                BorderRadius.circular(40),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: image.isNotEmpty
                                                  ? image
                                                  : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
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
                                        const SizedBox(width: 5),
                                        Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  name.isNotEmpty
                                                      ? Text(
                                                          name,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 0,
                                                          ),
                                                        )
                                                      : Text(
                                                          "N/A",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 0,
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15.w),
                                                    child: CustomPaint(
                                                      size: Size(40, 30),
                                                      painter: BloodDropPainter(
                                                          blood: blood),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 220,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Hospital :',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF5A5A5A),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0.13,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            child: SizedBox(
                                                              child: Text(
                                                                hospitaln,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF5A5A5A),
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 0.13,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Container(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Location :',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF5A5A5A),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0.13,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            location,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF5A5A5A),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0.13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Container(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Date :',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF5A5A5A),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0.13,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            date,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF5A5A5A),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0.13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Container(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Time :',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF5A5A5A),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0.13,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            time,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF5A5A5A),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0.13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  // InkWell(
                                                  //   onTap: () {},
                                                  //   child: Container(
                                                  //     height: 30,
                                                  //     width: 90,
                                                  //     alignment:
                                                  //         Alignment.center,
                                                  //     decoration: BoxDecoration(
                                                  //       color: PRIMARY_COLOR,
                                                  //       borderRadius:
                                                  //           BorderRadius
                                                  //               .circular(5),
                                                  //       border: Border.all(
                                                  //         color: Colors.red,
                                                  //         width: 1.0,
                                                  //       ),
                                                  //     ),
                                                  //     child: Text(
                                                  //       'Decline',
                                                  //       style: TextStyle(
                                                  //           fontSize: 14,
                                                  //           color:
                                                  //               Colors.white),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  SizedBox(
                                                    width: 25.w,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (userType ==
                                                            'donor') {
                                                          if (availability ==
                                                              true) {
                                                            EasyLoading
                                                                .showError(
                                                              "You have already donated blood. If you want to donate again, please wait for 90 days.",
                                                            );
                                                          } else {
                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (context,
                                                                    animation,
                                                                    secondaryAnimation) {
                                                                  return DonateNow(
                                                                    name: name,
                                                                    image:
                                                                        image,
                                                                    blood:
                                                                        blood,
                                                                    email:
                                                                        email,
                                                                    hospital:
                                                                        hospitaln,
                                                                    location:
                                                                        location,
                                                                    date: date,
                                                                    time: time,
                                                                    rating:
                                                                        rating,
                                                                    note: note,
                                                                    id: id,
                                                                    takerNumber:
                                                                        takerNumber,
                                                                  );
                                                                },
                                                                transitionDuration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                transitionsBuilder:
                                                                    (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                  const begin =
                                                                      Offset(
                                                                          10.0,
                                                                          0.0); // slide in from the right
                                                                  const end =
                                                                      Offset
                                                                          .zero;
                                                                  const curve =
                                                                      Curves
                                                                          .easeInOutQuart;

                                                                  var tween = Tween(
                                                                          begin:
                                                                              begin,
                                                                          end:
                                                                              end)
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
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          EasyLoading.showError(
                                                              'Taker is doesnot to donate any blood');
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                            color: Colors.red,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'Donate Now',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black87),
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
                            ),
                          ],
                        ),
                      ),

                    SizedBox(
                      height: 10,
                    ),
                    if (requestbloc.isEmpty) SizedBox(),
                    if (requestbloc.isNotEmpty)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text('Blood Journey Map',
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF3F3F3).withOpacity(0.2),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: requestimage.isNotEmpty
                                              ? requestimage
                                              : "https://www.lscthub.co.uk/wp-content/themes/u-design/assets/images/placeholders/event-placeholder.jpg",
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      child: Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              requestname,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Location : ',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    requestbloc,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.7)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Hospital Name : ',
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    requesthosname,
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.7)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Blood Group : ',
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    requestblood,
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.7)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date : ',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    requestdate,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.7)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Time : ',
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    requesttime,
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.7)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return Feed1(
                                                  name: requestname,
                                                  image: requestimage,
                                                  blood: requestblood,
                                                  email: requestemail,
                                                  hospital: requesthosname,
                                                  location: requestbloc,
                                                  date: requestdate,
                                                  time: requesttime,
                                                  rating: requestrating,
                                                  note: requestnote,
                                                  id: requestid,
                                                  donorname: donorname,
                                                  donorblood: donorblood,
                                                  donoremail: donoremail,
                                                  donorimage: donorimage,
                                                  takerid: takerid);
                                            },
                                            transitionDuration:
                                                const Duration(seconds: 1),
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
                                      },
                                      child: Container(
                                        height: 38,
                                        width: 220,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: PRIMARY_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Text(
                                          'Donate',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white),
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
                    SizedBox(
                      height: 13.h,
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Are you sure you want to exit the application?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     final GoogleMapController controller = await _controller.future;

  //     setState(() {
  //       circles.clear();
  //       circles.add(Circle(
  //         circleId: const CircleId('CurrentLocationCircle'),
  //         center: LatLng(position.latitude, position.longitude),
  //         radius: 120.0,
  //         fillColor: Colors.blue.withOpacity(0.3),
  //         strokeColor: Colors.blue,
  //         strokeWidth: 10,
  //       ));

  //       controller.animateCamera(
  //         CameraUpdate.newLatLngZoom(
  //           LatLng(position.latitude, position.longitude),
  //           9.6,
  //         ),
  //       );

  //       fromController.text =
  //           "${position.latitude.toString()}, ${position.longitude.toString()}";
  //     });
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("Error: $e");
  //   }
  // }

  // // ignore: unused_element
  // Future<void> _goToCurrentLocation() async {
  //   _getCurrentLocation();
  // }

  // Future<void> showPath() async {
  //   try {
  //     String from = fromController.text;
  //     String to = toController.text;

  //     List<Location> fromLocations = await locationFromAddress(from);
  //     List<Location> toLocations = await locationFromAddress(to);

  //     if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
  //       Location fromLocation = fromLocations.first;

  //       // Let the user choose the correct "To" location from multiple results
  //       Location? toLocation = await _chooseLocation(toLocations);

  //       if (toLocation != null) {
  //         // ignore: unused_local_variable
  //         final GoogleMapController controller = await _controller.future;
  //         if (!_controller.isCompleted) {
  //           _controller.complete(controller);
  //         }

  //         LatLng fromLatLng =
  //             LatLng(fromLocation.latitude, fromLocation.longitude);
  //         LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

  //         // ignore: unused_local_variable
  //         LatLngBounds bounds = LatLngBounds(
  //           southwest: fromLatLng,
  //           northeast: toLatLng,
  //         );

  //         // Comment out the line below to prevent the camera from moving
  //         // controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));

  //         // ignore: unused_local_variable
  //         Polyline polyline = Polyline(
  //           polylineId: const PolylineId('Path'),
  //           color: Colors.red,
  //           points: [fromLatLng, toLatLng],
  //         );

  //         setState(() {
  //           circles.clear();
  //           circles.add(Circle(
  //             circleId: const CircleId('CurrentLocationCircle'),
  //             center: fromLatLng,
  //             radius: 120.0,
  //             fillColor: Colors.blue.withOpacity(0.3),
  //             strokeColor: Colors.blue,
  //             strokeWidth: 10,
  //           ));
  //           circles.add(Circle(
  //             circleId: const CircleId('DestinationCircle'),
  //             center: toLatLng,
  //             radius: 120.0,
  //             fillColor: Colors.green.withOpacity(0.3),
  //             strokeColor: Colors.green,
  //             strokeWidth: 10,
  //           ));
  //           polygons.clear();
  //           polygons.add(Polygon(
  //             polygonId: const PolygonId('PathPolygon'),
  //             points: [fromLatLng, toLatLng],
  //             fillColor: const Color(0xFFDE0A1E).withOpacity(0.5),
  //             strokeWidth: 2,
  //             strokeColor: const Color(0xFFDE0A1E),
  //           ));
  //         });

  //         // ignore: await_only_futures
  //         double distance = await Geolocator.distanceBetween(
  //           fromLocation.latitude,
  //           fromLocation.longitude,
  //           toLocation.latitude,
  //           toLocation.longitude,
  //         );

  //         double distanceInKm = distance / 1000;

  //         // ignore: use_build_context_synchronously
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("Error: $e");
  //   }
  // }

  // Future<Location?> _chooseLocation(List<Location> locations) async {
  //   // You can implement a UI to let the user choose the correct location
  //   // For simplicity, here we choose the first location from the list
  //   return locations.first;
  // }

  // String getRemainingTime(DateTime donationDate) {
  //   DateTime now = DateTime.now();
  //   Duration difference = now.difference(donationDate);

  //   int hours = difference.inHours;
  //   int minutes = difference.inMinutes.remainder(60);

  //   if (hours >= 1) {
  //     // If the difference is 1 hour or more, display in hours format.
  //     double remainingTime = hours + (minutes / 60);
  //     return '$remainingTime hours';
  //   } else {
  //     // If less than 1 hour, display in minutes format.
  //     return '$minutes minutes';
  //   }
  // }

  // void sendNotificationToAllUsers() async {
  //   try {
  //     // Fetch all users from Firestore
  //     QuerySnapshot usersSnapshot = await usersCollection.get();

  //     // Iterate over each user document
  //     for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
  //       // Get the device token from the user document
  //       String deviceToken = userDoc['deviceToken'];

  //       // Prepare notification data
  //       var data = {
  //         'to': deviceToken,
  //         'priority': 'high',
  //         'notification': {'title': 'Nomi', 'body': 'Hay please check'},
  //         'data': {
  //           'type': 'msj',
  //           'id': 'Nomi12345'
  //         } // Additional data if needed
  //       };

  //       // Send notification to the device
  //       var response = await http.post(
  //         Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         body: jsonEncode(data),
  //         headers: {
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'Authorization':
  //               'key=AAAAhM4yLBU:APA91bFYi77T3adopH4ZKF6BwWAMjq0v-zrcByWIs_SukIolxTfIEXBwJLOzxF5GaYiT3xn03Y3gbQ-XWzkESGKMR1awLL3JPoc2x5dHh0uxmi-HSZ8xAHIEcQ0fF6XJ5j6KiYsyDzvU'
  //         },
  //       );

  //       // Check response status
  //       if (response.statusCode == 200) {
  //         print('Notification sent successfully to user: ${userDoc.id}');
  //       } else {
  //         print(
  //             'Failed to send notification to user: ${userDoc.id}. Status code: ${response.statusCode}');
  //         print('Response body: ${response.body}');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error sending notification: $e');
  //   }
  // }

  Future<void> getUserDataByEmail() async {
    try {
      // Use the 'where' method to query documents with the specified email
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Access user data
        String name = userDoc['firstname'];
        String name1 = userDoc['lastname'];
        String type = userDoc['type'];
        String id = userDoc['id'];
        String devicet = userDoc['deviceToken'];
        profilename = name + ' $name1';
        userType = type;
        user_id = id;
        devicetoken = devicet;
        setState(() {});
        print(profilename);
        _goToCurrentLocation();
        await getNotificationToken();
        await checkAvailabilityDonor();
      } else {
        // No user found with the specified email
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> getFirstTaker() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('taker')
          .where('status', isEqualTo: false)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Clear previous state or initialize variables
        // List<Map<String, dynamic>> allDonations = [];

        // Extract data from the first document
        DocumentSnapshot firstDoc = querySnapshot.docs.first;
        String pic = firstDoc['image'];
        String name1 = firstDoc['name'];
        String blood1 = firstDoc['blood'];
        String hospital = firstDoc['hospitalname'];
        String location1 = firstDoc['location'];
        String date1 = firstDoc['date'];
        String time1 = firstDoc['time'];
        String note1 = firstDoc['note'];
        String rating1 = firstDoc['rating'];
        String tid = firstDoc['taker_id'];
        String email1 = firstDoc['email'];
        String takerNumber1 = firstDoc['number'];

        image = pic;
        name = name1;
        blood = blood1;
        hospitaln = hospital;
        location = location1;
        date = date1;
        time = time1;
        note = note1;
        rating = rating1;
        id = tid;
        email = email1;
        takerNumber = takerNumber1;
        setState(() {});
        // Add data to a list of maps
        // allDonations.add({
        //   'acceptName': acceptName,
        //   'acceptPic': acceptPic,
        //   'acceptRating': acceptRating,
        //   'acceptBlood': acceptBlood,
        // });

        // Now you can use the list of maps 'allDonations' to display or manipulate the data as needed
      } else {
        print('No donations found in the "taker" collection.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateDonorLocation(String location) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('donor_location')
          .where('user_id', isEqualTo: user_id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the data in the document
        await FirebaseFirestore.instance
            .collection('donor_location')
            .doc(documentId)
            .update({'donor_location': location});

        print('Data updated successfully in donor Location table');
      } else {
        print('User not found with email:');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      String address =
          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      updateDonorLocation(address);

      final GoogleMapController controller = await _controller.future;

      setState(() {
        circles.clear();
        circles.add(Circle(
          circleId: const CircleId('CurrentLocationCircle'),
          center: LatLng(position.latitude, position.longitude),
          radius: 120.0,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 10,
        ));

        controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            9.6,
          ),
        );

        fromController.text = address;

        log("My location is ${fromController.text}");
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _goToCurrentLocation() async {
    if (userType == 'donor') {
      _getCurrentLocation();
    } else {
      print("Taker is login");
    }
  }

  // Future<void> showPath(String location) async {
  //   try {
  //     final provider = Provider.of<AuthProvider>(context, listen: false);
  //     String from = fromController.text;
  //     String to = location;
  //     log("My location is $requestbloc");

  //     List<Location> fromLocations = await locationFromAddress(from);
  //     List<Location> toLocations = await locationFromAddress(to);

  //     if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
  //       Location fromLocation = fromLocations.first;

  //       // Let the user choose the correct "To" location from multiple results
  //       Location? toLocation = await _chooseLocation(toLocations);

  //       if (toLocation != null) {
  //         // ignore: unused_local_variable
  //         final GoogleMapController controller = await _controller.future;

  //         LatLng fromLatLng =
  //             LatLng(fromLocation.latitude, fromLocation.longitude);
  //         LatLng toLatLng = LatLng(toLocation.latitude, toLocation.longitude);

  //         // ignore: unused_local_variable
  //         LatLngBounds bounds = LatLngBounds(
  //           southwest: fromLatLng,
  //           northeast: toLatLng,
  //         );

  //         // Comment out the line below to prevent the camera from moving
  //         // controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));

  //         // ignore: unused_local_variable
  //         Polyline polyline = Polyline(
  //           polylineId: const PolylineId('Path'),
  //           color: Colors.red,
  //           points: [fromLatLng, toLatLng],
  //         );

  //         setState(() {
  //           circles.clear();
  //           circles.add(Circle(
  //             circleId: const CircleId('CurrentLocationCircle'),
  //             center: fromLatLng,
  //             radius: 120.0,
  //             fillColor: Colors.blue.withOpacity(0.3),
  //             strokeColor: Colors.blue,
  //             strokeWidth: 10,
  //           ));
  //           circles.add(Circle(
  //             circleId: const CircleId('DestinationCircle'),
  //             center: toLatLng,
  //             radius: 120.0,
  //             fillColor: Colors.green.withOpacity(0.3),
  //             strokeColor: Colors.green,
  //             strokeWidth: 10,
  //           ));
  //           polygons.clear();
  //           polygons.add(Polygon(
  //             polygonId: const PolygonId('PathPolygon'),
  //             points: [fromLatLng, toLatLng],
  //             fillColor: const Color(0xFFDE0A1E).withOpacity(0.5),
  //             strokeWidth: 2,
  //             strokeColor: const Color(0xFFDE0A1E),
  //           ));
  //         });

  //         double distance = await Geolocator.distanceBetween(
  //           fromLocation.latitude,
  //           fromLocation.longitude,
  //           toLocation.latitude,
  //           toLocation.longitude,
  //         );

  //         double distanceInKm = distance / 1000;
  //         provider.notifyListeners();

  //         // ignore: use_build_context_synchronously
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Distance: ${distanceInKm.toStringAsFixed(2)} km'),
  //           ),
  //         );
  //         setState(() {});
  //       }
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  // Future<Location?> _chooseLocation(List<Location> locations) async {
  //   // You can implement a UI to let the user choose the correct location
  //   // For simplicity, here we choose the first location from the list
  //   return locations.first;
  // }

  Future<void> getAcceptDonor() async {
    try {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      // Use the 'where' method to query documents with the specified email
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('acceptemail', isEqualTo: userEmail)
          .where('status', isEqualTo: false)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Access user data

        String name = userDoc['fullname'];
        String hospital = userDoc['hospitalname'];
        String blood = userDoc['blood'];
        String date = userDoc['date'];
        String time = userDoc['time'];
        String loc = userDoc['location'];
        String rsting = userDoc['rating'];
        int idd = userDoc['id'];
        String note = userDoc['note'];
        String image = userDoc['image'];
        String emai = userDoc['email'];
        String d_name = userDoc['acceptname'];
        String d_email = userDoc['acceptemail'];
        String d_image = userDoc['acceptimage'];
        String d_blood = userDoc['acceptblood'];
        // String d_rating = userDoc['acceptrating'];
        // String d_number = userDoc['acceptnumber'];
        String takid = userDoc['takerid'];
        String date1 = userDoc['date1'];
        String time1 = userDoc['time1'];
        bool status = userDoc['status'];

        requestname = name;
        requesthosname = hospital;
        requestblood = blood;
        requestdate = date;
        requesttime = time;
        requestbloc = loc;
        requestrating = rsting;
        requestid = idd.toString();
        requestnote = note;
        requestimage = image;
        requestemail = emai;
        donorname = d_name;
        donoremail = d_email;
        donorblood = d_blood;
        donorimage = d_image;
        takerid = takid;
      } else {
        // No user found with the specified email
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  getData() async {
    await getAcceptDonor();
    Future.delayed(Duration(seconds: 2), () async {
      // showPath(requestbloc);
    });
    await updateStatus(true);
    if (userType == 'taker') {
      await getAcceptance();
    }
  }

//  Future<void> getAcceptDonation() async {
//   try {

//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('taker')
//         .where('taker_email', isEqualTo: userEmail)
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       // Clear previous state
//       setState(() {
//         name = '';
//         image = '';
//         rating = '';
//         blood = '';
//       });

//       // Iterate over each document in the query snapshot
//       querySnapshot.docs.forEach((DocumentSnapshot userDoc) {
//         String acceptName = userDoc['acceptname'];
//         String acceptPic = userDoc['acceptimage'];
//         String acceptRating = userDoc['acceptrating'];
//         String acceptBlood = userDoc['acceptblood'];

//         // Update state for each document
//         setState(() {
//           name = acceptName;
//           image = acceptPic;
//           rating = acceptRating;
//           blood = acceptBlood;
//         });
//       });
//     } else {
//       print('User not found with email: $userEmail');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

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

  Future<void> checkAvailabilityDonor() async {
    final firestore = FirebaseFirestore.instance;

    // Calculate the timestamp for 90 days ago
    DateTime ninetyDaysAgo = DateTime.now().subtract(Duration(days: 90));
    Timestamp ninetyDaysAgoTimestamp = Timestamp.fromDate(ninetyDaysAgo);

    // Get all donors added more than 90 days ago
    QuerySnapshot querySnapshot = await firestore
        .collection('available_donor')
        .where('createdAt', isLessThanOrEqualTo: ninetyDaysAgoTimestamp)
        .get();

    // Update the status of each expired document to 'false'
    for (var doc in querySnapshot.docs) {
      await firestore.collection('available_donor').doc(doc.id).update({
        'status': false,
      });
    }

    // Optionally, call the function again to check periodically
    await checkAvailabilityDonor();
  }

  // Future<void> checkAvailabilityDonor() async {
  //   final firestore = FirebaseFirestore.instance;

  //   // Calculate the timestamp for 2 minutes ago
  //   DateTime twoMinutesAgo = DateTime.now().subtract(Duration(minutes: 2));
  //   Timestamp twoMinutesAgoTimestamp = Timestamp.fromDate(twoMinutesAgo);

  //   // Get all donors added more than 2 minutes ago
  //   QuerySnapshot querySnapshot = await firestore
  //       .collection('available_donor')
  //       .where('createdAt', isLessThanOrEqualTo: twoMinutesAgoTimestamp)
  //       .get();

  //   // Update the status of each expired document to 'false'
  //   for (var doc in querySnapshot.docs) {
  //     await firestore.collection('available_donor').doc(doc.id).update({
  //       'status': false,
  //     });
  //   }
  //   await checkAvailabilityDonor();
  // }

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
          availability = status;
        });
      } else {
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getAcceptance() async {
    try {
      acceptList.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user_email') ?? '';
      print(userEmail);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptdonation')
          .where('email', isEqualTo: userEmail)
          .where('status', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var element in querySnapshot.docs) {
          var data = element.data() as Map<String, dynamic>;
          acceptList.add(AcceptanceModel.fromMap(data));
        }
        setState(() {});
      } else {
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      print('Error: $e');
    }
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
