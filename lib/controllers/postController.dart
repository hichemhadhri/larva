import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PostController {
  Future<List<Post>> getPosts(BuildContext context) async {
    List<Post> result = [];
    final uri = Uri.parse(baseURL + "posts/wall");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(uri, headers: <String, String>{
      'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
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
    //get the dominant color
    PaletteGenerator pg = await _updatePaletteGenerator(file);
    String color = pg.dominantColor!.color.value.toRadixString(16);
    print(color);
    color = '0x' + color;

    // construct the http POST request
    final uri = Uri.parse(baseURL + "posts/new");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = new http.MultipartRequest("POST", uri);
    request.headers["Authorization"] =
        'Bearer ' + (prefs.getString("token") ?? "");
    request.fields['description'] = description;
    request.fields['title'] = title;
    request.fields['domaine'] = domaine;
    request.fields['backgroundColor'] = color;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 500) {}
    return response.statusCode;
  }

  Future<PaletteGenerator> _updatePaletteGenerator(File file) async {
    List<int> imageBase64 = file.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);

    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(image.image);
    return paletteGenerator;
  }
}
