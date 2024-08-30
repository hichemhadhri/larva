class Post {
  final String title;
  final String description;
  final String author;
  final String mediaUrl;
  final String mediaType;
  final List<PostContest> contests;
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
  final int finalRank;

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
    this.finalRank = -1,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      final res = Post(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        author: json['author'] ?? '',
        mediaUrl: json['mediaUrl'] ?? '',
        mediaType: json['mediaType'] ?? '',
        contests: (json['contests'] as List?)
                ?.map((i) => PostContest.fromJson(i as Map<String, dynamic>))
                .toList() ??
            [], // Added null check
        ratings: (json['ratings'] as List?)
                ?.map((i) => Rating.fromJson(i as Map<String, dynamic>))
                .toList() ??
            [], // Added null check
        averageRating: (json['averageRating'] ?? 0.0).toDouble(),
        averageTimeSpent: (json['averageTimeSpent'] ?? 0.0).toDouble(),
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
        fans: List<String>.from(json['fans'] ?? []),
        backgroundColor: json['backgroundColor'] ?? '',
        domaines: List<String>.from(json['domaines'] ??
            []), // Corrected field name from 'domains' to 'domaines'
        id: json['_id'] ?? '',
        thumbnail: json['thumbnail'] ?? '',
        finalRank: json['finalRank'] ?? -1,
      );
      return res;
    } catch (e) {
      print('Error converting post: $e');
      return Post(
        title: '',
        description: '',
        author: '',
        mediaUrl: '',
        mediaType: '',
        contests: [PostContest(id: '0', name: 'No contest')],
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
        finalRank: -1,
      );
    }
  }
}

class PostContest {
  final String id;
  final String name;

  PostContest({
    required this.id,
    required this.name,
  });

  factory PostContest.fromJson(Map<String, dynamic> json) {
    return PostContest(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
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
      rating:
          (json['rating'] ?? 0.0).toDouble(), // Added null check and conversion
      timespent: json['timespent'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}
