import 'package:attendance_system_flutter_desktop/view_model/dashboard_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../widgets/live_lecture.dart';
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
            Expanded(child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Text('Card 1'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Text('Card 1'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Text('Card 1'),
                  ),
                ),
              ],
            ),),
            Expanded(child: Row(
              children: [
                LiveLecture(),
                const Expanded(
                  flex: 1,
                  child: Card(
                    child: Text('Card 2'),
                  ),
                ),
              ],
            ),),
          ],
        ),
      ),
    );
  }
}
