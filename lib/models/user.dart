import 'dart:math';

class User {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String bio;
  final String profilePicture;
  final List<dynamic> posts;
  final List<dynamic> joinedContests;
  final List<UserRating> ratings;
  final List<dynamic> following;
  final List<dynamic> followers;
  final List<dynamic> favoritePosts;
  final List<dynamic> createdContests;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.bio,
    required this.profilePicture,
    required this.posts,
    required this.joinedContests,
    required this.ratings,
    required this.following,
    required this.followers,
    required this.favoritePosts,
    required this.createdContests,
    required this.createdAt,
    required this.updatedAt,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['user']['_id'],
        email: json['user']['email'],
        name: json['user']['name'],
        surname: json['user']['surname'],
        bio: json['user']['bio'],
        profilePicture: json['user']['profilePicture'],
        posts: json['user']['posts'],
        joinedContests: json['user']['joinedContests'],
        ratings: List<UserRating>.from(
            json['user']['ratings'].map((x) => UserRating.fromJson(x))),
        following: json['user']['following'],
        followers: json['user']['followers'],
        favoritePosts: json['user']['favoritePosts'],
        createdContests: json['user']['createdContests'],
        createdAt: DateTime.parse(json['user']['createdAt']),
        updatedAt: DateTime.parse(json['user']['updatedAt']),
      );

  static User createDummyUser() {
    return User(
      id: _generateRandomString(24),
      email: _generateRandomString(10) + '@example.com',
      name: 'John',
      surname: 'Doe',
      bio: 'This is a dummy user.',
      profilePicture:
          'https://picsum.photos/200/' + Random().nextInt(100).toString(),
      posts: [],
      joinedContests: [],
      ratings: _generateDummyRatings(),
      following: [],
      followers: [],
      favoritePosts: [],
      createdContests: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<UserRating> _generateDummyRatings() {
    return List.generate(5, (index) {
      return UserRating(
        post: _generateRandomString(24),
        rating: Random().nextDouble() * 5,
      );
    });
  }

  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
        length, (index) => chars[Random().nextInt(chars.length)]).join();
  }
}

class UserRating {
  final String post;
  final double rating;

  UserRating({
    required this.post,
    required this.rating,
  });

  static UserRating fromJson(Map<String, dynamic> json) => UserRating(
        post: json['post'],
        rating: json['rating'].toDouble(),
      );
}
