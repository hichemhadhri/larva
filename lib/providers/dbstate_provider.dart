import 'package:flutter/material.dart';

import 'package:jwt_decode/jwt_decode.dart';

class DbState with ChangeNotifier {
  bool _state = false;

  bool get state => _state;

  void setState() {
    _state = !_state;
    notifyListeners();
  }
}
