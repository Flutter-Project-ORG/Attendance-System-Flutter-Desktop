import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import '../res/contants.dart';
class LectureAttendanceModel{

  static Future getAttendanceBySubjectIdAndLectureId(String subId,String lecId,String insId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/attendance/$insId/$subId/$lecId.json');
    return await http.get(url);
  }

  static Future<Map<String,dynamic>> _getStudentsBySubjectId(String subId,String insId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/subjects-students/$insId/$subId.json');
    http.Response res = await http.get(url);
    return jsonDecode(res.body) as Map<String,dynamic>;
  }


  static Future addAttendanceList(String subId,String lecId,String insId) async {
    Map<String,dynamic> students = await _getStudentsBySubjectId(subId,insId);
    Map attStudents = {};
    // Map t = students.putIfAbsent('isAttend', () => false);

    students.forEach((key, value) {
      students[key].putIfAbsent('isAttend', () => false);
      // attStudents[key] = students;
    });
      print(students);
    Uri url = Uri.parse('${Constants.realtimeUrl}/attendance/$insId/$subId/$lecId.json');
    return await http.put(url,body: jsonEncode(students));
  }


}