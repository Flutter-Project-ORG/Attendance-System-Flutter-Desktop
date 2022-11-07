import 'package:attendance_system_flutter_desktop/views/auth_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../view_model/home_view_model.dart';
import 'dashboard_view.dart';
import 'subjects_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel homeProvider, _) {
        return NavigationView(
          appBar: const NavigationAppBar(
            automaticallyImplyLeading: false,
            title: Text("Home"),
          ),
          pane: NavigationPane(
            selected: homeProvider.pageIndex,
            onChanged: (int value) {
              homeProvider.setPageIndex = value;
            },
            displayMode: PaneDisplayMode.auto,
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.view_dashboard),
                title: const Text('Dashboard'),
                body: const DashboardView(),
              ),
              PaneItem(
                icon: const FaIcon(FontAwesomeIcons.tableList),
                title: const Text('Subjects'),
                body: const SubjectsView(),
              ),
              PaneItem(
                onTap: () {
                  homeProvider.setPageIndex = 0;
                  homeProvider.logOut();
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
