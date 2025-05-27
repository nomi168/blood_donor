// // ignore_for_file: file_names

// import 'package:blood_donor/Json%20Data/Emergencylist.dart';
// import 'package:blood_donor/features/dashboard/home/presentation/screens/Emergency%20Donor/EmergencyMap.dart';
// import 'package:blood_donor/features/dashboard/home/presentation/screens/Emergency%20Donor/SubcriptionPlan.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class EmergencyDonor extends StatefulWidget {
//   const EmergencyDonor({super.key});

//   @override
//   State<EmergencyDonor> createState() => _EmergencyDonorState();
// }

// class _EmergencyDonorState extends State<EmergencyDonor> {
//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, oreientation, deviceType) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           body: Column(children: [
//             Row(
//               children: [
//                 Padding(
//                     padding: EdgeInsets.fromLTRB(2.w, 5.h, 0, 0),
//                     child: IconButton(
//                       icon: const Icon(
//                         Icons.arrow_back_ios_new,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         Navigator.pop(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder:
//                                   (context, animation, secondaryAnimation) {
//                                 return const SubscriptionPlan();
//                               },
//                               transitionDuration: const Duration(seconds: 2),
//                               transitionsBuilder: (context, animation,
//                                   secondaryAnimation, child) {
//                                 const begin = Offset(
//                                     -10.0, 0.0); // slide in from the left
//                                 const end = Offset.zero;
//                                 const curve = Curves.easeInOutQuart;

//                                 var tween = Tween(begin: begin, end: end)
//                                     .chain(CurveTween(curve: curve));
//                                 var offsetAnimation = animation.drive(tween);

//                                 return SlideTransition(
//                                   position: offsetAnimation,
//                                   child: child,
//                                 );
//                               },
//                             ));
//                       },
//                     )),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(15.w, 5.h, 0, 0),
//                   child: Text(
//                     'Emergency Donor',
//                     style: TextStyle(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black54),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
//               child: Material(
//                 elevation: 7.0, // Add shadow/elevation
//                 borderRadius: BorderRadius.circular(10.0), // Add border radius
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     label: const Text('Search'),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16.0), // Adjust padding
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide:
//                           const BorderSide(color: Colors.grey), // Border color
//                     ),
//                     suffixIcon: const Icon(
//                       Icons.keyboard_option_key,
//                       color: Color(0xFFDE0A1E),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: const BorderSide(
//                           color: Colors.blue), // Border color when focused
//                     ),
//                     hintText: 'Search a emergency donor',
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(0.w, 2.h, 61.w, 0),
//               child: Text(
//                 'Suggestions',
//                 style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black54),
//               ),
//             ),
//             Expanded(
//                 child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 1.h),
//                 child: GridView.builder(
//                   scrollDirection: Axis.vertical,
//                   physics: const ScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount:
//                       Emergencydonor.length, // Number of days for forecast
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       child: Card(
//                         shadowColor: const Color.fromARGB(255, 235, 234, 235),
//                         elevation: 10,
//                         color: const Color.fromARGB(243, 242, 242, 242),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                               10.0), // Set your desired border radius
//                           side: const BorderSide(
//                             color: Colors.black, // Border color
//                             width: 1.0, // Border width
//                           ),
//                         ),
//                         child: Stack(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(4.w, 2.h, 0, 0),
//                               child: CircleAvatar(
//                                 radius: 36,
//                                 backgroundImage: NetworkImage(
//                                   Emergencydonor[index]['image'],
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                                 padding: EdgeInsets.fromLTRB(30.w, 2.h, 0, 0),
//                                 child: Text(
//                                   Emergencydonor[index]['name'],
//                                   style: TextStyle(
//                                       fontSize: 15.sp,
//                                       fontWeight: FontWeight.bold,
//                                       color: const Color(0xFF353535)),
//                                 )),
//                             Padding(
//                                 padding: EdgeInsets.fromLTRB(30.w, 6.h, 0, 0),
//                                 child: Text(
//                                   Emergencydonor[index]['distance'],
//                                   style: TextStyle(
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black54),
//                                 )),
//                             Row(
//                               children: [
//                                 Padding(
//                                     padding:
//                                         EdgeInsets.fromLTRB(28.w, 9.h, 0, 0),
//                                     child: const Icon(
//                                       Icons.star_purple500,
//                                       color: Color(0xFFDE0A1E),
//                                     )),
//                                 Padding(
//                                   padding: EdgeInsets.fromLTRB(2.w, 9.h, 0, 0),
//                                   child: Text(
//                                     Emergencydonor[index]['rating'],
//                                     style: TextStyle(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.bold,
//                                         color: const Color(0xFFDE0A1E)),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(75.w, 2.5.h, 0, 0),
//                               child: Text(
//                                 Emergencydonor[index]['blood'],
//                                 style: TextStyle(
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color(0xFFDE0A1E)),
//                               ),
//                             ),
//                             Padding(
//                                 padding: EdgeInsets.fromLTRB(20.w, 1.h, 0, 0),
//                                 child: const Icon(
//                                   Icons.workspace_premium_sharp,
//                                   size: 20,
//                                   color: Color.fromARGB(255, 184, 173, 75),
//                                 )),
//                           ],
//                         ),
//                       ),
//                       onTap: () {
//                         String location = Emergencydonor[index]['location'];
//                         String name = Emergencydonor[index]['name'];
//                         String image = Emergencydonor[index]['image'];
//                         String distance = Emergencydonor[index]['distance'];
//                         String blood = Emergencydonor[index]['blood'];
//                         String rating = Emergencydonor[index]['rating'];
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder:
//                                 (context, animation, secondaryAnimation) {
//                               return EmergencyMap(
//                                   location: location,
//                                   name: name,
//                                   image: image,
//                                   distance: distance,
//                                   blood: blood,
//                                   rating: rating);
//                             },
//                             transitionDuration: const Duration(seconds: 1),
//                             transitionsBuilder: (context, animation,
//                                 secondaryAnimation, child) {
//                               const begin =
//                                   Offset(10.0, 0.0); // slide in from the right
//                               const end = Offset.zero;
//                               const curve = Curves.easeInOutQuart;

//                               var tween = Tween(begin: begin, end: end)
//                                   .chain(CurveTween(curve: curve));
//                               var offsetAnimation = animation.drive(tween);

//                               return SlideTransition(
//                                 position: offsetAnimation,
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 1,
//                     childAspectRatio: 1.0,
//                     crossAxisSpacing: 5.0,
//                     mainAxisSpacing: 5,
//                     mainAxisExtent: 110,
//                     // Adjust aspect ratio as needed
//                   ),
//                 ),
//               ),
//             ))
//           ]),
//         ),
//       );
//     });
//   }
// }
