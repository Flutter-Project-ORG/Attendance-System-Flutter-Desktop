import 'dart:convert';

import 'package:attendance_system_flutter_desktop/models/subject_model.dart';
import 'package:attendance_system_flutter_desktop/view_model/auth_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SubjectsViewModel with ChangeNotifier {
  Future<void> addSubject(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return ContentDialog(
          title: const Text('Add New Subject'),
          content: TextBox(
            controller: controller,
            header: 'Enter subject name',
            placeholder: 'Subject name',
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
                String instructorId = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
                try {
                  await SubjectModel().addSubject(controller.text, instructorId).then((_) async {
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
                String instructorId = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
                try {
                  await SubjectModel().deleteSubject(subjectId, instructorId).then((_) async {
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
    String instructorId = Provider.of<AuthViewModel>(context, listen: false).user!.instructorId!;
    http.Response res = await SubjectModel().getSubjectsByInstructorId(instructorId);
    subjects = jsonDecode(res.body) ?? <String, dynamic>{};
    isLoading = false;
    notifyListeners();
  }
}
