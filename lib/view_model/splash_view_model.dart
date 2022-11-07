import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../models/instructor_model.dart';
import '../views/auth_view.dart';
import '../views/home_view.dart';
import 'auth_view_model.dart';

class SplashViewModel{


  Future<void> getInitData(BuildContext context)async{
    InstructorModel? instructorModel = await InstructorModel.instance.getAuthData();
    if (instructorModel != null) {
      Provider.of<AuthViewModel>(context,listen: false).setUser = instructorModel;
      Navigator.of(context).pushReplacementNamed(HomeView.routeName);
      return;
    }
    Navigator.of(context).pushReplacementNamed(AuthView.routeName);
  }

}