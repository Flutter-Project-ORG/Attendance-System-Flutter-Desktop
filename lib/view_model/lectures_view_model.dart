import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../models/lecture_model.dart';
import './auth_view_model.dart';
import '../res/components.dart';

class LecturesViewModel with ChangeNotifier {
  List<dynamic> _lectures = [];

  List<dynamic> get lectures => _lectures;
  bool _isLoading = false;

  bool _isLecturesFetched = false;

  bool get isLoading => _isLoading;

  void notify() {
    _isLoading = !_isLoading;
    if (!_isLoading) {
      _isLecturesFetched = true;
    }
    notifyListeners();
  }

  Future getLecturesBySubjectId(String subId, BuildContext ctx) async {
    final uid =
        Provider.of<AuthViewModel>(ctx, listen: false).user!.instructorId;
    if (_isLecturesFetched) {
      return;
    }
    try {
      _lectures.clear();
      final response = await LectureModel.getLecturesBySubjectId(subId,uid!);
      _lectures = json.decode(response.body) as List<dynamic>;
    } catch (_) {
      Components.showErrorSnackBar(ctx,
          text: 'Something went wrong. try again.');
    }
  }
}
