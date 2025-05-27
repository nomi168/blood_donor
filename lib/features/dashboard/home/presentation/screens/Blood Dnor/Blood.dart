// import 'package:blood_donor/features/dashboard/home/presentation/controllers/blood_option_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class BloodOptionScreen extends StatelessWidget {
//   const BloodOptionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: GetBuilder<BloodOptionController>(
//           init: BloodOptionController(),
//           builder: (controller) {
//             return SingleChildScrollView(
//               child: Column(children: [
//                 if (feedsData.isEmpty)
//                   SizedBox(
//                     height: 25,
//                   ),
//                 if (feedsData.isEmpty)
//                   Center(
//                     child: Text(
//                       'No Data Found',
//                       style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 if (feedsData.isNotEmpty)
//                   Container(
//                     margin: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, 0),
//                     child: ListView.builder(
//                       physics: const ScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: feedsData.length,
//                       itemBuilder: (context, index) {
//                         Taker taker = feedsData[index];

//                         return Card(
//                           shadowColor: const Color.fromARGB(255, 235, 234, 235),
//                           elevation: 10,
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                                 10.0), // Set your desired border radius
//                             side: const BorderSide(
//                               color: Color(0xFFDE0A1E), // Border color
//                               width: 1.0, // Border width
//                             ),
//                           ),
//                           child: Stack(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(4.w, 2.h, 0, 0),
//                                 child: CircleAvatar(
//                                     radius: 36,
//                                     backgroundImage:
//                                         NetworkImage(taker.imageURL)),
//                               ),
//                               Padding(
//                                   padding: EdgeInsets.fromLTRB(30.w, 2.h, 0, 0),
//                                   child: Text(
//                                     feedsData[index].name,
//                                     style: TextStyle(
//                                         fontSize: 15.sp,
//                                         fontWeight: FontWeight.bold,
//                                         color: const Color(0xFF353535)),
//                                   )),
//                               Padding(
//                                   padding: EdgeInsets.fromLTRB(30.w, 6.h, 0, 0),
//                                   child: Text(
//                                     feedsData[index].hospitaname,
//                                     style: TextStyle(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black54),
//                                   )),
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(30.w, 12.h, 0, 0),
//                                 child: Text(
//                                   // ignore: unnecessary_string_interpolations
//                                   feedsData[index].location,
//                                   style: TextStyle(
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black54),
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Padding(
//                                     padding:
//                                         EdgeInsets.fromLTRB(30.w, 18.h, 0, 0),
//                                     child: Text(
//                                       feedsData[index].time,
//                                       style: TextStyle(
//                                           fontSize: 12.sp,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black54),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         EdgeInsets.fromLTRB(2.w, 18.h, 0, 0),
//                                     child: Text(
//                                       feedsData[index].date,
//                                       style: TextStyle(
//                                           fontSize: 12.sp,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black54),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(75.w, 2.5.h, 0, 0),
//                                 child: Text(
//                                   feedsData[index].blood,
//                                   style: TextStyle(
//                                       fontSize: 15.sp,
//                                       fontWeight: FontWeight.bold,
//                                       color: const Color(0xFFDE0A1E)),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(5.w, 21.h, 5.w, 0),
//                                 child: const Divider(
//                                   height: 1,
//                                   color: Colors.black87,
//                                   thickness: 1,
//                                 ),
//                               ),
//                               // Padding(
//                               //     padding: EdgeInsets.fromLTRB(7.w, 20.h, 5.w, 0),
//                               //     child: TextButton(
//                               //       child: Text(
//                               //         'Request',
//                               //         style: TextStyle(
//                               //             fontSize: 15.sp, color: Colors.black54),
//                               //       ),
//                               //       onPressed: () async {
//                               //         // final FirebaseAuth _auth =
//                               //         //     FirebaseAuth.instance;
//                               //         // final User? currentUser = _auth.currentUser;
//                               //         // final String? userEmail = currentUser?.email;

//                               //         // if (currentUser != null) {
//                               //         //   // Get recipient's email (for demo, you can replace this with actual recipient email)
//                               //         //   String recipientEmail =
//                               //         //       feedsData[index].email;
//                               //         //   String rename = feedsData[index].name;
//                               //         //   String recimage = feedsData[index].imageURL;
//                               //         //   String id = feedsData[index].id;
//                               //         //   receiver_id = id;

//                               //         //   if (userType == 'donor') {
//                               //         //     // Send chat request
//                               //         //     await sendChatRequest(
//                               //         //         userEmail!,
//                               //         //         recipientEmail,
//                               //         //         profilename,
//                               //         //         number,
//                               //         //         image,
//                               //         //         rename,
//                               //         //         recimage,
//                               //         //         id);
//                               //         //   } else {
//                               //         //     showCustomSnackBar(
//                               //         //         context,
//                               //         //         'Only donors can send chat requests.',
//                               //         //         false);
//                               //         //   }

//                               //         //   // Show notification or navigate to chat screen
//                               //         // }
//                               //       },
//                               //     )),
//                               Padding(
//                                   padding:
//                                       EdgeInsets.fromLTRB(5.w, 21.h, 5.w, 0),
//                                   child: Center(
//                                       child: TextButton(
//                                     child: Text(
//                                       'Donate',
//                                       style: TextStyle(
//                                           fontSize: 15.sp,
//                                           color: const Color(0xFFDE0A1E)),
//                                     ),
//                                     // style: ButtonStyle(backgroundColor:k),
//                                     onPressed: () {
//                                       EasyLoading.showInfo(
//                                         'Please go to Feeds for more information',
//                                       );
//                                       // String id = feedsData[index].id;
//                                       // String name = feedsData[index].name;
//                                       // String image = feedsData[index].imageURL;
//                                       // String blood = feedsData[index].blood;
//                                       // String location = feedsData[index].location;
//                                       // String hosname = feedsData[index].hospitaname;
//                                       // String rating =
//                                       //     feedsData[index].rating.toString();

//                                       // String time = feedsData[index].time;
//                                       // String date = feedsData[index].date;
//                                       // String note = feedsData[index].note;
//                                       // // if (userType == 'donor') {
//                                       // Navigator.of(context, rootNavigator: true).push(
//                                       //   PageRouteBuilder(
//                                       //     pageBuilder:
//                                       //         (context, animation, secondaryAnimation) {
//                                       //       return MapOnDonator(
//                                       //           id: id,
//                                       //           name: name,
//                                       //           image: image,
//                                       //           blood: blood,
//                                       //           location: location,
//                                       //           hosname: hosname,
//                                       //           rating: rating.toString(),
//                                       //           time: time,
//                                       //           date: date,
//                                       //           note: note);
//                                       //     },
//                                       //     transitionDuration:
//                                       //         const Duration(seconds: 1),
//                                       //     transitionsBuilder: (context, animation,
//                                       //         secondaryAnimation, child) {
//                                       //       const begin = Offset(
//                                       //           10.0, 0.0); // slide in from the right
//                                       //       const end = Offset.zero;
//                                       //       const curve = Curves.easeInOutQuart;

//                                       //       var tween = Tween(begin: begin, end: end)
//                                       //           .chain(CurveTween(curve: curve));
//                                       //       var offsetAnimation =
//                                       //           animation.drive(tween);

//                                       //       return SlideTransition(
//                                       //         position: offsetAnimation,
//                                       //         child: child,
//                                       //       );
//                                       //     },
//                                       //   ),
//                                       // );

//                                       //  else {
//                                       //   showCustomSnackBar(
//                                       //       context,
//                                       //       "Taker is doesnot donate any blood",
//                                       //       false);
//                                       // }
//                                     },
//                                   ))),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   )
//               ]),
//             );
//           },
//         ));
//   }
// }
