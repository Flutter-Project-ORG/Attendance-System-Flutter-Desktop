import 'package:attendance_system_flutter_desktop/view_model/dashboard_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await Provider.of<DashboardViewModel>(context,listen: false).getLiveSubject(context);
    });
    super.initState();
  }

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
            Row(
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
            ),
            Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Text('Card 2'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Text('Card 2'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
