import 'dart:convert';

import 'package:attendance_system_flutter_desktop/models/subject_model.dart';
import 'package:attendance_system_flutter_desktop/view_model/auth_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SubjectsViewModel with ChangeNotifier {
  SubjectModel subjectModel = SubjectModel.instance;

  Future<void> addSubject(BuildContext context) async {
    DateTime? startTime;
    DateTime? endTime;
    List weekDays = [
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
                    const SizedBox(width: 8.0,),
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
                if (controller.text.isEmpty) {
                  showSnackbar(context, const Snackbar(content: Text('You must insert a name')));
                  return;
                }
                List selectedDays = weekDays.where((day) {
                  return day['isChecked'] == true;
                }).toList().map((e) => e['name']).toList();
                if(selectedDays.isEmpty){
                  showSnackbar(context, const Snackbar(content: Text('You must choose a day')));
                  return;
                }
                if(startTime == null){
                  showSnackbar(context, const Snackbar(content: Text('You must choose a start day')));
                  return;
                }
                if(endTime == null){
                  showSnackbar(context, const Snackbar(content: Text('You must choose a end day')));
                  return;
                }
                String instructorId = Provider
                    .of<AuthViewModel>(context, listen: false)
                    .user!
                    .instructorId!;
                try {
                  await subjectModel.addSubject(controller.text, instructorId,selectedDays,startTime!.toIso8601String(),endTime!.toIso8601String()).then((_) async {
                    Navigator.pop(context);
                    await Provider.of<SubjectsViewModel>(context, listen: false).getSubjectsByInstructorId(context);
                  });
                } catch (e) {
                  showSnackbar(context, Snackbar(content: Text(e.toString())));
                }
              },
            ),
          ],
        );
      },
    );
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
                String instructorId = Provider
                    .of<AuthViewModel>(context, listen: false)
                    .user!
                    .instructorId!;
                try {
                  await subjectModel.deleteSubject(subjectId, instructorId).then((_) async {
                    Navigator.pop(context);
                    await Provider.of<SubjectsViewModel>(context, listen: false).getSubjectsByInstructorId(context);
                  });
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
    String instructorId = Provider
        .of<AuthViewModel>(context, listen: false)
        .user!
        .instructorId!;
    http.Response res = await subjectModel.getSubjectsByInstructorId(instructorId);
    subjects = jsonDecode(res.body) ?? <String, dynamic>{};
    isLoading = false;
    notifyListeners();
  }
}
