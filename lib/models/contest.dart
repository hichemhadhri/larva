import 'dart:math';

class Contest {
  final String name;
  final String description;
  final String mediaUrl;
  final String startDate;
  final String endDate;
  final String rules;
  final String prizes;
  final List<dynamic> posts;
  final String createdBy;
  final List<dynamic> users;
  final String createdAt;
  final String updatedAt;
  final String id;

  Contest({
    required this.name,
    required this.description,
    required this.mediaUrl,
    required this.startDate,
    required this.endDate,
    required this.rules,
    required this.prizes,
    required this.posts,
    required this.createdBy,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  static Contest fromJson(Map<String, dynamic> json) {
    try {
      final name = json['name'] ?? '';

      final description = json['description'] ?? '';

      final mediaUrl = json['mediaUrl'] ?? '';

      final startDate = json['startDate'] ?? '';

      final endDate = json['endDate'] ?? '';

      final rules = json['rules'] ?? '';

      final prizes = json['prizes'] ?? '';

      final posts = json['posts'] ?? [];

      final createdBy = json['createdBy'] ?? '';

      final users = json['users'] ?? [];

      final createdAt = json['createdAt'] ?? '';

      final updatedAt = json['updatedAt'] ?? '';

      final id = json['_id'] ?? '';

      return Contest(
        name: name,
        description: description,
        mediaUrl: mediaUrl,
        startDate: startDate,
        endDate: endDate,
        rules: rules,
        prizes: prizes,
        posts: posts,
        createdBy: createdBy,
        users: users,
        createdAt: createdAt,
        updatedAt: updatedAt,
        id: id,
      );
    } catch (e) {
      print("Error parsing JSON: $e");
      rethrow;
    }
  }

  static Contest createDummyContest() {
    return Contest(
      name: 'Dummy Contest',
      description: 'This is a dummy contest.',
      mediaUrl: 'https://picsum.photos/400',
      startDate: DateTime.now().toIso8601String(),
      endDate: DateTime.now().add(Duration(days: 7)).toIso8601String(),
      rules: 'These are dummy rules.',
      prizes: 'Dummy prizes.',
      posts: [],
      createdBy: _generateRandomString(24),
      users: [],
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      id: _generateRandomString(24),
    );
  }

  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
        length, (index) => chars[Random().nextInt(chars.length)]).join();
  }
}
