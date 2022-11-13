import 'dart:convert';

import '../res/constants.dart';
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

  Future<String> addSubject(
      String instructorId, Map<String, dynamic> subjectInfo) async {
    try {
      Uri url =
          Uri.parse('${Constants.realtimeUrl}/subjects/$instructorId.json');
      http.Response res = await http.post(
        url,
        body: jsonEncode(subjectInfo),
      );
      final resData = jsonDecode(res.body);

      if (resData['error'] != null) {
        throw "Something went wrong!";
      }
      final String subId = resData['name'];
      return subId;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSubject(String subjectId, String instructorId) async {
    try {
      Uri url = Uri.parse(
          '${Constants.realtimeUrl}/subjects/$instructorId/$subjectId.json');
      await http.delete(url);
      url = Uri.parse(
          '${Constants.realtimeUrl}/subjects-students/$instructorId/$subjectId.json');
      await http.delete(url);
      url = Uri.parse('${Constants.realtimeUrl}/students.json');
      final http.Response res = await http.get(url);
      final Map<String, dynamic> students =
          jsonDecode(res.body) as Map<String, dynamic>;
      List studentsIds = students.keys.toList();
      for (var id in studentsIds) {
        if (students[id]['subjects'] != null) {
          Map ss = students[id]['subjects'] as Map;
          if (ss.containsKey(subjectId)) {
            ss.remove(subjectId);
            url = Uri.parse(
                '${Constants.realtimeUrl}/students/$id/subjects.json');
            await http.put(url, body: jsonEncode(ss));
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> getSubjectsByInstructorId(String instructorId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/subjects/$instructorId.json');
    return await http.get(url);
  }

  Future getLiveSubject(String instructorId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/subjects/$instructorId.json');
    http.Response res = await http.get(url);
    final jsonData = jsonDecode(res.body) as Map<String, dynamic>?;
    return jsonData;
  }

  Future getSubjectAttendance(String subId, String insId) async {
    Uri url =
        Uri.parse('${Constants.realtimeUrl}/attendance/$insId/$subId.json');
    return await http.get(url);
  }

  Future<void> changeSubjectName(
      String subId, String insId, String newName) async {
    try {
      Uri url = Uri.parse(
          '${Constants.realtimeUrl}/subjects/$insId/$subId.json');
      await http.patch(url, body: jsonEncode({'subjectName': newName}));
    } catch (e) {
      rethrow;
    }
  }
  Future getExcuses(String insId,String subId) async {
    Uri url = Uri.parse(
          '${Constants.realtimeUrl}/excuses/$insId/$subId.json');
    return await http.get(url);
  }
}
