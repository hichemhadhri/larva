import 'dart:convert';
import 'dart:io';

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

  Future<int> uploadPost(BuildContext context, File file, String title,
      String description, String domaine) async {
    final uri = Uri.parse(baseURL + "posts/new");

    var request = new http.MultipartRequest("POST", uri);
    request.headers["Authorization"] = 'Bearer ' + context.read<Token>().token;
    request.fields['description'] = description;
    request.fields['title'] = title;
    request.fields['domaine'] = domaine;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 500) {}
    return response.statusCode;
  }
}
