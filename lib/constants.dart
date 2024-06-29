import 'package:flutter/material.dart';

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

void showCustomSnackBar1(BuildContext context, String message, bool status) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: status ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
    ),
  );
}

const Color PRIMARY_COLOR = Color(0xFFDE0A1E);
