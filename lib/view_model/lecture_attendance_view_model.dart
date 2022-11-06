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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future getAttendanceByLectureIdAndSubjectId(String subId, String lecId,BuildContext ctx) async {
    final uid = Provider.of<AuthViewModel>(ctx,listen: false).user!.instructorId;
    try {
      final response =
          await LectureAttendanceModel.getAttendanceBySubjdectIdAndLectureId(
        subId,
        lecId,
        uid!
      );
      _attendance = json.decode(response.body) as Map<String, dynamic>;
      _filterSearch = _attendance;
    } catch (err) {
      throw err;
    }
  }

  void filterBySearch(String search) {
    _filterSearch = _attendance;
    if (search.codeUnitAt(0) >= 48 && search.codeUnitAt(0) <= 57) {
      _filterSearch.removeWhere(
        (key, value) => !value['studentId'].toString().startsWith(search),
      );
    }else{
      _filterSearch.removeWhere(
        (key, value) => !value['studentName'].toString().startsWith(search),
      );
    }
    notifyListeners();
  }
  
}
