import 'package:flutter/services.dart';

import 'view_model/dashboard_view_model.dart';
import 'view_model/lectures_view_model.dart';
import 'view_model/subjects_view_model.dart';
import 'view_model/auth_view_model.dart';
import 'view_model/home_view_model.dart';
import 'view_model/lecture_attendance_view_model.dart';
import 'views/home_view.dart';
import 'views/auth_view.dart';
import 'views/lectures_view.dart';
import 'views/lecture_attendance_view.dart';
import './views/splash_view.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import './external_providers/attendance_qr_provider.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  //WindowManager _windowManager = WindowManager.instance;
  windowManager.setTitle('Student Attendance');
  windowManager.waitUntilReadyToShow().then((_) async {
    // Set to frameless window
    Size size = await windowManager.getSize();
    await windowManager.setMinimumSize(Size(540.0, size.height * 0.90));
    // await windowManager.setMaximumSize(Size(size.width, size.height * 0.95),);
    windowManager.show();
  });
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
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LecturesAttendanceViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AttendanceQrProvider(),
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
      initialRoute: SplashView.routeName,
      // initialRoute: AuthView.routeName,
      // initialRoute: HomeView.routeName,
      routes: {
        AuthView.routeName: (_) => AuthView(),
        HomeView.routeName: (_) => const HomeView(),
        LecturesView.routeName: (_) => const LecturesView(),
        LectureAttendanceView.routeName : (_) => const LectureAttendanceView(),
        SplashView.routeName :(_) => const SplashView(),
      },
    );
  }
}
