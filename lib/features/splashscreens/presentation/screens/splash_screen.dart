import 'package:blood_donor/constants.dart';
import 'package:blood_donor/features/splashscreens/presentation/screens/start_with_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late List<Widget> animatedTextWidgets;

  @override
  void initState() {
    super.initState();
    animatedTextWidgets = _buildAnimatedText();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 220,
            ),
            Center(
              child: Container(
                height: 40.h,
                width: 40.w,
                child: SvgPicture.asset(
                  'images/svg/Logo.svg',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: animatedTextWidgets,
            ),
            SizedBox(
              height: 70,
            ),
            InkWell(
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const StartWithSplashScreen();
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
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                decoration: BoxDecoration(
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(06)),
                child: const Text(
                  'Let\'s Get Started',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildAnimatedText() {
    final String text = 'EBLOOD APP';
    const double spacing = 20.0; // Adjust the spacing as needed
    return List.generate(
      text.length,
      (index) => TweenAnimationBuilder(
        tween: Tween<double>(begin: -6.0, end: -0.5),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 22.w),
                child: Transform.translate(
                  offset: Offset(index * spacing,
                      value * 100.0), // Adjust the spacing here
                  child: Opacity(
                    opacity: value > 0.0 ? value : 1.0,
                    child: Text(
                      text[index],
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Transform.translate(
              //   offset: Offset(
              //       index * spacing, value * 100.0), // Adjust the spacing here
              //   child: Opacity(
              //     opacity: value > 0.0 ? value : 1.0,
              //     child: Padding(
              //       padding: EdgeInsets.only(right: 55.w),
              //       child: Image.asset(
              //         'assets/your_image.png', // Provide the path to your image asset
              //         width: 50, // Adjust width as needed
              //         height: 50, // Adjust height as needed
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  // List<Widget> _buildAnimatedText() {
  //   final String text = 'BLOOD FINDER';
  //   const double spacing = 20.0; // Adjust the spacing as needed
  //   return List.generate(
  //     text.length,
  //     (index) => TweenAnimationBuilder(
  //       tween: Tween<double>(begin: -1.0, end: 1.0),
  //       duration: const Duration(seconds: 5),
  //       builder: (context, value, child) {
  //         return Transform.translate(
  //           offset: Offset(
  //               index * spacing, value * 100.0), // Adjust the spacing here
  //           child: Opacity(
  //               opacity: value > 0.0 ? value : 1.0,
  //               child: Padding(
  //                 padding: EdgeInsets.only(right: 55.w),
  //                 child: Text(
  //                   text[index],
  //                   style: TextStyle(
  //                     fontSize: 20.sp,
  //                     color: Colors.red,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               )),
  //         );
  //       },
  //     ),
  //   );
  // }
}
