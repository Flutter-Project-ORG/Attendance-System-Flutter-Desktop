import 'package:http/http.dart' as http;
import '../res/contants.dart';
class LectureAttendanceModel{
  static getAttendanceBySubjdectIdAndLectureId(String subId,String lecId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/attendance/$subId/$lecId.json');
    return await http.get(url);
  }
}