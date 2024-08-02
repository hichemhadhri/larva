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
  final String thumbnail;

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
    required this.thumbnail,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      final res = Post(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        author: json['author'] ?? '',
        mediaUrl: json['mediaUrl'] ?? '',
        mediaType: json['mediaType'] ?? '',
        contests: List<String>.from(json['contests'] ?? []),
        ratings:
            (json['ratings'] as List).map((i) => Rating.fromJson(i)).toList(),
        averageRating: (json['averageRating'] ?? 0.0).toDouble(),
        averageTimeSpent: (json['averageTimeSpent'] ?? 0.0).toDouble(),
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
        fans: List<String>.from(json['fans'] ?? []),
        backgroundColor: json['backgroundColor'] ?? '',
        domaines: List<String>.from(json['domains'] ?? []),
        id: json['_id'] ?? '',
        thumbnail: json['thumbnail'] ?? '',
      );
      return res;
    } catch (e) {
      print('error converting post: $e');
      return Post(
        title: '',
        description: '',
        author: '',
        mediaUrl: '',
        mediaType: '',
        contests: [],
        ratings: [],
        averageRating: 0.0,
        averageTimeSpent: 0.0,
        createdAt: '',
        updatedAt: '',
        fans: [],
        backgroundColor: '',
        domaines: [],
        id: '',
        thumbnail: '',
      );
    }
  }
}

class Rating {
  final String user;
  final double rating;
  final int timespent;
  final String id;

  Rating({
    required this.user,
    required this.rating,
    required this.timespent,
    required this.id,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      user: json['user'] ?? '',
      rating: json['rating'].toDouble() ?? 0,
      timespent: json['timespent'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}
