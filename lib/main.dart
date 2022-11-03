import 'package:attendance_system_flutter_desktop/view_model/home_view_model.dart';
import 'package:attendance_system_flutter_desktop/views/auth_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'res/colors.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
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
      initialRoute:  AuthView.routeName,
      routes: {
        AuthView.routeName:(_) => const AuthView(),
        HomeView.routeName:(_) => const HomeView(),
      },
    );
  }
}
