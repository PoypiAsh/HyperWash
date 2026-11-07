class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String role;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.role = 'customer',
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'fullName': fullName, 'email': email, 'role': role};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'customer',
    );
  }
}
