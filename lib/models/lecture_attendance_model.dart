import 'package:http/http.dart' as http;
import '../res/contants.dart';
class LectureAttendanceModel{
  static Future getAttendanceBySubjdectIdAndLectureId(String subId,String lecId,String insId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/attendance/$insId/$subId/$lecId.json');
    return await http.get(url);
  }
}