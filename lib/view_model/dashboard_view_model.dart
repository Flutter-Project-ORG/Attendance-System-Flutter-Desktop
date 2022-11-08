import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:attendance_system_flutter_desktop/view_model/auth_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../models/subject_model.dart';
import '../res/contants.dart';

import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'attendance_qr_view_model.dart';

class DashboardViewModel with ChangeNotifier {
  final bool _isLoadingLiveLecture = false;
  final Map<String, dynamic> _lectureInfo = {};
  Map<String, dynamic> get lectureInfo => _lectureInfo;
  bool get isLoadingLiveLecture => _isLoadingLiveLecture;

  Future<void> getLiveSubject(BuildContext context) async {
    SubjectModel subjectModel = SubjectModel.instance;
    String insId = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
    try {
      final Map<String, dynamic>? liveSubject = await subjectModel.getLiveSubject(insId);
      if (liveSubject == null) return;
      final List<String> keys = liveSubject.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        final value = liveSubject[keys[i]];
        Map<String, dynamic> times = value['times'];
        DateTime currentDate = DateTime.now();
        String currentDayName = DateFormat('EEEE').format(currentDate).toLowerCase();
        List days1 = times['time1']['days'];
        final startDate = DateTime.parse(value['startDate']);
        final endDate = DateTime.parse(value['endDate']);
        if (currentDate.isBefore(startDate) || currentDate.isAfter(endDate)) {
          continue;
        }
        if (days1.contains(currentDayName)) {
          DateTime currentTime = DateTime.parse('0000-00-00T${currentDate.toIso8601String().split('T')[1]}');
          DateTime start = DateTime.parse('0000-00-00T${times['time1']['start'].toString().split('T')[1]}');
          DateTime end = DateTime.parse('0000-00-00T${times['time1']['end'].toString().split('T')[1]}');
          if (currentTime.isAfter(start) && currentTime.isBefore(end)) {
            _lectureInfo['lecId'] = DateFormat('dd-MM-yyyy').format(currentDate);
            _lectureInfo['subId'] = keys[i];
            _lectureInfo['subName'] = value['subjectName'];
            _lectureInfo['insId'] = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
            break;
          }
        }

        if (times['time2'] != null) {
          List days2 = times['time2']['days'];
          if (days2.contains(currentDayName)) {
            DateTime currentTime = DateTime.parse('0000-00-00T${currentDate.toIso8601String().split('T')[1]}');
            DateTime start = DateTime.parse('0000-00-00T${times['time2']['start'].toString().split('T')[1]}');
            DateTime end = DateTime.parse('0000-00-00T${times['time2']['end'].toString().split('T')[1]}');
            if (currentTime.isAfter(start) && currentTime.isBefore(end)) {
              _lectureInfo['lecId'] = DateFormat('dd-MM-yyyy').format(currentDate);
              _lectureInfo['subId'] = keys[i];
              _lectureInfo['subName'] = value['subjectName'];
              _lectureInfo['insId'] = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
              break;
            }
          }
        }
      }
    } catch (e) {
      showSnackbar(context, const Snackbar(content: Text('Something went wrong!')));
    }
  }

  Future showAttendanceQr(BuildContext context, String path, String lecId) async {
    final key = encrypt.Key.fromUtf8(Constants.encryptKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    await Provider.of<AttendanceQrViewModel>(context, listen: false).changeRandomNum(lecId);
    Timer timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) async {
        await Provider.of<AttendanceQrViewModel>(context, listen: false).changeRandomNum(lecId);
      },
    );
    /// Just For Test

    await windowManager.setPosition(const Offset(0, 0));
    await windowManager.setSize(const Size(200, 200));

    /// My Real Code
    showDialog(
        context: context,
        builder: (ctx) {
          return ContentDialog(
            title: const Text('Please scan to attend'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<AttendanceQrViewModel>(
                  builder: (ctx, qr, _) {
                    Map<String, String> data = {
                      "path": path,
                      "randomNum": qr.randomNum.toString(),
                      "lecId": lecId,
                    };
                    final encrypted = encrypter.encrypt(jsonEncode(data), iv: iv);
                    return QrImage(
                      backgroundColor: Colors.white,
                      data: encrypted.base64,
                      version: QrVersions.auto,
                      size: 200.0,
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                  timer.cancel();
                  await Provider.of<AttendanceQrViewModel>(context, listen: false).deleteRandomFromDB(lecId);
                },
              ),
            ],
          );
        });
  }
}
