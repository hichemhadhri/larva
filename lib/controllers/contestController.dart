import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/contest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContestController {
  Future<List<Contest>> getContests(BuildContext context) async {
    List<Contest> result = [];
    final uri = Uri.parse(baseURL + "contests/");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);

      result = body.map((e) => Contest.fromJson(e)).toList();
    }

    return result;
  }
}
