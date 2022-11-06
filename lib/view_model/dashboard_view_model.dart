import 'dart:convert';

import 'package:attendance_system_flutter_desktop/view_model/auth_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/subject_model.dart';
import '../res/contants.dart';

import 'package:http/http.dart' as http;

class DashboardViewModel with ChangeNotifier {
  Future<String?> getLiveSubject(BuildContext context) async {
    SubjectModel subjectModel = SubjectModel.instance;
    String insId =
        Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
    try {
      final Map<String, dynamic>? liveSubject =
          await subjectModel.getLiveSubject(insId);
      if (liveSubject == null) return null;
      String? lectureId;
      final List<String> keys = liveSubject.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        final value = liveSubject[keys[i]];
        Map<String, dynamic> times = value['times'];
        // print(key);
        DateTime currentDate = DateTime.now();
        String currentDayName =
            DateFormat('EEEE').format(currentDate).toLowerCase();
        // print(currentDayName);
        List days1 = times['time1']['days'];
        final startDate = DateTime.parse(value['startDate']);
        final endDate = DateTime.parse(value['endDate']);
        if (currentDate.isBefore(startDate) || currentDate.isAfter(endDate)) {
          print("yazan");
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
            lectureId = DateFormat('dd/MM/yyyy').format(currentDate);
            break;
          }
          // print(currentTime);
          // print(start);
          // print(end);
        }

        if (times['time2'] != null) {
          List days2 = times['time2']['days'];
          // print(days2);
          if (days2.contains(currentDayName)) {
            DateTime currentTime = DateTime.parse(
                '0000-00-00T${currentDate.toIso8601String().split('T')[1]}');
            DateTime start = DateTime.parse(
                '0000-00-00T${times['time2']['start'].toString().split('T')[1]}');
            DateTime end = DateTime.parse(
                '0000-00-00T${times['time2']['end'].toString().split('T')[1]}');
            if (currentTime.isAfter(start) && currentTime.isBefore(end)) {
              lectureId = DateFormat('dd/MM/yyyy').format(currentDate);
              break;
            }
          }
        }
      }
      
    } catch (e) {
      throw e;
      showSnackbar(
          context, const Snackbar(content: Text('Something went wrong!')));
    }
  }
}
