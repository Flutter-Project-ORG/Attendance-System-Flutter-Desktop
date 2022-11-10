import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';

import '../res/constants.dart';

import 'package:http/http.dart' as http;

class AttendanceQrViewModel with ChangeNotifier {
  int randomNum = Random().nextInt(100000) + 10000;
  Future<void> changeRandomNum(String lecId) async{
    randomNum = Random().nextInt(100000) + 10000;
    await _addRandomToDB(lecId);
    notifyListeners();
  }

  Future _addRandomToDB(String lecId)async{
    Uri url = Uri.parse('${Constants.realtimeUrl}/lectures-temp/$lecId.json');
    await http.put(
      url,
      body: randomNum.toString(),
    );
  }

  Future deleteRandomFromDB(String lecId)async{
    Uri url = Uri.parse('${Constants.realtimeUrl}/lectures-temp/$lecId.json');
    await http.delete(
      url,
    );
  }

}