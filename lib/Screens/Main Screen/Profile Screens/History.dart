// ignore_for_file: file_names

import 'package:blood_donor/Modals/HistoryLog.dart';
import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/AccountScreen.dart';
import 'package:blood_donor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryLog> historylog = [];
  String userType = '';

  @override
  void initState() {
    getUserDataByEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Column(children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(3.w, 4.h, 0, 0),
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
                          transitionDuration: const Duration(seconds: 1),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 4.h, 0, 0),
                    child: Text(
                      'History Log',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ))
              ],
            ),
            FutureBuilder<List<HistoryLog>>(
              future: getChatRequestData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No history found'));
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0),
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          HistoryLog his = snapshot.data![index];
                          return CouponCard(
                            curveAxis: Axis.vertical,
                            firstChild: Container(
                              decoration: BoxDecoration(color: Colors.grey),
                              child: userType == 'donor'
                                  ? Image.network(
                                      fit: BoxFit.cover,
                                      '${his.takerimage}',
                                    )
                                  : userType == 'taker'
                                      ? Image.network(
                                          fit: BoxFit.cover,
                                          '${his.donorimage}',
                                        )
                                      : Image.network(
                                          fit: BoxFit.cover,
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png',
                                        ),
                            ),
                            secondChild: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                              ),
                              padding: const EdgeInsets.only(top: 0, left: 10),
                              child: Stack(
                                children: [
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        decoration: BoxDecoration(
                                          color: PRIMARY_COLOR,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(100),
                                          ),
                                        ),
                                      )),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: EdgeInsets.only(top: 20, left: 20),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          Text(
                                            his.donorname ?? his.takername!,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: EdgeInsets.only(top: 50, left: 20),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          Text(
                                            his.donoremail ?? his.takerblood!,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: PRIMARY_COLOR),
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5,
                          mainAxisExtent: 120,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ]),
        ),
      );
    });
  }

  Future<List<HistoryLog>> getChatRequestData() async {
    List<HistoryLog> historyLogData = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('user_email') ?? '';
    try {
      if (userType == 'donor') {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('history')
            .where('donoremail',
                isEqualTo: userEmail) // Filter based on donor email
            .get();
        print('nomi');

        if (querySnapshot.docs.isNotEmpty) {
          historyLogData = querySnapshot.docs.map((doc) {
            return HistoryLog(
              takername: doc['takernaem'],
              takeremail: doc['takeremail'],
              takerblood: doc['takerblood'],
              takerimage: doc['takerimage'],
            );
          }).toList();
        } else {
          print('No pending chat requests found');
        }
      } else {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('history')
            .where('takeremail',
                isEqualTo: userEmail) // Filter based on taker email
            .get();
        print('nomi');

        if (querySnapshot.docs.isNotEmpty) {
          historyLogData = querySnapshot.docs.map((doc) {
            return HistoryLog(
              donorname: doc['donorname'],
              donoremail: doc['donoremail'],
              donorblood: doc['donorblood'],
              donorimage: doc['donorimage'],
            );
          }).toList();
        } else {
          print('No pending chat requests found');
        }
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
    return historyLogData;
  }

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
        String type = userDoc['type'];

        userType = type;
        setState(() {});
      } else {
        // No user found with the specified email
        print('User not found with email: $userEmail');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
}
