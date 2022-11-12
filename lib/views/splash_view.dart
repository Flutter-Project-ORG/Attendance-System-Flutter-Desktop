import 'package:attendance_system_flutter_desktop/res/custom_text_theme.dart';
import 'package:attendance_system_flutter_desktop/widgets/project_name_animation.dart';
import 'package:fluent_ui/fluent_ui.dart';
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
        child: ProjectNameAnimation(
          textStyle: CustomTextTheme.projectNameAuth,
        ),
      ),
    );
  }
}
