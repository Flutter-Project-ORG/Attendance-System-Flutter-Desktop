import 'dart:convert';
import '../models/subject_model.dart';
import '../models/lecture_model.dart';
import '../models/lecture_attendance_model.dart';
import 'auth_view_model.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SubjectsViewModel with ChangeNotifier {
  SubjectModel subjectModel = SubjectModel.instance;
  LectureModel lectureModel = LectureModel.instance;
  LectureAttendanceModel lectureAttendanceModel = LectureAttendanceModel.instance;

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
                          showSnackbar(context, const Snackbar(content: Text('You cannot add more than two times')));
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
                /// For Test
                // try{
                //   time1 = {
                //     'days': ['sunday','tuesday','thursday'],
                //     'start': DateTime(2022,11,5,8,5).toIso8601String(),
                //     'end': DateTime(2022,12,5,10,5).toIso8601String(),
                //   };
                //   time2 = {
                //     'days': ['monday','wednesday'],
                //     'start': DateTime(2022,11,5,8,5).toIso8601String(),
                //     'end': DateTime(2022,12,5,10,5).toIso8601String(),
                //   };
                //   subjectInfo['subjectName'] = 'Test';
                //   subjectInfo['startDate'] = DateTime(2022,11,5).toIso8601String();
                //   subjectInfo['endDate'] = DateTime(2022,12,5).toIso8601String();
                //   subjectInfo['times'] = {
                //     'time1': time1,
                //     'time2': time2,
                //   };
                //   String instructorId = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
                //   String subId = await subjectModel.addSubject(instructorId, subjectInfo);
                //   await lectureModel.addLecturesBySubject(instructorId, subId,DateTime(2022,11,5),DateTime(2022,12,5),subjectInfo['times']).then((_) async {
                //     Navigator.pop(context);
                //     await Provider.of<SubjectsViewModel>(context, listen: false).getSubjectsByInstructorId(context);
                //   });
                // }catch(e){
                //   print('catch: $e');
                // }
                //
                // return;

                /// My Real Code
                if (!_checkSubjectInfo(context,
                    subName: controller.text,
                    weekDays: weekDays,
                    times: [startTime, endTime],
                    dates: [startDate, endDate])) {
                  return;
                }
                String instructorId = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
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
                  String subId = await subjectModel.addSubject(instructorId, subjectInfo);
                  await lectureModel
                      .addLecturesBySubject(instructorId, subId, startDate!, endDate!, subjectInfo['times'])
                      .then((_) async {
                    Navigator.pop(context);
                    await Provider.of<SubjectsViewModel>(context, listen: false).getSubjectsByInstructorId(context);
                  });
                } catch (e) {
                  showSnackbar(context, const Snackbar(content: Text('Something went wrong!')));
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
      {required String subName, required List weekDays, required List times, required List dates}) {
    if (subName.isEmpty) {
      showSnackbar(context, const Snackbar(content: Text('You must insert a name')));
      return false;
    }
    List selectedDays = _getSelectedDays(weekDays);
    if (selectedDays.isEmpty) {
      showSnackbar(context, const Snackbar(content: Text('You must choose a day')));
      return false;
    }
    if (times[0] == null) {
      showSnackbar(context, const Snackbar(content: Text('You must choose a start time')));
      return false;
    }
    if (times[1] == null) {
      showSnackbar(context, const Snackbar(content: Text('You must choose a end time')));
      return false;
    }
    if (dates[0] == null) {
      showSnackbar(context, const Snackbar(content: Text('You must choose a start date')));
      return false;
    }
    if (dates[1] == null) {
      showSnackbar(context, const Snackbar(content: Text('You must choose a end date')));
      return false;
    }
    return true;
  }

  Future<void> deleteSubject(BuildContext context, String subjectId, String subjectName) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          title: const Text('Are you sure?'),
          content: RichText(
            text: TextSpan(
              text: 'You want to delete ',
              children: [
                TextSpan(text: subjectName, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                String instructorId = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
                try {
                  await subjectModel.deleteSubject(subjectId, instructorId);
                  await lectureModel.deleteLecturesBySubject(subjectId, instructorId);
                  await lectureAttendanceModel.deleteAttendanceBySubject(subjectId, instructorId);
                  Navigator.pop(context);
                  await Provider.of<SubjectsViewModel>(context, listen: false).getSubjectsByInstructorId(context);
                } catch (e) {
                  showSnackbar(context, const Snackbar(content: Text('Something went wrong. Try again.')));
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
    isLoading = true;
    notifyListeners();
    String instructorId = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
    http.Response res = await subjectModel.getSubjectsByInstructorId(instructorId);
    subjects = jsonDecode(res.body) ?? <String, dynamic>{};
    isLoading = false;
    notifyListeners();
  }
}
