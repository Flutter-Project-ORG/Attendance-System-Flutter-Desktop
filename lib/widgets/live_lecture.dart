import 'dart:math';

import 'package:attendance_system_flutter_desktop/view_model/auth_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../view_model/dashboard_view_model.dart';
import '../view_model/lecture_attendance_view_model.dart';
import '../views/lecture_attendance_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
                        Navigator.of(context).pushNamed(
                            LectureAttendanceView.routeName,
                            arguments: {
                              "subId": dashProvider.lectureInfo['subId'],
                              "lecId": dashProvider.lectureInfo['lecId']
                            });
                      },
                      title: Text(dashProvider.lectureInfo['lecId']),
                      subtitle: Text(dashProvider.lectureInfo['subName']),
                      trailing: FilledButton(
                        onPressed: () async {
                          try{
                            await Provider.of<LecturesAttendanceViewModel>(
                              context,
                              listen: false,
                            ).addAttendanceList(
                              dashProvider.lectureInfo['subId'],
                              dashProvider.lectureInfo['lecId'],
                              context,
                            );
                            final String insId =
                            Provider.of<AuthViewModel>(context, listen: false)
                                .user!
                                .instructorId!;

                            dashProvider.showAttendanceQr(
                              context,
                              "$insId/${dashProvider.lectureInfo['subId']}/${dashProvider.lectureInfo['lecId']}",
                              dashProvider.lectureInfo['lecId'],
                            );
                          }catch(e){
                            if(e.toString() == 'There is no students for that subject.'){
                              showSnackbar(context,  Snackbar(content: Text(e.toString())));
                              return;
                            }
                            showSnackbar(context, const Snackbar(content: Text('Something went wrong!')));
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, int index) {
                          return Container(
                            height: 40,
                            color: Colors.red,
                          );
                        },
                      ),
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
