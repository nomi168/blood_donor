// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class MyPageProvider with ChangeNotifier {
  String _message = "Hello! Nafees Mazhar";

  String get message => _message;
  // ignore: prefer_final_fields
  String _location = 'Pakistan';
  String get location => _location;

  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }

  void updatelocation(String newlocation) {
    _message = newlocation;
    notifyListeners();
  }
}
