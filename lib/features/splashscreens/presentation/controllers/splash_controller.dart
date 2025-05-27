import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  late List<Widget> animatedTextWidgets;

  @override
  void onInit() {
    animatedTextWidgets = _buildAnimatedText();

    super.onInit();
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
}
