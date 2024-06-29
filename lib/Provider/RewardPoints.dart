// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class RewardPoints with ChangeNotifier {
  double _changevalue = 60.0;
  double get changevalue => _changevalue;

  // ignore: non_constant_identifier_names
  void ChangeValue(double newvalue) {
    _changevalue = newvalue;
    notifyListeners();
  }
}
