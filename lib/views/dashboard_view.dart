import 'package:attendance_system_flutter_desktop/view_model/dashboard_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
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
        header: const Text(
          "Dashboard",
        ),
        content: Column(
          children: [
            Expanded(
              child: Row(
                children:  const[
                   LatestNews(),
                   SizedBox(width: 8.0,),
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Text('Card 1'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0,),
            Expanded(
              child: Row(
                children:  [
                  const LiveLecture(),
                  Expanded(
                    flex: 1,
                    child: Image.asset('assets/images/logo.png'),
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
