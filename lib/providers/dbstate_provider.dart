import 'package:flutter/material.dart';


class DbState with ChangeNotifier {
  bool _state = false;

  bool get state => _state;

  void setState() {
    _state = !_state;
    notifyListeners();
  }
}
