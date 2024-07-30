class Post {
  final String title;
  final String description;
  final String author;
  final String mediaUrl;
  final String mediaType;
  final List<String> contests;
  final List<Rating> ratings;
  final double averageRating;
  final double averageTimeSpent;
  final String createdAt;
  final String updatedAt;
  final List<String> fans;
  final String backgroundColor;
  final List<String> domaines;
  final String id;

  Post({
    required this.title,
    required this.description,
    required this.author,
    required this.mediaUrl,
    required this.mediaType,
    required this.contests,
    required this.ratings,
    required this.averageRating,
    required this.averageTimeSpent,
    required this.createdAt,
    required this.updatedAt,
    required this.fans,
    required this.backgroundColor,
    required this.domaines,
    required this.id,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      description: json['description'],
      author: json['author'],
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'],
      contests: List<String>.from(json['contests']),
      ratings:
          (json['ratings'] as List).map((i) => Rating.fromJson(i)).toList(),
      averageRating: json['averageRating'].toDouble(),
      averageTimeSpent: json['averageTimeSpent'].toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      fans: List<String>.from(json['fans']),
      backgroundColor: json['backgroundColor'],
      domaines: List<String>.from(json['domains']),
      id: json['_id'],
    );
  }
}

class Rating {
  final String user;
  final int rating;
  final int timespent;

  Rating({
    required this.user,
    required this.rating,
    required this.timespent,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      user: json['user'],
      rating: json['rating'],
      timespent: json['timespent'] ?? 0,
    );
  }
}
