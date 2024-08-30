import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/contest.dart';
import 'package:larva/models/post.dart';
import 'package:larva/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContestController {
  Future<List<Contest>> getContests(BuildContext context) async {
    final uri = Uri.parse(baseURL + "contests/all");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(uri, headers: <String, String>{
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Contest> result = body.map((e) => Contest.fromJson(e)).toList();
        return result;
      } else {
        _showError(context, 'Failed to fetch contests');
        return [];
      }
    } catch (e) {
      _showError(context, 'An error occurred');
      return [];
    }
  }

  Future<void> createContest(
      BuildContext context,
      String name,
      String description,
      String startDate,
      String endDate,
      String rules,
      String prizes,
      [File? mediaFile]) async {
    final uri = Uri.parse(baseURL + "contests/new");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = new http.MultipartRequest("POST", uri);
    request.headers["Authorization"] =
        'Bearer ' + (prefs.getString("token") ?? "");
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['startDate'] = startDate;
    request.fields['endDate'] = endDate;
    request.fields['rules'] = rules;
    request.fields['prizes'] = prizes;

    if (mediaFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', mediaFile.path));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contest created successfully')),
        );
      } else {
        _showError(context, 'Failed to create contest');
      }
    } catch (e) {
      _showError(context, 'An error occurred during contest creation');
    }
  }

  Future<void> deleteContest(BuildContext context, String contestId) async {
    final uri = Uri.parse(baseURL + "contests/$contestId");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.delete(uri, headers: <String, String>{
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contest deleted successfully')),
        );
      } else {
        _showError(context, 'Failed to delete contest');
      }
    } catch (e) {
      _showError(context, 'An error occurred during deletion');
    }
  }

  Future<Contest> getContest(BuildContext? context, String contestId) async {
    final uri = Uri.parse(baseURL + "contests/contest/$contestId");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(uri, headers: <String, String>{
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        return Contest.fromJson(json.decode(response.body));
      } else {
        _showError(context!, 'Failed to fetch contest');
      }
    } catch (e) {
      _showError(context!, 'An error occurred');
      return null as Contest;
    }
    return null as Contest;
  }

  Future<List<Post>> getContestPosts(
      BuildContext context, String contestId) async {
    final uri = Uri.parse(baseURL + "contests/posts/$contestId");
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
        _showError(context, 'Failed to fetch contest posts');
        return [];
      }
    } catch (e) {
      _showError(context, 'An error occurred');
      return [];
    }
  }

  Future<List<User>> getContestUsers(
      BuildContext context, String contestId) async {
    final uri = Uri.parse(baseURL + "contests/users/$contestId");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(uri, headers: <String, String>{
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<User> result = body.map((e) => User.fromJson(e)).toList();
        return result;
      } else {
        _showError(context, 'Failed to fetch contest users');
        return [];
      }
    } catch (e) {
      _showError(context, 'An error occurred');
      return [];
    }
  }

  Future<List<Post>> getTop10Posts(
      BuildContext context, String contestId) async {
    final uri = Uri.parse(baseURL + "contests/top10/$contestId");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(uri, headers: <String, String>{
        'Authorization': 'Bearer ' + (prefs.getString("token") ?? ""),
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body)['topPosts'];
        List<Post> result = body.map((e) => Post.fromJson(e)).toList();
        return result;
      } else {
        _showError(context, 'Failed to fetch top posts');
        return [];
      }
    } catch (e) {
      _showError(context, 'An error occurred');
      return [];
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
