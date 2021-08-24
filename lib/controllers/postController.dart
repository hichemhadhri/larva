import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:larva/providers/tokenProvider.dart';
import 'package:provider/provider.dart';

class PostController {
  Future<List<Post>> getPosts(BuildContext context) async {
    List<Post> result = [];
    final uri = Uri.parse(baseURL + "posts/wall");

    http.Response response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Bearer ' + context.read<Token>().token,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);

      result = body.map((e) => Post.fromJson(e)).toList();
    }

    return result;
  }
}
