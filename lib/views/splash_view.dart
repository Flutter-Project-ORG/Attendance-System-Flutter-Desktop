import 'package:attendance_system_flutter_desktop/view_model/auth_view_model.dart';
import 'package:attendance_system_flutter_desktop/views/auth_view.dart';
import 'package:attendance_system_flutter_desktop/views/home_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/instructor_model.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static const routeName = '/splash';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  late SplashViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SplashViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.getInitData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: GlowingProgressIndicator(
          child: Image.asset(
            'assets/images/logo.png',
            scale: 4,
          ),
        ),
      ),
    );
  }
}
