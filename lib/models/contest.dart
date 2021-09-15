class Contest {
  final String description;
  final String title;

  final String creatorName;

  final String creatorRef;
  final String mediaUrl;
  final String createdAt;
  final List<dynamic> posts;
  final List<dynamic> domaines;
  final String deadline;
  final String prize;
  final int maximumCapacity;
  final String id;

  Contest({
    required this.deadline,
    required this.prize,
    required this.maximumCapacity,
    required this.posts,
    required this.id,
    required this.description,
    required this.title,
    required this.domaines,
    required this.creatorName,
    required this.creatorRef,
    required this.mediaUrl,
    required this.createdAt,
  });

  static Contest fromJson(Map<String, dynamic> json) => Contest(
        posts: json['posts'],
        deadline: json['deadline'],
        prize: json['prize'],
        maximumCapacity: json['maximumCapcity'],
        id: json['_id'],
        description: json['description'],
        title: json['title'],
        domaines: json['domaines'],
        creatorName: json['creatorName'],
        creatorRef: json['creatorRef'],
        mediaUrl: json['mediaUrl'],
        createdAt: json['createdAt'],
      );
}
