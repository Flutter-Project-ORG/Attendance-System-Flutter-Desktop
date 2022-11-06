import 'package:http/http.dart' as http;
import '../res/contants.dart';
class LectureModel {
  static Future<http.Response> getLecturesBySubjectId(String subId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/lectures/$subId.json');
    return await http.get(url);
  }
  static getStudentsBySubjectId(String subId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/students/$subId.json');
    return await http.get(url);
  }
  // static Future<http.Response> addNewLectureBySubjectId(String subId) async {
  //   Uri url = Uri.parse('${Constants.realtimeUrl}/lectures/$subId.json');
  // }
}