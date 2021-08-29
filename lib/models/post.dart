class Post {
  final String backgroundColor;

  final int priority;
  final int rating;
  final int views;
  final int superlikes;
  final String id;
  final List<dynamic> contests;
  final String description;
  final String title;
  final String domaine;
  final String type;
  final String authorName;
  final String authorPdp;
  final String authorRef;
  final String mediaUrl;
  final String createdAt;

  Post({
    required this.contests,
    required this.backgroundColor,
    required this.priority,
    required this.rating,
    required this.views,
    required this.superlikes,
    required this.id,
    required this.description,
    required this.title,
    required this.domaine,
    required this.type,
    required this.authorName,
    required this.authorPdp,
    required this.authorRef,
    required this.mediaUrl,
    required this.createdAt,
  });

  static Post fromJson(Map<String, dynamic> json) => Post(
        contests: json['contests'],
        backgroundColor: json['backgroundColor'],
        priority: json['priority'],
        rating: json['rating'],
        views: json['views'],
        superlikes: json['superlikes'],
        id: json['_id'],
        description: json['description'],
        title: json['title'],
        domaine: json['domaine'],
        type: json['type'],
        authorName: json['authorName'],
        authorPdp: json['authorPdp'],
        authorRef: json['authorRef'],
        mediaUrl: json['mediaUrl'],
        createdAt: json['createdAt'],
      );
}
