// ignore_for_file: file_names

import 'package:blood_donor/features/dashboard/account/presentation/screens/account_screen.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Row(
            children: [
              IconButton(
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
                      transitionDuration: const Duration(microseconds: 100),
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
              SizedBox(
                width: 90,
              ),
              Text(
                'Reward Points',
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              )
            ],
          ),
          Image.asset('images/image1.jpeg'),
          SizedBox(
            height: 20,
          ),
          Text(
            'Coming Soon',
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
        ]),
      ),
    );
  }
}
