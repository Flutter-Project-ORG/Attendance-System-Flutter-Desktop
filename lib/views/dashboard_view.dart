import 'package:fluent_ui/fluent_ui.dart';

import '../widgets/live_lecture.dart';
import '../widgets/latest_news.dart';

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
                  Expanded(
                    flex: 1,
                    child: Image.asset('assets/images/login_image.png'),
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
