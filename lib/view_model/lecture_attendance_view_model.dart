import 'dart:io';
import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as path_provider;

import '../view_model/auth_view_model.dart';
import '../models/lecture_attendance_model.dart';
import '../res/components.dart';

class LecturesAttendanceViewModel with ChangeNotifier {
  Map<String, dynamic> _attendance = {};
  Map<String, dynamic> _filterSearch = {};

  Map<String, dynamic> get filterSearch => _filterSearch;

  Map<String, dynamic> get attendance => _attendance;

  final LectureAttendanceModel _lectureAttendanceModel =
      LectureAttendanceModel.instance;

  String? user;

  bool fetchLiveAttendance = false;

  set setFetchLiveAttendance(bool value){
    notifyListeners();
  }

  Future getAttendanceByLectureIdAndSubjectId(
      String subId, String lecId, BuildContext ctx) async {
    final uid =
        Provider.of<AuthViewModel>(ctx, listen: false).user!.instructorId;
    _attendance.clear();
    try {
      final response = await _lectureAttendanceModel
          .getAttendanceBySubjectIdAndLectureId(subId, lecId, uid!);
      _filterSearch.clear();
      _attendance = (json.decode(response.body) ?? <String, dynamic>{})
          as Map<String, dynamic>;
      _filterSearch = (json.decode(response.body) ?? <String, dynamic>{})
          as Map<String, dynamic>;
      fetchLiveAttendance = true;
      // print(_attendance);
    } catch (_) {
      Components.showErrorSnackBar(ctx,
          text: 'Something went wrong. try again.');
    }
  }

  void filterBySearch(String search) {
    _filterSearch.clear();
    _filterSearch.addAll(_attendance);
    _filterSearch.removeWhere(
      (key, value) => !value['studentName']
          .toString()
          .toLowerCase()
          .startsWith(search.toLowerCase()),
    );
    notifyListeners();
  }

  Future addAttendanceList(
      String subId, String lecId, BuildContext context) async {
    String insId =
        Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
    try {
      await _lectureAttendanceModel.addAttendanceList(subId, lecId, insId);
    } catch (e) {
      rethrow;
    }
  }

  Future changeStudentAttendanceState(
      bool isAttend, Map<String, dynamic> data, BuildContext context) async {
    _attendance[data['studentId']]['isAttend'] = isAttend;
    try {
      final insId =
          Provider.of<AuthViewModel>(context, listen: false).user!.instructorId;
      await _lectureAttendanceModel.changeStudentAttendanceState(
          isAttend, insId!, data);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> printLectureAttendance(
      BuildContext context, Map<String, dynamic> lectureData) async {
    final pdf = pw.Document();
    final List studentIds = _attendance.keys.toList();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  lectureData['subName'],
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              pw.Text(lectureData['lecId']),
              pw.Divider(),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(
                          'Student name',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(
                          'Attendance',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < _attendance.length; i++)
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(4.0),
                          child:
                              pw.Text(_attendance[studentIds[i]]['studentName']),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text(
                              _attendance[studentIds[i]]['isAttend'] == true
                                  ? 'Attend'
                                  : 'Absent'),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
    Directory? output = await path_provider.getDownloadsDirectory();
    output ??= await path_provider.getTemporaryDirectory();
    final file = File("${output.path}/${lectureData['lecId']}.pdf");
    await file.writeAsBytes(await pdf.save()).then((value) {
      showSnackbar(
        context,
        Snackbar(
          content: Text('File download to ${value.path}'),
          extended: true,
        ),
      );
    });
  }
}
