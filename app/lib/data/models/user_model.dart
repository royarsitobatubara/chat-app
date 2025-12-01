class UserModel {
  final String? id;
  final String username;
  final String email;

  const UserModel({
    this.id,
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, String>{
      'id': id as String,
      'username': username,
      'email': email,
    };
  }
}
