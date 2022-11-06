import 'package:attendance_system_flutter_desktop/views/lecture_attendance_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../view_model/lectures_view_model.dart';

class LecturesView extends StatefulWidget {
  const LecturesView({Key? key}) : super(key: key);

  static const String routeName = '/lectures';

  @override
  State<LecturesView> createState() => _LecturesViewState();
}

class _LecturesViewState extends State<LecturesView> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> subject =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final lectureProvider =
        Provider.of<LecturesViewModel>(context, listen: false);
    return NavigationView(
      appBar: NavigationAppBar(
        title: Text(subject['subName']!),
      ),
      content: FutureBuilder(
        future: lectureProvider.getLecturesBySubjectId(
          subject['subId']!,
          context
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ProgressRing());
          }
          if (lectureProvider.lectures.isEmpty) {
            return const Center(
              child: Text('You don\'t have any lecture for that subject yet.'),
            );
          }
          List<dynamic> lectures = lectureProvider.lectures;
          return GridView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: lectures.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240.0,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, LectureAttendanceView.routeName,arguments: {
                    "lecId" : lectures[index],
                    "subId" : subject['subId'],
                  });
                },
                child: Card(
                  child: Text(lectures[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
