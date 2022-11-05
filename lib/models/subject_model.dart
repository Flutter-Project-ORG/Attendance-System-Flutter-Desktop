import 'dart:convert';

import '../res/contants.dart';
import 'package:http/http.dart' as http;

class SubjectModel {
  SubjectModel._();

  static final SubjectModel instance = SubjectModel._();

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

  Future<void> addSubject(String subjectName, String instructorId, List days, String startTime, String endTime) async {
    try {
      Uri url = Uri.parse('${Constants.realtimeUrl}/subjects/$instructorId.json');
      http.Response res = await http.post(
        url,
        body: jsonEncode({
          "subjectName": subjectName,
          "times":{
            "time1":{
              'days':days,
              'start':startTime,
              'end':endTime,
            }
          },
        }),
      );
      final resData = jsonDecode(res.body);
      if (resData['error'] != null) {
        throw "Something went wrong!";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSubject(String subjectId, String instructorId) async {
    try {
      Uri url = Uri.parse('${Constants.realtimeUrl}/subjects/$instructorId/$subjectId.json');
      await http.delete(url);
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> getSubjectsByInstructorId(String instructorId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/subjects/$instructorId.json');
    return await http.get(url);
  }
}
