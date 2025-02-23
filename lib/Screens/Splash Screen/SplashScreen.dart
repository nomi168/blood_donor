import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'StartWithSplashScreen.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 120),
              child: Image.asset(
                'images/bloodsplash.png',
              ),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            // Text(
            //   'BLOOD FINDER',
            //   style: TextStyle(
            //     fontSize: 20.sp,
            //     color: Colors.red,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),

            // Stack(
            //   children: animatedTextWidgets,
            // ),
            // SizedBox(
            //   height: 100,
            // ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 0.h),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    const Color(0xFFDE0A1E),
                  ),
                ),
                child: const Text(
                  'Let\'s Get Started',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const StartWithSplashScreen();
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
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildAnimatedText() {
    final String text = 'BLOOD FINDER';
    const double spacing = 20.0; // Adjust the spacing as needed
    return List.generate(
      text.length,
      (index) => TweenAnimationBuilder(
        tween: Tween<double>(begin: -1.0, end: 1.0),
        duration: const Duration(seconds: 5),
        builder: (context, value, child) {
          return Row(
            children: [
              Transform.translate(
                offset: Offset(
                    index * spacing, value * 100.0), // Adjust the spacing here
                child: Opacity(
                  opacity: value > 0.0 ? value : 1.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 55.w),
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
              Transform.translate(
                offset: Offset(
                    index * spacing, value * 100.0), // Adjust the spacing here
                child: Opacity(
                  opacity: value > 0.0 ? value : 1.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 55.w),
                    child: Image.asset(
                      'assets/your_image.png', // Provide the path to your image asset
                      width: 50, // Adjust width as needed
                      height: 50, // Adjust height as needed
                    ),
                  ),
                ),
              ),
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
