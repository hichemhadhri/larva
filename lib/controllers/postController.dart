import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class PostController {
  Future<List<Post>> getPosts(BuildContext context) async {
    final uri = Uri.parse(baseURL + "posts/wall");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(uri, headers: <String, String>{
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);

        List<Post> result = body.map((e) => Post.fromJson(e)).toList();
        return result;
      } else {
        _showError(context, 'Failed to fetch posts');
        return [];
      }
    } catch (e) {
      _showError(context, 'An error occurred');
      return [];
    }
  }

  Future<void> uploadPost(
    BuildContext context,
    File file,
    String title,
    String description,
    List<String> contests, // Accepts a list of contest IDs
    String domaine,
  ) async {
    print('uploadpost');
    String color;
    bool isVideo = file.path.toLowerCase().endsWith('mp4') ||
        file.path.toLowerCase().endsWith('mov');
    print(isVideo);

    File? thumbnailFile;

    if (!isVideo) {
      PaletteGenerator pg = await _updatePaletteGenerator(file);
      color = pg.dominantColor!.color.value.toRadixString(16);
      print(color);
      color = '0x' + color;
    } else {
      color = '0x000000';
      // Generate thumbnail for the video
      final uint8List = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
      );

      // Save the thumbnail to a temporary file
      final tempDir = await getTemporaryDirectory();
      thumbnailFile = await File('${tempDir.path}/thumbnail.jpg').create();
      await thumbnailFile.writeAsBytes(uint8List!);
    }

    final uri = Uri.parse(baseURL + "posts/new");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = new http.MultipartRequest("POST", uri);
    request.headers["Authorization"] =
        'Bearer ' + (prefs.getString("token") ?? "");
    request.fields['description'] = description;
    request.fields['title'] = title;
    request.fields['domaine'] = domaine;
    request.fields['backgroundColor'] = color;
    request.fields['contests'] =
        jsonEncode(contests); // Pass contests as JSON array

    if (isVideo && thumbnailFile != null) {
      request.files.add(
          await http.MultipartFile.fromPath('thumbnail', thumbnailFile.path));
    }

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post uploaded successfully')),
        );
      } else {
        _showError(context, 'Failed to upload post');
      }
    } catch (e) {
      _showError(context, 'An error occurred during upload');
    }
  }

  Future<Post?> getPost(BuildContext context, String ref) async {
    final uri = Uri.parse(baseURL + "posts/post/$ref");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(uri, headers: <String, String>{
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        _showError(context, 'Failed to fetch post');
      }
    } catch (e) {
      _showError(context, 'An error occurred');
      return null;
    }
    return null;
  }

  Future<void> deletePost(BuildContext context, String ref) async {
    print('deletepost');
    final uri = Uri.parse(baseURL + "posts/$ref");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.delete(uri, headers: <String, String>{
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post deleted successfully')),
        );
      } else {
        _showError(context, 'Failed to delete post');
      }
    } catch (e) {
      _showError(context, 'An error occurred during deletion');
    }
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

  Future<void> submitRating(
      BuildContext context, String postId, double rating, int timespent) async {
    final uri = Uri.parse(baseURL + 'posts/rate/$postId');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
      },
      body: jsonEncode(<String, dynamic>{
        'rating': rating,
        'timespent': timespent,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rating submitted successfully')),
      );
    } else {
      _showError(context, 'Failed to submit rating');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
