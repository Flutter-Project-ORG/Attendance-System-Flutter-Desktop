import 'dart:convert';

import '../res/contants.dart';
import 'package:http/http.dart' as http;
class SubjectModel {
  String? subjectId;
  String? subjectName;
  String? instructorId;

  SubjectModel({
    this.subjectId,
    this.subjectName,
    this.instructorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'instructorId': instructorId,
    };
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subjectId'] as String,
      subjectName: json['subjectName'] as String,
      instructorId: json['instructorId'] as String,
    );
  }

  @override
  String toString() {
    return 'SubjectModel{subjectId: $subjectId, subjectName: $subjectName, instructorId: $instructorId}';
  }

  Future<void> addSubject(String subjectName,String instructorId)async{
    try{
      Uri url = Uri.parse('${Constants.realtimeUrl}/subjects.json');
      http.Response res = await http.put(
        url,
        body: jsonEncode({ "subjectName": subjectName, "instructorId": instructorId}),
      );
      final resData = jsonDecode(res.body);
      if (resData['error'] != null) {
        throw "Something went wrong!";
      }
    }catch(e){
      rethrow;
    }
  }

}
