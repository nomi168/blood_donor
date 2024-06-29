// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class Profile with ChangeNotifier {
  String _name = "Nomi";
  String get name => _name;
  // ignore: prefer_final_fields
  String _number = '00003456234';
  String get number => _number;
  // ignore: prefer_final_fields
  String _picture =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW1wvZlSODGaWeFinF6pwMhEpwXwQ7_MqZCg&usqp=CAU';
  String get picture => _picture;
  String _blood = 'A+ Group';
  String get blood => _blood;
  String _life = '0 Saved Life';
  String get life => _life;
  String _date = '25 Feb';
  String get date => _date;

  void updateName(String newMessage) {
    _name = newMessage;
    notifyListeners();
  }

  void updateNumber(String newlocation) {
    _number = newlocation;
    notifyListeners();
  }

  void updatepicture(String newlocation) {
    _number = newlocation;
    notifyListeners();
  }

  void updateblood(String newlocation) {
    _blood = newlocation;
    notifyListeners();
  }

  void updatelife(String newlocation) {
    _life = newlocation;
    notifyListeners();
  }

  void updatedate(String newlocation) {
    _date = newlocation;
    notifyListeners();
  }
}
