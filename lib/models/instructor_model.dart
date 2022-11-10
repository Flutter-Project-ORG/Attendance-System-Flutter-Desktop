import 'dart:convert';

import '../res/constants.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
      InstructorModel instructor = InstructorModel(
        instructorId: userId,
        username: dbResData['username'],
        email: dbResData['email'],
        imageUrl: dbResData['imageUrl'],
      );
      await _saveAuthData(instructor);
      return instructor;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await _removeAuthData();
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

  Future<void> _saveAuthData(InstructorModel instructorModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> authData = instructorModel.toJson();
    await prefs.setString('authData', jsonEncode(authData));
  }

  Future<void> _removeAuthData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('authData')){
      await prefs.remove('authData');
    }
  }

  Future<InstructorModel?> getAuthData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('authData')){
      InstructorModel instructorModel = InstructorModel.fromJson(jsonDecode(prefs.getString('authData')!) as Map<String, dynamic>);
      return instructorModel;
    }
   return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'instructorId': instructorId,
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  factory InstructorModel.fromJson(Map<String, dynamic> map) {
    return InstructorModel(
      instructorId: map['instructorId'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Future<void> changeProfileImage()async{

  }


}
