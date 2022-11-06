import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../view_model/lecture_attendance_view_model.dart';
import '../widgets/row_data.dart';

class LectureAttendanceView extends StatelessWidget {
  const LectureAttendanceView({super.key});
  static const String routeName = '/lecture_attendance';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> lectureData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final attendaceProvider =
        Provider.of<LecturesAttendanceViewModel>(context, listen: false);
    return NavigationView(
      appBar: NavigationAppBar(title: Text(lectureData['Lecture name'])),
      content: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ProgressRing());
          }
          if (attendaceProvider.attendance.isEmpty) {
            return Expanded(
              child: Center(
                child: Text(
                  "There's no attendance for ${lectureData['Lecture name']} lecture.",
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBox(
                header: 'Search for a student:',
                placeholder: 'Name or Student id',
                expands: false,
                onChanged: (value){
                  attendaceProvider.filterBySearch(value);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Student ID",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Student Name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Consumer<LecturesAttendanceViewModel>(
                builder: (context, att, _) {
                  List<String> keyList = att.filterSearch.keys.toList();
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        Map<String, dynamic> singleAtt =
                            att.filterSearch[keyList[index]];
                        return Row(
                          children: [
                            RowData(singleAtt['studentId']),
                            RowData(singleAtt['studentName']),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: att.filterSearch.length,
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
