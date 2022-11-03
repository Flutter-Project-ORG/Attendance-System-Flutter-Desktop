import 'package:fluent_ui/fluent_ui.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Text(
        "Dashboard",
      ),
      content: Center(
        child: Text("Welcome to Page 1!"),
      ),
    );
  }
}
