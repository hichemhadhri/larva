import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:larva/controllers/userController.dart';
import 'package:larva/models/user.dart';

class UserProvider with ChangeNotifier {
  late User _user;

  User get user => _user;

  void setUser(Map<String, dynamic> userData) {
    _user = User.fromJson(userData);

    notifyListeners();
  }

  Future<void> setUserFromIdToken(String idToken) async {
    UserController _uc = UserController();
    User user = await _uc.getUserDetails(idToken);
    _user = user;
  }

  void addFavoritePost(String id, String id2) {
    _user.favoritePosts.removeWhere((element) => element['contest'] == id2);

    _user.favoritePosts.add({'post': id, 'contest': id2});
    // remove the old post from the list

    notifyListeners();
  }

  bool isFavorite(String postId) {
    return _user.favoritePosts.any((favorite) => favorite['post'] == postId) ??
        false;
  }

  bool isFavoriteContest(String contestId) {
    return _user.favoritePosts
            .any((favorite) => favorite['contest'] == contestId) ??
        false;
  }
}
