import 'package:fluent_ui/fluent_ui.dart';
import 'package:http/http.dart' as http;
import '../models/lecture_model.dart';
import 'dart:convert';

class LecturesViewModel with ChangeNotifier {
  Map<String, dynamic> _lectures = {};

  Map<String, dynamic> get lectures => _lectures;
  bool _isLoading = false;

  bool _isLecturesFetched = false;

  bool get isLoading => _isLoading;
  void notify() {
    _isLoading = !_isLoading;
    if(!_isLoading){
      _isLecturesFetched = true;
    }
    notifyListeners();
  }

  Future getLecturesBySubjectId(String subId) async {
    if(_isLecturesFetched){
      return;
    }
    try {
      final response = await LectureModel.getLecturesBySubjectId(subId);
      _lectures = json.decode(response.body) as Map<String, dynamic>;
    } catch (err) {
      throw err;
    }
  }
}
