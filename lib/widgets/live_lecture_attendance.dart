import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../view_model/lecture_attendance_view_model.dart';
import '../widgets/is_attend_drop.dart';

class LiveLectureAttendance extends StatelessWidget {
  final String? lecId, subId;
  const LiveLectureAttendance({super.key, this.lecId, this.subId});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<LecturesAttendanceViewModel>(
        builder: (context, att, _) => FutureBuilder(
          future: att.getAttendanceByLectureIdAndSubjectId(
            subId!,
            lecId!,
            context,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: ProgressRing(),
              );
            }
            List<String> keyList = att.attendance.keys.toList();
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: att.attendance.length,
              itemBuilder: (context, int index) {
                Map<String, dynamic> singleAtt = att.attendance[keyList[index]];
                return ListTile(
                  title: Text(singleAtt['studentName']),
                  trailing: IsAttendDrop(
                    singleAtt['isAttend'],
                    {
                      "studentId": keyList[index],
                      "subId": subId!,
                      "lecId": lecId!,
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
