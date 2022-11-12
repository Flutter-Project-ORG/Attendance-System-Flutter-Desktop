import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/subject_model.dart';
import '../models/lecture_model.dart';
import '../models/lecture_attendance_model.dart';
import 'auth_view_model.dart';
import './dashboard_view_model.dart';
import '../res/components.dart';

class SubjectsViewModel with ChangeNotifier {
  SubjectModel subjectModel = SubjectModel.instance;
  LectureModel lectureModel = LectureModel.instance;
  LectureAttendanceModel lectureAttendanceModel =
      LectureAttendanceModel.instance;

  Future<void> addSubject(BuildContext context) async {
    Map<String, dynamic> subjectInfo = {};
    Map<String, dynamic>? time1;
    Map<String, dynamic>? time2;

    DateTime? startTime;
    DateTime? endTime;
    DateTime? startDate;
    DateTime? endDate;
    final List weekDays = [
      {
        'name': 'saturday',
        'isChecked': false,
      },
      {
        'name': 'sunday',
        'isChecked': false,
      },
      {
        'name': 'monday',
        'isChecked': false,
      },
      {
        'name': 'tuesday',
        'isChecked': false,
      },
      {
        'name': 'wednesday',
        'isChecked': false,
      },
      {
        'name': 'thursday',
        'isChecked': false,
      },
      {
        'name': 'friday',
        'isChecked': false,
      },
    ];

    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return ContentDialog(
          title: const Text('Add New Subject'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBox(
                      controller: controller,
                      header: 'Enter subject name',
                      placeholder: 'Subject name',
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text('Choose days:'),
                    Wrap(
                      direction: Axis.horizontal,
                      children: weekDays.map((day) {
                        return Row(
                          children: [
                            Checkbox(
                              checked: day['isChecked'],
                              onChanged: (bool? value) {
                                day['isChecked'] = value;
                                setState(() {});
                              },
                            ),
                            Text(day['name']),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text('Choose times:'),
                    const SizedBox(
                      width: 8.0,
                    ),
                    TimePicker(
                      selected: startTime,
                      onChanged: (DateTime time) {
                        setState(() => startTime = time);
                      },
                      header: 'Start time',
                    ),
                    TimePicker(
                      selected: endTime,
                      onChanged: (DateTime time) {
                        setState(() => endTime = time);
                      },
                      header: 'End time',
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text('Choose dates:'),
                    const SizedBox(
                      width: 8.0,
                    ),
                    DatePicker(
                      header: 'Start date',
                      selected: startDate,
                      onChanged: (time) => setState(() => startDate = time),
                    ),
                    DatePicker(
                      header: 'End date',
                      selected: endDate,
                      onChanged: (time) => setState(() => endDate = time),
                    ),
                    const SizedBox(
                      width: 64.0,
                    ),
                    TextButton(
                      onPressed: () {
                        if (time1 != null) {
                          showSnackbar(
                              context,
                              const Snackbar(
                                  content: Text(
                                      'You cannot add more than two times')));
                          return;
                        }
                        if (!_checkSubjectInfo(context,
                            subName: controller.text,
                            weekDays: weekDays,
                            times: [startTime, endTime],
                            dates: [startDate, endDate])) {
                          return;
                        }
                        time1 = {
                          'days': _getSelectedDays(weekDays),
                          'start': startTime!.toIso8601String(),
                          'end': endTime!.toIso8601String(),
                        };
                        for (var day in weekDays) {
                          day['isChecked'] = false;
                        }
                        startTime = null;
                        endTime = null;
                        setState(() {});
                      },
                      child: const Text('Add another time'),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            Button(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FilledButton(
              child: const Text('Add'),
              onPressed: () async {
                if (!_checkSubjectInfo(context,
                    subName: controller.text,
                    weekDays: weekDays,
                    times: [startTime, endTime],
                    dates: [startDate, endDate])) {
                  return;
                }
                String instructorId =
                    Provider.of<AuthViewModel>(context, listen: false)
                        .user!
                        .instructorId!;
                try {
                  if (time1 == null) {
                    time1 = {
                      'days': _getSelectedDays(weekDays),
                      'start': startTime!.toIso8601String(),
                      'end': endTime!.toIso8601String(),
                    };
                  } else {
                    time2 = {
                      'days': _getSelectedDays(weekDays),
                      'start': startTime!.toIso8601String(),
                      'end': endTime!.toIso8601String(),
                    };
                  }
                  subjectInfo['subjectName'] = controller.text;
                  subjectInfo['startDate'] = startDate!.toIso8601String();
                  subjectInfo['endDate'] = endDate!.toIso8601String();
                  subjectInfo['times'] = {
                    'time1': time1,
                    'time2': time2,
                  };
                  Provider.of<SubjectsViewModel>(context,listen: false).subjects.clear();
                  String subId =
                      await subjectModel.addSubject(instructorId, subjectInfo);

                  await lectureModel
                      .addLecturesBySubject(instructorId, subId, startDate!,
                          endDate!, subjectInfo['times'])
                      .then((_) async {
                    Navigator.pop(context);
                    await Provider.of<SubjectsViewModel>(context, listen: false)
                        .getSubjectsByInstructorId(context);
                  });
                } catch (e) {
                  showSnackbar(context,
                      const Snackbar(content: Text('Something went wrong!')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  List _getSelectedDays(List weekDays) {
    return weekDays
        .where((day) {
          return day['isChecked'] == true;
        })
        .toList()
        .map((e) => e['name'])
        .toList();
  }

  bool _checkSubjectInfo(BuildContext context,
      {required String subName,
      required List weekDays,
      required List times,
      required List dates}) {
    if (subName.isEmpty) {
      showSnackbar(
          context, const Snackbar(content: Text('You must insert a name')));
      return false;
    }
    List selectedDays = _getSelectedDays(weekDays);
    if (selectedDays.isEmpty) {
      showSnackbar(
          context, const Snackbar(content: Text('You must choose a day')));
      return false;
    }
    if (times[0] == null) {
      showSnackbar(context,
          const Snackbar(content: Text('You must choose a start time')));
      return false;
    }
    if (times[1] == null) {
      showSnackbar(
          context, const Snackbar(content: Text('You must choose a end time')));
      return false;
    }
    if (dates[0] == null) {
      showSnackbar(context,
          const Snackbar(content: Text('You must choose a start date')));
      return false;
    }
    if (dates[1] == null) {
      showSnackbar(
          context, const Snackbar(content: Text('You must choose a end date')));
      return false;
    }
    return true;
  }

  Future<void> deleteSubject(
      BuildContext context, String subjectId, String subjectName) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          title: const Text('Are you sure?'),
          content: RichText(
            text: TextSpan(
              text: 'You want to delete ',
              children: [
                TextSpan(
                    text: subjectName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ' ?'),
              ],
            ),
          ),
          actions: [
            Button(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FilledButton(
              child: const Text('Yes'),
              onPressed: () async {
                final NavigatorState navigator = Navigator.of(context);
                final DashboardViewModel dashProvider =
                    Provider.of<DashboardViewModel>(context, listen: false);
                final SubjectsViewModel subProvider =
                    Provider.of<SubjectsViewModel>(context, listen: false);
                String instructorId =
                    Provider.of<AuthViewModel>(context, listen: false)
                        .user!
                        .instructorId!;
                try {
                  Provider.of<SubjectsViewModel>(context,listen: false).subjects.clear();
                  await subjectModel.deleteSubject(subjectId, instructorId);

                  await lectureModel.deleteLecturesBySubject(
                      subjectId, instructorId);
                  await lectureAttendanceModel
                      .deleteAttendanceBySubject(subjectId, instructorId)
                      .then((_) async {
                    dashProvider.clearLectureInfo();
                    navigator.pop();
                    await subProvider.getSubjectsByInstructorId(context);
                  });
                  
                } catch (e) {
                  showSnackbar(
                      context,
                      const Snackbar(
                          content: Text('Something went wrong. Try again.')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic> subjects = {};
  bool isLoading = true;

  Future<void> getSubjectsByInstructorId(BuildContext context) async {
    if(subjects.isNotEmpty){
      return;
    }
    isLoading = true;
    notifyListeners();
    String instructorId =
        Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
    http.Response res =
        await subjectModel.getSubjectsByInstructorId(instructorId);
    subjects = jsonDecode(res.body) ?? <String, dynamic>{};
    isLoading = false;
    notifyListeners();
  }

  Future getSubjectAttendance(String subId, BuildContext context) async {
    try {
      final String insId = Provider.of<AuthViewModel>(context, listen: false)
          .user!
          .instructorId!;
      final response =
          await SubjectModel.instance.getSubjectAttendance(subId, insId);
      return jsonDecode(response.body) as Map<String, dynamic>?;
    } catch (_) {
      Components.showErrorSnackBar(context,
          text: 'Something went wrong. try again.');
    }
  }

  Future<void> printSubjectAttendance(BuildContext context, String subId,
      Map<String, dynamic> singleSubject) async {
    final Map<String, dynamic>? att = await getSubjectAttendance(
      subId,
      context,
    );
    if (att == null) return;
    final pdf = pw.Document();
    att.forEach((key, value) {
      final List studentIds = att[key].keys.toList();
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
                      singleSubject['subjectName'],
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 24.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  pw.Text(key),
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
                      for (int i = 0; i < studentIds.length; i++)
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(4.0),
                              child: pw.Text(
                                  att[key][studentIds[i]]['studentName']),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(4.0),
                              child: pw.Text(
                                  att[key][studentIds[i]]['isAttend'] == true
                                      ? 'Attend'
                                      : 'Absent'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              );
            }),
      );
    });

    Directory? output = await path_provider.getDownloadsDirectory();
    output ??= await path_provider.getTemporaryDirectory();
    final file = File("${output.path}/${singleSubject['subjectName']}.pdf");
    await file.writeAsBytes(await pdf.save()).then((value) {
      showSnackbar(
        context,
        Snackbar(
          content: Text(
            'File download to ${value.path}',
          ),
          extended: true,
        ),
      );
    });
  }

  Future<void> changeSubjectName(BuildContext context,String subId,String subName)async{
    final NavigatorState navigator = Navigator.of(context);
    showDialog(context: context, builder: (context){
      TextEditingController controller = TextEditingController(text: subName);
      return ContentDialog(
        title: const Text('Edit subject name'),
        content: TextBox(
          controller: controller,
          header: 'Enter subject name',
        ),
        actions: [
          Button(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FilledButton(
            child: const Text('Update'),
            onPressed: () async {
              String insId = Provider.of<AuthViewModel>(context,listen: false).user!.instructorId!;
              final SubjectsViewModel subProvider =
              Provider.of<SubjectsViewModel>(context, listen: false);
              try{
                Provider.of<SubjectsViewModel>(context,listen: false).subjects.clear();
                await subjectModel.changeSubjectName(subId, insId, controller.text.trim()).then((_) async{
                  navigator.pop();
                  await subProvider.getSubjectsByInstructorId(context);
                });
              }catch(_){
                Components.showErrorSnackBar(context, text: 'Try again.');
              }

            },
          ),
        ],
      );
    });
  }

}
