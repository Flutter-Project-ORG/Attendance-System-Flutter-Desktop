import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';

class AttendanceQrProvider with ChangeNotifier {
  int randomNum = Random().nextInt(100000) + 10000;
  void changeRandomNum() {
    randomNum = Random().nextInt(100000) + 10000;
    notifyListeners();
  }
}