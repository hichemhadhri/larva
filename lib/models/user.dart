import 'dart:convert';
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
  final bool isCreator;
  final Map<String, dynamic> stats;

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
    this.isCreator = false,
    this.stats = const {
      'contestsWon': 0,
      'averageRating': 0,
      'hearts': 0,
      'top1pct': 0,
    },
  });

  static User fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return User(
      id: user['_id'],
      email: user['email'],
      name: user['name'],
      surname: user['surname'],
      bio: user['bio'],
      profilePicture: user['profilePicture'],
      posts: List<dynamic>.from(user['posts']),
      joinedContests: List<dynamic>.from(user['joinedContests']),
      ratings: List<UserRating>.from(
          user['ratings'].map((x) => UserRating.fromJson(x))),
      following: List<dynamic>.from(user['following']),
      followers: List<dynamic>.from(user['followers']),
      favoritePosts: List<dynamic>.from(user['favoritePosts']),
      createdContests: List<dynamic>.from(user['createdContests']),
      createdAt: DateTime.parse(user['createdAt']),
      updatedAt: DateTime.parse(user['updatedAt']),
      isCreator: json['isCreator'] ?? true,
      stats: json['stats'] ??
          {
            'contestsWon': 0,
            'averageRating': 0,
            'hearts': 0,
            'top1pct': 0,
          },
    );
  }

  static User createDummyUser() {
    final randomStringGenerator = _RandomStringGenerator();
    return User(
      id: randomStringGenerator.generate(24),
      email: '${randomStringGenerator.generate(10)}@example.com',
      name: 'John',
      surname: 'Doe',
      bio: 'This is a dummy user.',
      profilePicture: 'https://picsum.photos/200/${Random().nextInt(100)}',
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
        post: _RandomStringGenerator().generate(24),
        rating: Random().nextDouble() * 5,
      );
    });
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

class _RandomStringGenerator {
  static const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

  String generate(int length) {
    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
