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

const Color PRIMARY_COLOR = Color(0xFFDE0A1E);
