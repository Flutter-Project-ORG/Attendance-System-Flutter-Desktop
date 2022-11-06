import 'package:fluent_ui/fluent_ui.dart';

class LecturesView extends StatelessWidget {
  const LecturesView({Key? key}) : super(key: key);

  static const String routeName = '/lectures';
  @override
  Widget build(BuildContext context) {
    final String subjectName = ModalRoute.of(context)!.settings.arguments.toString() ;
    return NavigationView(
      appBar:  NavigationAppBar(
        title: Text(subjectName),
      ),
      content: Center(),
    );
  }
}
