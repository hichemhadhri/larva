import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  Future<User> getUserDetails(String id) async {
    User? user;

    final uri = Uri.parse(baseURL + "users/$id");

    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      user = User.fromJson(json.decode(response.body));
    } else {}

    return user!;
  }

  Future<void> uploadPdp(BuildContext context, String id, File pdp) async {
    final uri = Uri.parse(baseURL + "users/$id/picture");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = new http.MultipartRequest("PUT", uri);
    request.headers["Authorization"] =
        'Bearer ' + (prefs.getString("token") ?? "");

    request.files.add(await http.MultipartFile.fromPath('file', pdp.path));

    await request.send();
  }
}
