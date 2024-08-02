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
