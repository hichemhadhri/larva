import 'package:flutter/material.dart';

import 'package:jwt_decode/jwt_decode.dart';

class UserId with ChangeNotifier {
  String _id = "";

  String get id => _id;

  void setId(String token) {
    final decodedToken = Jwt.parseJwt(token);
    _id = decodedToken["userId"];
    notifyListeners();
  }
}
