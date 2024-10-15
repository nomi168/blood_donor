// ignore_for_file: file_names

import 'package:blood_donor/Screens/Main%20Screen/Profile%20Screens/AccountScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RewardPointsScreen extends StatefulWidget {
  const RewardPointsScreen({super.key});

  @override
  State<RewardPointsScreen> createState() => _RewardPointsScreenState();
}

class _RewardPointsScreenState extends State<RewardPointsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      pageBuilder: (context, animation, secondaryAnimation) {
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
                  'Reward Points',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ))
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
          child: Image.asset('images/image1.jpeg'),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 3.h, 0, 0),
          child: Text(
            'Coming Soon',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
        )
        // Padding(
        //   padding: EdgeInsets.fromLTRB(0, 2.h, 0, 0),
        //   child: Container(
        //     color: Colors.red,
        //     width: 100.w,
        //     height: 20.h,
        //     child: Stack(children: [
        //       Padding(
        //           padding: EdgeInsets.fromLTRB(7.w, 4.h, 0, 0),
        //           child: Text(
        //             'Rewards: ',
        //             style: TextStyle(
        //                 fontSize: 15.sp,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white),
        //           )),
        //       Padding(
        //           padding: EdgeInsets.fromLTRB(7.w, 8.h, 0, 0),
        //           child: Text(
        //             '1800 Points ',
        //             style: TextStyle(
        //                 fontSize: 15.sp,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white),
        //           )),
        //       Padding(
        //           padding: EdgeInsets.fromLTRB(7.w, 12.h, 0, 0),
        //           child: Text(
        //             'Get 300 rewards points for',
        //             style: TextStyle(fontSize: 12.sp, color: Colors.white),
        //           )),
        //       Padding(
        //           padding: EdgeInsets.fromLTRB(7.w, 15.h, 0, 0),
        //           child: Text(
        //             'every blood donation',
        //             style: TextStyle(fontSize: 12.sp, color: Colors.white),
        //           )),
        //       Padding(
        //           padding: EdgeInsets.fromLTRB(70.w, 0.h, 0, 0),
        //           child: Image.asset(
        //             'images/image4.jpeg',
        //             width: 20.w,
        //             height: 20.h,
        //           )),
        //     ]),
        //   ),
        // ),
        // Padding(
        //     padding: EdgeInsets.fromLTRB(0.w, 3.h, 75.w, 0),
        //     child: Text(
        //       'Badge',
        //       style: TextStyle(fontSize: 15.sp, color: Colors.black),
        //     )),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
        //   child: Material(
        //     elevation: 7.0, // Add shadow/elevation
        //     borderRadius: BorderRadius.circular(10.0), // Add border radius
        //     child: Container(
        //         width: 100.w,
        //         height: 9.h,
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //             color: Colors.red, // Set border color
        //             width: 1, // Set border width
        //           ),
        //           borderRadius: BorderRadius.circular(10.0),
        //         ),
        //         child: Stack(
        //           children: [
        //             Padding(
        //                 padding: EdgeInsets.fromLTRB(0, 0, 3.w, 0),
        //                 child: CircleAvatar(
        //                   radius: 40,
        //                   child: Image.network(
        //                       'https://e7.pngegg.com/pngimages/413/169/png-clipart-computer-icons-funding-charitable-organization-funding-donation-logo-thumbnail.png'),
        //                 )),
        //             Padding(
        //               padding: EdgeInsets.fromLTRB(25.w, 1.5.h, 0, 0),
        //               child: Text(
        //                 'Donator',
        //                 style: TextStyle(
        //                     fontSize: 15.sp,
        //                     color: Colors.red,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //             Padding(
        //               padding: EdgeInsets.fromLTRB(25.w, 5.h, 0, 0),
        //               child: Text(
        //                 'You have to save 3 life to get this badge',
        //                 style: TextStyle(
        //                     fontSize: 10.sp,
        //                     color: Colors.black54,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //           ],
        //         )),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
        //   child: Material(
        //     elevation: 7.0, // Add shadow/elevation
        //     borderRadius: BorderRadius.circular(10.0), // Add border radius
        //     child: Container(
        //         width: 100.w,
        //         height: 9.h,
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //             color: Colors.red, // Set border color
        //             width: 1, // Set border width
        //           ),
        //           borderRadius: BorderRadius.circular(10.0),
        //         ),
        //         child: Stack(
        //           children: [
        //             Padding(
        //                 padding: EdgeInsets.fromLTRB(0, 0, 3.w, 0),
        //                 child: CircleAvatar(
        //                   radius: 40,
        //                   child: Image.network(
        //                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCAf4iYj7FK--H6qnjxOpnvZwub65SUwGHoA&usqp=CAU'),
        //                 )),
        //             Padding(
        //               padding: EdgeInsets.fromLTRB(25.w, 1.5.h, 0, 0),
        //               child: Text(
        //                 'Life Savior',
        //                 style: TextStyle(
        //                     fontSize: 15.sp,
        //                     color: Colors.red,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //             Padding(
        //               padding: EdgeInsets.fromLTRB(25.w, 5.h, 0, 0),
        //               child: Text(
        //                 'You have to save 6 life to get this badge',
        //                 style: TextStyle(
        //                     fontSize: 10.sp,
        //                     color: Colors.black54,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //           ],
        //         )),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 0),
        //   child: Material(
        //     elevation: 7.0, // Add shadow/elevation
        //     borderRadius: BorderRadius.circular(10.0), // Add border radius
        //     child: Container(
        //         width: 100.w,
        //         height: 9.h,
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //             color: Colors.red, // Set border color
        //             width: 1, // Set border width
        //           ),
        //           borderRadius: BorderRadius.circular(10.0),
        //         ),
        //         child: Stack(
        //           children: [
        //             Padding(
        //                 padding: EdgeInsets.fromLTRB(0, 0, 3.w, 0),
        //                 child: CircleAvatar(
        //                   radius: 40,
        //                   child: Image.network(
        //                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvTyEONMy5agZUmKTQHGsTcW4Ad1T4YXH2Jg&usqp=CAU'),
        //                 )),
        //             Padding(
        //               padding: EdgeInsets.fromLTRB(25.w, 1.5.h, 0, 0),
        //               child: Text(
        //                 'Super Hero',
        //                 style: TextStyle(
        //                     fontSize: 15.sp,
        //                     color: Colors.red,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //             Padding(
        //               padding: EdgeInsets.fromLTRB(25.w, 5.h, 0, 0),
        //               child: Text(
        //                 'You have to save 10 life to get the badge',
        //                 style: TextStyle(
        //                     fontSize: 10.sp,
        //                     color: Colors.black54,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //           ],
        //         )),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(0.w, 3.h, 0, 0),
        //   child: Text(
        //     'You have to save 6 valuable life till now',
        //     style: TextStyle(
        //         fontSize: 12.sp,
        //         color: Colors.black54,
        //         fontWeight: FontWeight.bold),
        //   ),
        // ),
        // Consumer<RewardPoints>(
        //   builder: (context, value, child) {
        //     return Slider(
        //       value: value.changevalue,
        //       min: 0.0,
        //       max: 100.0,
        //       onChanged: (newValue) {
        //         // Use the provider to update the value in RewardPoints
        //         Provider.of<RewardPoints>(context, listen: false)
        //             .ChangeValue(newValue);
        //       },
        //       activeColor: Colors.red, // Set the active color to red
        //     );
        //   },
        // ),
        // Row(
        //   children: [
        //     Expanded(
        //         child: Padding(
        //       padding: EdgeInsets.fromLTRB(7.w, 1.h, 0, 0),
        //       child: Text(
        //         'Donator',
        //         style: TextStyle(
        //             fontSize: 12.sp,
        //             color: Colors.black54,
        //             fontWeight: FontWeight.bold),
        //       ),
        //     )),
        //     Expanded(
        //         child: Padding(
        //       padding: EdgeInsets.fromLTRB(5.w, 1.h, 0, 0),
        //       child: Text(
        //         'Life Savior',
        //         style: TextStyle(
        //             fontSize: 12.sp,
        //             color: Colors.black54,
        //             fontWeight: FontWeight.bold),
        //       ),
        //     )),
        //     Expanded(
        //         child: Padding(
        //       padding: EdgeInsets.fromLTRB(5.w, 1.h, 0, 0),
        //       child: Text(
        //         'SuperHero',
        //         style: TextStyle(
        //             fontSize: 12.sp,
        //             color: Colors.black54,
        //             fontWeight: FontWeight.bold),
        //       ),
        //     )),
        //   ],
        // ),
        // Row(
        //   children: [
        //     Expanded(
        //         child: Padding(
        //             padding: EdgeInsets.fromLTRB(0.w, 0.h, 4.w, 0),
        //             child: CircleAvatar(
        //               radius: 20,
        //               child: Image.asset('images/do.png'),
        //             ))),
        //     Expanded(
        //         child: Padding(
        //             padding: EdgeInsets.fromLTRB(0.w, 0.h, 0, 0),
        //             child: CircleAvatar(
        //               radius: 30,
        //               child: Image.asset('images/person1.png'),
        //             ))),
        //     Expanded(
        //         child: Padding(
        //             padding: EdgeInsets.fromLTRB(0.w, 0.h, 0, 0),
        //             child: CircleAvatar(
        //                 radius: 20,
        //                 child: Image.asset('images/hero.jpeg')))),
        //   ],
        // ),
      ]),
    );
  }
}
