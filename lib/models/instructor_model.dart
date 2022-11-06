import 'dart:convert';

import '../res/contants.dart';

import 'package:http/http.dart' as http;

class InstructorModel {

  InstructorModel._();
  static final instance = InstructorModel._();

  String? instructorId;
  String? username;
  String? email;
  String? imageUrl;

  InstructorModel({
    this.instructorId,
    this.username,
    this.email,
    this.imageUrl,
  });


  Map<String, dynamic> toJson() {
    return {
      'userId': instructorId,
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      instructorId: json['userId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  @override
  String toString() {
    return 'InstructorModel{userId: $instructorId, username: $username, email: $email, imageUrl: $imageUrl}';
  }

  Future<InstructorModel> authenticate(
      {required String email, required String password, String? username, bool isLogin = false}) async {
    try {
      Uri authUrl =
          Uri.parse("${Constants.authBaseUrl}${isLogin ? 'signInWithPassword' : 'signUp'}?key=${Constants.apiKey}");
      http.Response authRes = await http.post(
        authUrl,
        body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
      );
      final authResData = jsonDecode(authRes.body);
      if (authResData['error'] != null) {
        throw authResData['error']['message'];
      }

      String userId = authResData['localId'];
      Uri dbUrl = Uri.parse("${Constants.realtimeUrl}/instructors/$userId.json");
      http.Response dbRes;
      if (isLogin) {
        dbRes = await http.get(
          dbUrl,
        );
      } else {
        dbRes = await http.put(
          dbUrl,
          body: jsonEncode({"username": username, "email": email, "imageUrl": null}),
        );
      }
      final dbResData = jsonDecode(dbRes.body);
      if (dbResData['error'] != null) {
        throw "Something went wrong!";
      }
      return InstructorModel(
        instructorId: userId,
        username: dbResData['username'],
        email: dbResData['email'],
        imageUrl: dbResData['imageUrl'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> restPassword(String email) async {
    try {
      Uri url = Uri.parse(Constants.resetPassUrl);
      http.Response authRes = await http.post(
        url,
        body: jsonEncode({'email': email, 'requestType': 'PASSWORD_RESET'}),
      );
      final authResData = jsonDecode(authRes.body);
      if (authResData['error'] != null) {
        throw authResData['error']['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
