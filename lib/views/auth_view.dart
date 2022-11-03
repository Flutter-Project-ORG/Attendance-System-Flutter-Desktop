import 'package:fluent_ui/fluent_ui.dart';

import 'home_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);
  static const String routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        automaticallyImplyLeading: false,
        title: Text("Auth"),
      ),
      content: Center(
        child: FilledButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeView.routeName);
          },
          child: const Text('Go Home'),
        ),
      ),
    );
  }
}
