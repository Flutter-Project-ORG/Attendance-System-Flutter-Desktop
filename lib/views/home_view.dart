import 'package:attendance_system_flutter_desktop/views/auth_view.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../view_model/home_view_model.dart';
import 'dashboard_view.dart';
import 'subjects_view.dart';
import 'profile_view.dart';
import '../view_model/dashboard_view_model.dart';

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
                icon: const FaIcon(FontAwesomeIcons.user),
                title: const Text('Profile'),
                trailing: Tooltip(
                  message: 'Logout',
                  child: IconButton(
                    icon: const Icon(FluentIcons.sign_out,),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ContentDialog(
                          title: const Text("Logout"),
                          content: const Text("Are you sure to logout ?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                homeProvider.setPageIndex = 0;
                                homeProvider.logOut(context);
                                Navigator.pushReplacementNamed(
                                    context, AuthView.routeName);
                                Provider.of<DashboardViewModel>(context,
                                        listen: false)
                                    .clearLectureInfo();
                              },
                              child: const Text("YES"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("NO"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                body: const ProfileView(),
              ),
            ],
          ),
        );
      },
    );
  }
}
