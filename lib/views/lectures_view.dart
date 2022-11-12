import 'package:attendance_system_flutter_desktop/views/lecture_attendance_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../res/custom_text_theme.dart';
import '../view_model/lectures_view_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class LecturesView extends StatefulWidget {
  const LecturesView({Key? key}) : super(key: key);

  static const String routeName = '/lectures';

  @override
  State<LecturesView> createState() => _LecturesViewState();
}

class _LecturesViewState extends State<LecturesView> {
  String _getDay(String date) {
    String? day;
    int dayNum = DateFormat.d('en_US').parse(date.replaceAll('-', '/')).weekday;
    switch (dayNum) {
      case 7:
        {
          day = "Sunday";
        }
        break;
      case 6:
        {
          day = "Saturday";
        }
        break;
      case 5:
        {
          day = "Friday";
        }
        break;
      case 4:
        {
          day = "Thursday";
        }
        break;
      case 3:
        {
          day = "Wednesday";
        }
        break;
      case 2:
        {
          day = "Tuesday";
        }
        break;
      case 1:
        {
          day = "Monday";
        }
        break;
    }
    return day!;
  }

  bool _isFinished(String date) {
    final DateTime lecDate = DateFormat.yMd().parse(date.replaceAll('-', '/'));
    final DateTime nowDate = DateTime.now().toLocal();
    if (nowDate.year > lecDate.year ||
        (nowDate.year == lecDate.year && nowDate.month > lecDate.day) ||
        (nowDate.year == lecDate.year &&
            nowDate.month == lecDate.day &&
            nowDate.day > lecDate.month)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> subject =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final lectureProvider =
        Provider.of<LecturesViewModel>(context, listen: false);
    return NavigationView(
      appBar: NavigationAppBar(
        title: Text(
          subject['subName']!,
          style: CustomTextTheme.header2,
        ),
      ),
      content: FutureBuilder(
        future:
            lectureProvider.getLecturesBySubjectId(subject['subId']!, context),
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
          return AnimationLimiter(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: lectures.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: (index / lectures.length).floor(),
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, LectureAttendanceView.routeName,
                              arguments: {
                                "lecId": lectures[index],
                                "subId": subject['subId'],
                                "subName": subject['subName']
                              });
                        },
                        child: Card(
                          //backgroundColor: _colors[index % _colors.length].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(lectures[index]),
                                subtitle: Text(_getDay(lectures[index])),
                                trailing: _isFinished(lectures[index])
                                    ? const Chip(
                                        text: Text(
                                          "Finished",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
