import '../res/contants.dart';

class UserModel {
  String? userId;
  String? username;
  String? email;
  String? imageUrl;
  int? role;

  UserModel({
    this.userId,
    this.username,
    this.email,
    this.imageUrl,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
      'role': role,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl'] as String,
      role: json['role'] as int,
    );
  }

  Future<void> signUp({required String username, required String email, required String password}) async {
    String url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Constants.apiKey}";
    try {} catch (e) {

    }
  }
}
