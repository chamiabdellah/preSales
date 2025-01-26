class User {
  final String userId;
  final String name;
  final String email;
  final String? profilePic;

  User({
    required this.userId,
    required this.name,
    required this.email,
    this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
    );
  }
}

enum UserRole {
  admin,
  seller,
  delivery,
  warehouse,
  unknown,
}
