class User {
  final String id;
  final String pdp;
  final String name;
  final String surname;
  final List<dynamic> favorites;
  final String sexe;
  final List<dynamic> pubs;
  final List<dynamic> pubsPhotos;
  final List<dynamic> following;
  final List<dynamic> followers;
  final String description;

  User({
    required this.following,
    required this.followers,
    required this.description,
    required this.id,
    required this.pdp,
    required this.name,
    required this.surname,
    required this.favorites,
    required this.sexe,
    required this.pubs,
    required this.pubsPhotos,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        pdp: json['pdp'],
        name: json['name'],
        surname: json['surname'],
        favorites: json['favorites'],
        sexe: json['sexe'],
        pubs: json['pubs'],
        pubsPhotos: json['pubsPhotos'],
        description: json['description'],
        following: json['following'],
        followers: json['followers'],
      );
}
