import 'dart:async';
import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/subject_model.dart';
import '../res/components.dart';
import '../res/constants.dart';
import 'auth_view_model.dart';

class DashboardViewModel with ChangeNotifier {
  final bool _isLoadingLiveLecture = false;
  final Map<String, dynamic> _lectureInfo = {};
  Map<String, dynamic> get lectureInfo => _lectureInfo;
  bool get isLoadingLiveLecture => _isLoadingLiveLecture;

  void clearLectureInfo() => _lectureInfo.clear();

  Future<void> getLiveSubject(BuildContext context) async {
    SubjectModel subjectModel = SubjectModel.instance;
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    String insId = authProvider.user!.instructorId!;
    try {
      final Map<String, dynamic>? liveSubject =
          await subjectModel.getLiveSubject(insId);
      if (liveSubject == null) return;
      final List<String> keys = liveSubject.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        final value = liveSubject[keys[i]];
        Map<String, dynamic> times = value['times'];
        DateTime currentDate = DateTime.now();
        String currentDayName =
            DateFormat('EEEE').format(currentDate).toLowerCase();
        List days1 = times['time1']['days'];
        final startDate = DateTime.parse(value['startDate']);
        final endDate = DateTime.parse(value['endDate']);
        if (currentDate.isBefore(startDate) || currentDate.isAfter(endDate)) {
          continue;
        }
        if (days1.contains(currentDayName)) {
          DateTime currentTime = DateTime.parse(
              '0000-00-00T${currentDate.toIso8601String().split('T')[1]}');
          DateTime start = DateTime.parse(
              '0000-00-00T${times['time1']['start'].toString().split('T')[1]}');
          DateTime end = DateTime.parse(
              '0000-00-00T${times['time1']['end'].toString().split('T')[1]}');
          if (currentTime.isAfter(start) && currentTime.isBefore(end)) {
            _lectureInfo['lecId'] =
                DateFormat('dd-MM-yyyy').format(currentDate);
            _lectureInfo['subId'] = keys[i];
            _lectureInfo['subName'] = value['subjectName'];
            _lectureInfo['insId'] = authProvider.user!.instructorId!;
            break;
          }
        }

        if (times['time2'] != null) {
          List days2 = times['time2']['days'];
          if (days2.contains(currentDayName)) {
            DateTime currentTime = DateTime.parse(
                '0000-00-00T${currentDate.toIso8601String().split('T')[1]}');
            DateTime start = DateTime.parse(
                '0000-00-00T${times['time2']['start'].toString().split('T')[1]}');
            DateTime end = DateTime.parse(
                '0000-00-00T${times['time2']['end'].toString().split('T')[1]}');
            if (currentTime.isAfter(start) && currentTime.isBefore(end)) {
              _lectureInfo['lecId'] =
                  DateFormat('dd-MM-yyyy').format(currentDate);
              _lectureInfo['subId'] = keys[i];
              _lectureInfo['subName'] = value['subjectName'];
              _lectureInfo['insId'] = authProvider.user!.instructorId!;
              break;
            }
          }
        }
      }
    } catch (_) {
      showSnackbar(context,
          const Snackbar(content: Text('Something went wrong!!!!!!!!!!!!!!')));
    }
  }

  Future<Map<String, dynamic>> getExcuses(
      BuildContext context, String subId) async {
    String insId =
        Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
    SubjectModel subjectModel = SubjectModel.instance;
    final response = await subjectModel.getExcuses(insId, subId);
    //print(response.body);
    return jsonDecode(response.body) ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getSubjectsByInstructorId(
      BuildContext context) async {
    SubjectModel subjectModel = SubjectModel.instance;
    String instructorId =
        Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
    final res = await subjectModel.getSubjectsByInstructorId(instructorId);
    return jsonDecode(res.body) ?? <String, dynamic>{};
  }

  Future<void> deleteExcuse(BuildContext context,String subId,String id,String exId)async{
    String insId = Provider.of<AuthViewModel>(context,listen: false).user!.instructorId!;
    try{
      Uri url = Uri.parse(
          '${Constants.realtimeUrl}/excuses/$insId/$subId/$id/$exId.json');
      await http.delete(url);
    }catch(_){
      Components.showErrorSnackBar(context,
          text: 'Something went wrong. try again.');
    }
  }


}
