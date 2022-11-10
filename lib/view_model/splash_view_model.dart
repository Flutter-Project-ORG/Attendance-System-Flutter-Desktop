import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../models/instructor_model.dart';
import '../views/auth_view.dart';
import '../views/home_view.dart';
import 'auth_view_model.dart';

class SplashViewModel{


  Future<void> getInitData(BuildContext context)async{
    final AuthViewModel authProvider = Provider.of<AuthViewModel>(context,listen: false);
    final NavigatorState navigator = Navigator.of(context);
    InstructorModel? instructorModel = await InstructorModel.instance.getAuthData();
    if (instructorModel != null) {
      authProvider.setUser = instructorModel;
      navigator.pushReplacementNamed(HomeView.routeName);
      return;
    }
    navigator.pushReplacementNamed(AuthView.routeName);
  }

}