import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showCustomSnackBar(BuildContext context, String message, bool status) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: status ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
    ),
  );
}

void showCustomSnackBar1(String message, bool status, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: status ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
    ),
  );
}

void showloader(BuildContext context) {
  Container(
    child: CircularProgressIndicator(
      color: PRIMARY_COLOR,
      strokeWidth: 1,
    ),
  );
}

showLoader(message) {
  EasyLoading.show(
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: false,
      indicator: Container(
        //decoration: const BoxDecoration(color: Colors.white),
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Row(
          children: [
            Platform.isAndroid
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 15,
                  ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
              "$message...",
              style: const TextStyle(
                  color: Colors.white, fontFamily: "Montserrat", fontSize: 16),
            ))
          ],
        ),
      ));
}

// void showLoader(String message) {
//   EasyLoading.show(
    
//     maskType: EasyLoadingMaskType.clear,
//     dismissOnTap: true,
//     indicator: _AnimatedLoader(message: message),
//   );
// }

// class _AnimatedLoader extends StatefulWidget {
//   final String message;
//   const _AnimatedLoader({required this.message});

//   @override
//   State<_AnimatedLoader> createState() => _AnimatedLoaderState();
// }

// class _AnimatedLoaderState extends State<_AnimatedLoader>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<Color?> _colorAnimation;
//   late final Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     // 🔴 Red glow animation
//     _colorAnimation = ColorTween(
//       begin: Colors.red.withOpacity(0.3),
//       end: Colors.red.withOpacity(0.9),
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     // 🔁 Subtle scaling (pulse)
//     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min, // 👈 keeps size tight around content
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         AnimatedBuilder(
//           animation: _controller,
//           builder: (context, _) {
//             return Transform.scale(
//               scale: _scaleAnimation.value,
//               child: Container(
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: _colorAnimation.value ?? Colors.red,
//                     width: 2.5,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: _colorAnimation.value ?? Colors.red,
//                       blurRadius: 14,
//                       spreadRadius: 3,
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     'images/svg/Logo.svg',
//                     height: 28,
//                     width: 28,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         // const SizedBox(width: 12),
//         // Flexible(
//         //   child: Text(
//         //     "${widget.message}...",
//         //     style: const TextStyle(
//         //       color: Colors.black, // 👈 better contrast for transparent bg
//         //       fontFamily: "Montserrat",
//         //       fontWeight: FontWeight.w600,
//         //       fontSize: 16,
//         //     ),
//         //     overflow: TextOverflow.ellipsis,
//         //   ),
//         // ),
//       ],
//     );
//   }
// }

// ignore: must_be_immutable
class CustomDialogBox extends StatefulWidget {
  Function onCameraBTNPressed, onGalleryBTNPressed;

  CustomDialogBox(
      {required this.onCameraBTNPressed, required this.onGalleryBTNPressed});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Cnic Scanner',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Please select any option',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onCameraBTNPressed();
                      },
                      child: Text(
                        'CAMERA',
                        style: TextStyle(fontSize: 18, color: PRIMARY_COLOR),
                      )),
                  // TextButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //       widget.onGalleryBTNPressed();
                  //     },
                  //     child: Text(
                  //       'GALLERY',
                  //       style: TextStyle(fontSize: 18, color: PRIMARY_COLOR),
                  //     )),
                ],
              ),
            ],
          ),
        ),
        // Positioned(
        //   left: 20,
        //   right: 20,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.transparent,
        //     radius: 45,
        //     child: ClipRRect(
        //         borderRadius: BorderRadius.all(Radius.circular(45)),
        //         child: Image.asset("assets/images/person_icon.png")),
        //   ),
        // ),
      ],
    );
  }
}

const Color PRIMARY_COLOR = Color(0xFFDE0A1E);

//colors
const int kDarkGreyColor = 0xFF575757;
const int kGreyColor = 0xFF4a4a4a;
const int kLightGreyColor = 0xFF979595;
const int kGradientGreyColor = 0xFF8F939E;
const int kDeepDarkGreenColor = 0xff014531;
const int kDarkGreenColor = 0xFF1c8164;
const int kGreenShadowColor = 0xff6ddfbf;
const int kSeaGreenColor = 0xFF00BCD4;
const int kLightSeaGreenColor = 0xFFE6C0F8FF;
const int kShadowColor = 0xFFe9e9e9;
