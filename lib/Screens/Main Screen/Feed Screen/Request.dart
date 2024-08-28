import 'dart:io';

import 'package:blood_donor/Modals/Taker.dart';
import 'package:blood_donor/Screens/Main%20Screen/Feed%20Screen/MapOnDonator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<Taker> feedsData = [];
  @override
  void initState() {
    super.initState();
    // getTakerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: feedsData.length, // Number of days for forecast
              itemBuilder: (context, index) {
                // ignore: unused_local_variable
                Taker taker = feedsData[index];

                return Card(
                  shadowColor: const Color.fromARGB(255, 235, 234, 235),
                  elevation: 10,
                  color: const Color.fromARGB(255, 245, 241, 241),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Set your desired border radius
                    side: const BorderSide(
                      color: Colors.black, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 2.h, 0, 0),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundImage: FileImage(
                            File(feedsData[index].imageURL),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(30.w, 2.h, 0, 0),
                          child: Text(
                            feedsData[index].name,
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF353535)),
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(30.w, 6.h, 0, 0),
                          child: Text(
                            feedsData[index].hospitaname,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 9.h, 0, 0),
                        child: Text(
                          // ignore: unnecessary_string_interpolations
                          feedsData[index].location,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.w, 12.h, 0, 0),
                            child: Text(
                              feedsData[index].time,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(2.w, 12.h, 0, 0),
                            child: Text(
                              feedsData[index].date,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(75.w, 2.5.h, 0, 0),
                        child: Text(
                          feedsData[index].blood,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDE0A1E)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 16.h, 5.w, 0),
                        child: const Divider(
                          height: 1,
                          color: Colors.black87,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(7.w, 16.h, 5.w, 0),
                          child: TextButton(
                            child: Text(
                              'Decline',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.black54),
                            ),
                            onPressed: () {},
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(50.w, 16.h, 5.w, 0),
                          child: TextButton(
                            child: Text(
                              'Donate',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: const Color(0xFFDE0A1E)),
                            ),
                            onPressed: () {
                              String id = feedsData[index].id;
                              String name = feedsData[index].name;
                              String image = feedsData[index].imageURL;
                              String blood = feedsData[index].blood;
                              String email = feedsData[index].email;
                              String location = feedsData[index].location;
                              String hosname = feedsData[index].hospitaname;
                              String rating =
                                  feedsData[index].rating.toString();

                              String time = feedsData[index].time;
                              String date = feedsData[index].date;
                              String note = feedsData[index].note;
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return MapOnDonator(
                                        id: id,
                                        name: name,
                                        image: image,
                                        email: email,
                                        blood: blood,
                                        location: location,
                                        hosname: hosname,
                                        rating: rating.toString(),
                                        time: time,
                                        date: date,
                                        note: note);
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
                          )),
                    ],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.0,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5,
                mainAxisExtent: 180,
                // Adjust aspect ratio as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Future<void> getTakerData() async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await FirebaseFirestore.instance.collection('taker').get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       feedsData = querySnapshot.docs.map((doc) {
  //         return Taker(
  //             id: doc['id'],
  //             name: doc['name'],
  //             image: doc['image'],
  //             blood: doc['blood'],
  //             location: doc['location'],
  //             hospitaname: doc['hospitalname'],
  //             rating: doc['rating'],
  //             time: doc['time'],
  //             date: doc['date'],
  //             note: doc['note']);
  //       }).toList();
  //     } else {
  //       print('No documents found in the taker collection');
  //     }
  //   } catch (e) {
  //     // Handle error
  //     print('Error: $e');
  //   }
  // }
}
