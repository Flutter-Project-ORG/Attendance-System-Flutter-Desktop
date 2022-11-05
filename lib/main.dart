import 'package:attendance_system_flutter_desktop/view_model/lectures_view_model.dart';
import 'package:attendance_system_flutter_desktop/view_model/subjects_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'res/colors.dart';
import 'view_model/auth_view_model.dart';
import 'view_model/home_view_model.dart';
import 'views/auth_view.dart';
import 'views/home_view.dart';
import 'views/lectures_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubjectsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LecturesViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      // initialRoute: AuthView.routeName,
      initialRoute: HomeView.routeName,
      routes: {
        AuthView.routeName: (_) => AuthView(),
        HomeView.routeName: (_) => const HomeView(),
        LecturesView.routeName: (_) => const LecturesView(),
      },
    );
  }
}
