import 'package:flutter/material.dart';

import 'package:jwt_decode/jwt_decode.dart';

class DbState with ChangeNotifier {
  int _state = 0;

  int get state => _state;

  void setState() {
    _state++;
    notifyListeners();
  }
}
