import 'dart:convert';

import 'package:http/http.dart' as http;
import '../res/constants.dart';

class LectureAttendanceModel {
  LectureAttendanceModel._();
  static final LectureAttendanceModel instance = LectureAttendanceModel._();

  Future getAttendanceBySubjectIdAndLectureId(
      String subId, String lecId, String insId) async {
    Uri url = Uri.parse(
        '${Constants.realtimeUrl}/attendance/$insId/$subId/$lecId.json');
    return await http.get(url);
  }

  Future<Map<String, dynamic>> _getStudentsBySubjectId(
      String subId, String insId) async {
    Uri url = Uri.parse(
        '${Constants.realtimeUrl}/subjects-students/$insId/$subId.json');
    http.Response res = await http.get(url);
    if(res.body.toString() == 'null'){
      throw 'There is no students for that subject.';
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future addAttendanceList(String subId, String lecId, String insId) async {
    Map<String, dynamic> students = await _getStudentsBySubjectId(subId, insId);
    students.forEach((key, value) {
      students[key].putIfAbsent('isAttend', () => false);
    });
    Uri url = Uri.parse(
        '${Constants.realtimeUrl}/attendance/$insId/$subId/$lecId.json');
    await http.put(url, body: jsonEncode(students));
  }

  Future<void> deleteAttendanceBySubject(String subId, String insId) async {
    Uri url =
        Uri.parse('${Constants.realtimeUrl}/attendance/$insId/$subId.json');
    await http.delete(url);
  }

  Future changeStudentAttendanceState(bool isAttend, String insId,Map<String,dynamic> data) async {
    Uri url = Uri.parse(
        '${Constants.realtimeUrl}/attendance/$insId/${data['subId']}/${data['lecId']}/${data['studentId']}.json');
    await http.patch(
      url,
      body: jsonEncode({
        "isAttend": isAttend,
      }),
    );
  }
}
