import 'package:fluent_ui/fluent_ui.dart';

import '../models/instructor_model.dart';

class HomeViewModel with ChangeNotifier{

  int pageIndex = 0;
  set setPageIndex(int newValue){
    pageIndex = newValue;
    notifyListeners();
  }


  Future logOut()async{
    await InstructorModel.instance.logOut();
  }

}