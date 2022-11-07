import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../view_model/dashboard_view_model.dart';
import '../view_model/lecture_attendance_view_model.dart';

class LiveLecture extends StatefulWidget {
  const LiveLecture({Key? key}) : super(key: key);

  @override
  State<LiveLecture> createState() => _LiveLectureState();
}

class _LiveLectureState extends State<LiveLecture> {
  late Future _getLiveLecture;

  final DashboardViewModel _viewModel = DashboardViewModel();

  @override
  void initState() {
    _getLiveLecture = _viewModel.getLiveSubject(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final dashProvider = Provider.of<DashboardViewModel>(context, listen: false);
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
                      title: Text(dashProvider.lectureInfo['lecId']),
                      subtitle: Text(dashProvider.lectureInfo['subName']),
                      trailing: FilledButton(
                        onPressed: (){
                          Provider.of<LecturesAttendanceViewModel>(context,listen: false).addAttendanceList(dashProvider.lectureInfo['subId'], dashProvider.lectureInfo['lecId'],context);
                        },
                        child: const Text('Take Attendance'),
                      ),
                    ),
                    const SizedBox(height: 16,child: Center(child: Divider(),),),
                    Expanded(
                      child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context,int index){
                        return Container(
                          height: 40,
                          color: Colors.red,
                        );
                      },),
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

