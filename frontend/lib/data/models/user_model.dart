class UserModel {
  final String id;
  final String email;
  final String password;
  final String username;
  final String? photo;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.username,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
      photo: json['photo'] != null ? json['photo'] as String : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'username': username,
      'photo': photo,
    };
  }
}
