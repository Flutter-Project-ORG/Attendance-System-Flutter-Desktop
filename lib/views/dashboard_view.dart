import 'package:attendance_system_flutter_desktop/res/custom_text_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScaffoldPage(
        content: Column(
          children: [
            Expanded(
              child: Row(
                children: const [
                  LatestNews(),
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
                  const SizedBox(width: 20,),
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
