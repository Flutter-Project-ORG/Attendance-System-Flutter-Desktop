import 'package:attendance_system_flutter_desktop/views/auth_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/instructor_model.dart';
import '../view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel provider, _) {
        return NavigationView(
          appBar: const NavigationAppBar(
            automaticallyImplyLeading: false,
            title: Text("Home"),
          ),
          pane: NavigationPane(
            selected: provider.pageIndex,
            onChanged: (int value) {
              provider.setPageIndex = value;
            },
            displayMode: PaneDisplayMode.auto,
            items: [
              PaneItem(
                icon: const FaIcon(FontAwesomeIcons.chartLine),
                title: const Text('Dashboard'),
                body: const ScaffoldPage(
                  header: Text(
                    "Dashboard",
                  ),
                  content: Center(
                    child: Text("Welcome to Page 1!"),
                  ),
                ),
              ),
              PaneItem(
                icon: const FaIcon(FontAwesomeIcons.tableList),
                title: const Text('Subjects'),
                body: const ScaffoldPage(
                  header: Text(
                    "Subjects",
                  ),
                  content: Center(
                    child: Text("Welcome to Page 2!"),
                  ),
                ),
              ),
              PaneItem(
                onTap: (){
                  provider.setPageIndex = 0;
                  Navigator.pushReplacementNamed(context, AuthView.routeName);
                },
                icon: FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                body: Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
