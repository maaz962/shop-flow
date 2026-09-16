class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final bool isActive;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
});

  factory UserModel.fromMap(
      String uid,
      Map<String, dynamic> map,
      ) {
    return UserModel(
        uid: uid,
        name: map['name'],
        email: map['email'] ?? '',
        role: map['role'] ?? 'user',
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'email': email,
      'role' : role,
      'isActive': isActive,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    bool? isActive,
}) {
    return UserModel(
        uid: uid,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    );
  }

}