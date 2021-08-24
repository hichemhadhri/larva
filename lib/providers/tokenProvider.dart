import 'package:flutter/material.dart';

class Token with ChangeNotifier {
  late String _token;
  String get token => _token;

  void setToken(String newToken) {
    _token = newToken;
    notifyListeners();
  }
}
