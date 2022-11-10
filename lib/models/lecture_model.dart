import 'dart:convert';

import 'package:intl/intl.dart';

import '../res/constants.dart';

import 'package:http/http.dart' as http;

class LectureModel {
  LectureModel._();

  static final LectureModel instance = LectureModel._();

  String? lecId;

  LectureModel({this.lecId});

  static Future<http.Response> getLecturesBySubjectId(String subId,String uid) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/lectures/$uid/$subId.json');
    return await http.get(url);
  }
  static getStudentsBySubjectId(String subId) async {
    Uri url = Uri.parse('${Constants.realtimeUrl}/students/$subId.json');
    return await http.get(url);
  }

  Future<void> addLecturesBySubject(
      String instructorId, String subId, DateTime startDate, DateTime endDate, Map timesInfo) async {
    List days1 = [];
    List days2 = [];
    days1 = timesInfo['time1']['days'];
    if(timesInfo['time2'] != null){
      days2 = timesInfo['time2']['days'];
    }
    int numberOfDays = endDate.difference(startDate).inDays;

    List<String> lectures = [];
    DateTime date = startDate;
    for (int i = 0; i <= numberOfDays; i++) {
      String currentDayName = DateFormat('EEEE').format(date).toLowerCase();
      if (days1.contains(currentDayName)) {
        lectures.add(DateFormat('dd-MM-yyyy').format(date));
      }
      if (days2.contains(currentDayName)) {
        lectures.add(DateFormat('dd-MM-yyyy').format(date));
      }
      date = date.add(const Duration(days: 1));
    }
    try {
      Uri url = Uri.parse('${Constants.realtimeUrl}/lectures/$instructorId/$subId.json');
      await http.put(
        url,
        body: jsonEncode(lectures),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteLecturesBySubject(String subjectId, String instructorId) async {
    try {
      Uri url = Uri.parse('${Constants.realtimeUrl}/lectures/$instructorId/$subjectId.json');
      await http.delete(url);
    } catch (e) {
      rethrow;
    }
  }
}
