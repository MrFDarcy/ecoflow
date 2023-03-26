class User {
  final String id;
  final String name;
  final String email;
  final String userPhoto;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userPhoto,
  });

  factory User.fromMap(Map<String, dynamic>? data, String id) {
    return User(
      id: id,
      name: data?['name'] ?? '',
      email: data?['email'] ?? '',
      userPhoto: data?['userPhoto'] ?? '',
    );
  }
}
