class User {
  final String userId;
  final String name;
  final String email;
  final String? profilePic;
  final UserRole? role;

  User({
    required this.userId,
    required this.name,
    required this.email,
    this.profilePic,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'role': role.toString().split('.').last,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
        orElse: () => UserRole.unknown,
      ),
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
