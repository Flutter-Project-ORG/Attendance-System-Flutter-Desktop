import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/lecture_attendance_model.dart';
import 'dart:convert';
import '../view_model/auth_view_model.dart';

class LecturesAttendanceViewModel with ChangeNotifier {
  Map<String, dynamic> _attendance = {};
  Map<String, dynamic> _filterSearch = {};

  Map<String, dynamic> get filterSearch => _filterSearch;

  Map<String, dynamic> get attendance => _attendance;

  Future getAttendanceByLectureIdAndSubjectId(String subId, String lecId, BuildContext ctx) async {
    final uid = Provider.of<AuthViewModel>(ctx, listen: false).user!.instructorId;
    _attendance.clear();
    try {
      final response = await LectureAttendanceModel.getAttendanceBySubjectIdAndLectureId(subId, lecId, uid!);
      _filterSearch.clear();
      _attendance = json.decode(response.body) as Map<String, dynamic>;
      _filterSearch = json.decode(response.body) as Map<String, dynamic>;
    } catch (err) {
      throw err;
    }
  }

  void filterBySearch(String search) {
    _filterSearch.clear();
    _filterSearch.addAll(_attendance);
    _filterSearch.removeWhere(
      (key, value) => !value['studentName'].toString().toLowerCase().startsWith(search.toLowerCase()),
    );
    notifyListeners();
  }


  Future addAttendanceList(String subId,String lecId,BuildContext context)async{
    String insId = Provider.of<AuthViewModel>(context,listen: false).user!.instructorId!;
    await LectureAttendanceModel.addAttendanceList(subId, lecId, insId);
  }


}
