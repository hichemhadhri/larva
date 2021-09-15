import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/user.dart';
import 'package:http/http.dart' as http;

class UserController {
  Future<User> getUserDetails(BuildContext context, String id) async {
    User? user;
    final uri = Uri.parse(baseURL + "users/$id");

    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      user = User.fromJson(json.decode(response.body));
    } else {}

    return user!;
  }
}
