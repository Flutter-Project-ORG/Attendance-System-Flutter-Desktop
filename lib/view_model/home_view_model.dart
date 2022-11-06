import 'package:fluent_ui/fluent_ui.dart';

class HomeViewModel with ChangeNotifier{

  int pageIndex = 0;
  set setPageIndex(int newValue){
    pageIndex = newValue;
    notifyListeners();
  }

}