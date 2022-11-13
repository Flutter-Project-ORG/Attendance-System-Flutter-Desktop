import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../view_model/lecture_attendance_view_model.dart';
import '../widgets/is_attend_drop.dart';
import '../res/custom_text_theme.dart';

class LectureAttendanceView extends StatelessWidget {
  const LectureAttendanceView({super.key});

  static const String routeName = '/lecture_attendance';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> lectureData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final attendanceProvider =
        Provider.of<LecturesAttendanceViewModel>(context, listen: false);
    return FutureBuilder(
        future: attendanceProvider.getAttendanceByLectureIdAndSubjectId(
          lectureData['subId']!,
          lectureData['lecId']!,
          context,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return NavigationView(
              appBar: NavigationAppBar(
                title: Text(
                  "${lectureData['subName']} (${lectureData['lecId']!})",
                  style: CustomTextTheme.header2,
                ),
              ),
              content: const Center(child: ProgressRing()),
            );
          }
          if (attendanceProvider.attendance.isEmpty) {
            return NavigationView(
              appBar: NavigationAppBar(
                title: Text(
                  "${lectureData['subName']} (${lectureData['lecId']!})",
                  style: CustomTextTheme.header2,
                ),
              ),
              content: Center(
                child: Text(
                  "There's no attendance for ${lectureData['lecId']!} lecture.",
                ),
              ),
            );
          }
          return NavigationView(
            appBar: NavigationAppBar(
              title: Text(
                "${lectureData['subName']} (${lectureData['lecId']!})",
                style: CustomTextTheme.header2,
              ),
              actions: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                      child: const Text('Print attendance'),
                      onPressed: () async {
                        await attendanceProvider.printLectureAttendance(
                          context,
                          lectureData,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            content: FutureBuilder(
              future: attendanceProvider.getAttendanceByLectureIdAndSubjectId(
                lectureData['subId']!,
                lectureData['lecId']!,
                context,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: ProgressRing());
                }
                if (attendanceProvider.attendance.isEmpty) {
                  return Center(
                    child: Text(
                      "There's no attendance for ${lectureData['lecId']!} lecture.",
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 64.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBox(
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(FluentIcons.search_art64),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        headerStyle: CustomTextTheme.body1,
                        header: 'Search for a student:',
                        placeholder: 'Name of Student',
                        expands: false,
                        onChanged: (value) {
                          attendanceProvider.filterBySearch(value);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Table(
                        border: TableBorder.all(
                          //color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8.0)),
                        ),
                        children: const [
                          TableRow(
                            children: [
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    "Student Name",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "Attendance",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Consumer<LecturesAttendanceViewModel>(
                        builder: (context, att, _) {
                          List<String> keyList = att.filterSearch.keys.toList();
                          return Table(
                            border: TableBorder.all(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(8.0),
                              ),
                            ),
                            children: keyList.map<TableRow>((e) {
                              Map<String, dynamic> singleAtt =
                                  att.filterSearch[e];
                              return TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        singleAtt['studentName'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: IsAttendDrop(
                                        singleAtt['isAttend'],
                                        {
                                          "studentId": e,
                                          "subId": lectureData['subId']!,
                                          "lecId": lectureData['lecId']!,
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}
