import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../view_model/dashboard_view_model.dart';
import '../view_model/lecture_attendance_view_model.dart';
import '../views/attendance_qr_view.dart';
import '../views/lecture_attendance_view.dart';
import '../view_model/auth_view_model.dart';
import '../widgets/live_lecture_attendance.dart';

class LiveLecture extends StatefulWidget {
  const LiveLecture({Key? key}) : super(key: key);

  @override
  State<LiveLecture> createState() => _LiveLectureState();
}

class _LiveLectureState extends State<LiveLecture> {
  late Future _getLiveLecture;

  @override
  void initState() {
    _getLiveLecture = Provider.of<DashboardViewModel>(context, listen: false)
        .getLiveSubject(context);
    // _getLiveLecture = Future.delayed(Duration.zero);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dashProvider =
        Provider.of<DashboardViewModel>(context, listen: false);
    return Expanded(
      flex: 2,
      child: SizedBox(
        child: Card(
          child: FutureBuilder(
            future: _getLiveLecture,
            builder: (context, snapshot) {
              if (dashProvider.isLoadingLiveLecture) {
                return const Center(
                  child: ProgressRing(),
                );
              }
              if (dashProvider.lectureInfo.isNotEmpty) {
                return Column(
                  children: [
                    ListTile(
                      onPressed: () {
                        //print(dashProvider.lectureInfo['lecId']);
                        Navigator.of(context).pushNamed(
                            LectureAttendanceView.routeName,
                            arguments: {
                              "subId": dashProvider.lectureInfo['subId'],
                              "lecId": dashProvider.lectureInfo['lecId'],
                              "subName" : dashProvider.lectureInfo['subName']
                            });
                      },
                      title: Text(dashProvider.lectureInfo['lecId']),
                      subtitle: Text(dashProvider.lectureInfo['subName']),
                      trailing: FilledButton(
                        onPressed: () async {
                          try {
                            await Provider.of<LecturesAttendanceViewModel>(
                              context,
                              listen: false,
                            ).addAttendanceList(
                              dashProvider.lectureInfo['subId'],
                              dashProvider.lectureInfo['lecId'],
                              context,
                            );
                            if (!mounted) return;
                            final String insId = Provider.of<AuthViewModel>(
                              context,
                              listen: false,
                            ).user!.instructorId!;
                            // Provider.of<LecturesAttendanceViewModel>(context,
                            //         listen: false)
                            //     .fetchLiveAttendance = false;
                            Navigator.push(
                              context,
                              FluentPageRoute(
                                builder: (_) => AttendanceQrView(
                                  path:
                                      "$insId/${dashProvider.lectureInfo['subId']}/${dashProvider.lectureInfo['lecId']}",
                                  lecId: dashProvider.lectureInfo['lecId'],
                                  ctx: context,
                                ),
                              ),
                            );
                          } catch (e) {
                            if (e.toString() ==
                                'There is no students for that subject.') {
                              showSnackbar(context,
                                  Snackbar(content: Text(e.toString())));
                              return;
                            }
                            showSnackbar(
                                context,
                                const Snackbar(
                                    content: Text('Something went wrong!')));
                          }
                        },
                        child: const Text('Take Attendance'),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                      child: Center(
                        child: Divider(),
                      ),
                    ),
                    LiveLectureAttendance(
                      lecId: dashProvider.lectureInfo['lecId'],
                      subId: dashProvider.lectureInfo['subId'],
                    ),
                  ],
                );
              }
              return const Center(
                child: Text("No Live"),
              );
            },
          ),
        ),
      ),
    );
  }
}
