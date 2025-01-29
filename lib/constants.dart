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
      margin: EdgeInsets.only(bottom: 100.0, left: 20.0, right: 20.0),
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
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onGalleryBTNPressed();
                      },
                      child: Text(
                        'GALLERY',
                        style: TextStyle(fontSize: 18, color: PRIMARY_COLOR),
                      )),
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
