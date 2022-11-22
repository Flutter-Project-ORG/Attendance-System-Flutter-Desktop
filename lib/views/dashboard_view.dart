import 'package:attendance_system_flutter_desktop/res/custom_text_theme.dart';
import 'package:attendance_system_flutter_desktop/view_model/dashboard_view_model.dart';
import 'package:attendance_system_flutter_desktop/view_model/subjects_view_model.dart';
import 'package:attendance_system_flutter_desktop/widgets/execuses.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../widgets/live_lecture.dart';
import '../widgets/latest_news.dart';
import '../widgets/project_name_animation.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final dashProvider =
        Provider.of<DashboardViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScaffoldPage(
        content: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Expanded(
                    //flex: 2,
                    child: LatestNews(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    //flex: 1,
                    child: Card(
                      borderRadius: BorderRadius.circular(10),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Excuses",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: dashProvider
                                  .getSubjectsByInstructorId(context),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: ProgressRing(),
                                  );
                                }

                                List<String> keyList =
                                    snapshot.data!.keys.toList();

                                if (keyList.isEmpty) {
                                  return const Center(
                                    child: Text("There's no subjects yet!"),
                                  );
                                }
                                return ListView.separated(
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> singleSubject =
                                        snapshot.data![keyList[index]];
                                    return ListTile(
                                      leading: const Text("-"),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return Excuses(
                                                subject: singleSubject,
                                                subId: keyList[index],
                                              );
                                            });
                                      },
                                      title: Text(singleSubject['subjectName']),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: keyList.length,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: Row(
                children: [
                  const LiveLecture(),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: ProjectNameAnimation(
                      textStyle: CustomTextTheme.projectNameDash,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
