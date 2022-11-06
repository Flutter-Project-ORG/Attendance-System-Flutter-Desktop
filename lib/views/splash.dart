import 'dart:convert';

import 'package:attendance_system_flutter_desktop/views/home_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../view_model/auth_view_model.dart';
import '../models/instructor_model.dart';
import 'package:http/http.dart' as http;
import '../res/contants.dart';
import 'dart:developer';

class Splash extends StatefulWidget {
  const Splash({super.key});
  static const routeName = '/splash';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final authProvider = Provider.of<AuthViewModel>(context, listen: false);
      final uid = authProvider.user!.instructorId;
      try {
        Uri url = Uri.parse('${Constants.realtimeUrl}/subjects/$uid.json');
        final response = await http.get(url);
        final data = jsonDecode(response.body) == null
            ? {}
            : jsonDecode(response.body) as Map<String, dynamic>;
        log("$data");
        if (data.isNotEmpty) {
          final DateTime date = DateTime.now();
          String? day;
          switch (date.weekday) {
            case 1:
              {
                day = "Monday";
              }
              break;
            case 2:
              {
                day = "Tuesday";
              }
              break;
            case 3:
              {
                day = "Wednesday";
              }
              break;
            case 4:
              {
                day = "Thursday";
              }
              break;
            case 5:
              {
                day = "Friday";
              }
              break;
            case 6:
              {
                day = "Saturday";
              }
              break;
            case 7:
              {
                day = "Sunday";
              }
              break;
          }
          data.forEach((key, value) {
            value['times'].forEach((key, v) {
              if(v['days'].contains(day!.toLowerCase())){
                final start = DateTime.parse(v['start']);
                final end = DateTime.parse(v['end']);
                if(date.hour >= start.hour && date.hour < end.hour){
                  //LiveLecture.live.id == lecture[index].id;
                }
              }
            });
          });
        }
      } catch (err) {}
      Navigator.of(context).pushReplacementNamed(HomeView.routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: const Center(
        child: ProgressRing(),
      ),
    );
  }
}
