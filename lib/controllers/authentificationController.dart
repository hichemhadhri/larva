import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:larva/providers/tokenProvider.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class Auth {
  Future<int> authentificate(
      String mail, String password, BuildContext context) async {
    //bool isConnected = await checkConnection(baseURL);

    final uri = Uri.parse(baseURL + "users/login");
    http.Response response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "mail": mail,
          "password": password,
        }));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      String token = body['token'] as String;

      context.read<Token>().setToken(token);
    }

    return response.statusCode;
  }
}
