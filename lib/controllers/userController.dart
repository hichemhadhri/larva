import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/post.dart';
import 'package:larva/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  Future<User> getUserDetails(String id) async {
    final uri = Uri.parse(baseURL + "users/$id");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to load user details: ${e.toString()}");
    }
    return null as User;
  }

  Future<List<Post>> getUserPosts(String id) async {
    final uri = Uri.parse(baseURL + "users/$id/posts");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Post.fromJson(item)).toList();
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to load user posts: ${e.toString()}");
    }
    return [];
  }

  Future<List<Post>> getUserFavoritePosts(String id) async {
    final uri = Uri.parse(baseURL + "users/$id/favorites");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Post.fromJson(item)).toList();
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to load user favorite posts: ${e.toString()}");
    }
    return [];
  }

  Future<void> signUp(
      String email, String password, String name, String surname) async {
    final uri = Uri.parse(baseURL + "users/sign");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
          'surname': surname,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessMessage("Sign up successful");
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to sign up: ${e.toString()}");
    }
  }

  Future<void> login(String email, String password) async {
    final uri = Uri.parse(baseURL + "users/login");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map<String, dynamic> responseData = json.decode(response.body);
        await prefs.setString('token', responseData['token']);
        _showSuccessMessage("Login successful");
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to login: ${e.toString()}");
    }
  }

  Future<void> uploadPdp(BuildContext context, String id, File pdp) async {
    final uri = Uri.parse(baseURL + "users/$id/picture");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var request = http.MultipartRequest("PUT", uri);
      request.headers["Authorization"] =
          'Bearer ${prefs.getString("token") ?? ""}';
      request.files.add(await http.MultipartFile.fromPath('file', pdp.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        _showSuccessMessage("Profile picture updated successfully.");
      } else {
        _handleMultipartError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to upload profile picture: ${e.toString()}");
    }
  }

  Future<void> updateUserProfile(
      String id, String name, String surname, String bio) async {
    final uri = Uri.parse(baseURL + "users/$id/profile");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString("token") ?? ""}',
        },
        body: json.encode({
          'name': name,
          'surname': surname,
          'bio': bio,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessMessage("Profile updated successfully");
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to update profile: ${e.toString()}");
    }
  }

  Future<void> deleteUserAccount(String id) async {
    final uri = Uri.parse(baseURL + "users/$id");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer ${prefs.getString("token") ?? ""}'},
      );

      if (response.statusCode == 200) {
        _showSuccessMessage("Account deleted successfully");
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to delete account: ${e.toString()}");
    }
  }

  Future<void> followUser(String id) async {
    final uri = Uri.parse(baseURL + "users/$id/follow");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${prefs.getString("token") ?? ""}'},
      );

      if (response.statusCode == 200) {
        _showSuccessMessage("User followed successfully");
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to follow user: ${e.toString()}");
    }
  }

  Future<void> unfollowUser(String id) async {
    final uri = Uri.parse(baseURL + "users/$id/unfollow");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${prefs.getString("token") ?? ""}'},
      );

      if (response.statusCode == 200) {
        _showSuccessMessage("User unfollowed successfully");
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to unfollow user: ${e.toString()}");
    }
  }

  Future<List<User>> getFollowers(String id) async {
    final uri = Uri.parse(baseURL + "users/$id/followers");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => User.fromJson(item)).toList();
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to load followers: ${e.toString()}");
    }
    return [];
  }

  Future<List<User>> getFollowing(String id) async {
    final uri = Uri.parse(baseURL + "users/$id/following");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => User.fromJson(item)).toList();
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to load following: ${e.toString()}");
    }
    return [];
  }

  Future<void> addFavoritePost(String postId, String contestId) async {
    final uri = Uri.parse(baseURL + "posts/favorite");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString("token") ?? ""}'
        },
        body: json.encode({
          'postId': postId,
          'contestId': contestId,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessMessage("Post added to favorites successfully");
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorMessage("Failed to add post to favorites: ${e.toString()}");
    }
  }

  void _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        _showErrorMessage("Bad request. Please try again.");
        break;
      case 401:
        _showErrorMessage("Unauthorized access. Please login again.");
        break;
      case 404:
        _showErrorMessage("User not found.");
        break;
      case 500:
        _showErrorMessage("Server error. Please try again later.");
        break;
      default:
        _showErrorMessage("An unknown error occurred.");
    }
  }

  void _handleMultipartError(http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();
    switch (response.statusCode) {
      case 400:
        _showErrorMessage(
            "Bad request. Please try again. Details: $responseBody");
        break;
      case 401:
        _showErrorMessage(
            "Unauthorized access. Please login again. Details: $responseBody");
        break;
      case 404:
        _showErrorMessage("User not found. Details: $responseBody");
        break;
      case 500:
        _showErrorMessage(
            "Server error. Please try again later. Details: $responseBody");
        break;
      default:
        _showErrorMessage("An unknown error occurred. Details: $responseBody");
    }
  }

  void _showErrorMessage(message) {
    print("Error: $message");
    // You can integrate a Flutter toast or dialog here to show the error to the user
  }

  void _showSuccessMessage(String message) {
    print("Success: $message");
    // You can integrate a Flutter toast or dialog here to show the success message to the user
  }
}
