import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../models/instructor_model.dart';
import 'subjects_view_model.dart';
import 'dashboard_view_model.dart';

class HomeViewModel with ChangeNotifier{

  int pageIndex = 0;
  set setPageIndex(int newValue){
    pageIndex = newValue;
    notifyListeners();
  }


  Future logOut(BuildContext context)async{
    Provider.of<SubjectsViewModel>(context,listen: false).subjects.clear();
    Provider.of<DashboardViewModel>(context,listen: false).clearLectureInfo();
    await InstructorModel.instance.logOut();
  }

}