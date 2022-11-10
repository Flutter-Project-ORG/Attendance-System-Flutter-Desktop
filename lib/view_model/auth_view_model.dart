import '../models/instructor_model.dart';
import '../views/home_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
class AuthViewModel with ChangeNotifier {
  AuthType authType = AuthType.login;
  InstructorModel instructorModel = InstructorModel.instance;
  void changeAuthType() {
    authType = authType == AuthType.login ? AuthType.signUp : AuthType.login;
    notifyListeners();
  }

  InstructorModel? user;

  set setUser (InstructorModel? newUser){
    user = newUser;
    notifyListeners();
  }

  Future<void> authenticate(Map<String, String> userInfo, BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);
    showDialog(context: context, builder: (ctx){
      return const Center(child: ProgressRing());
    });
    try {
      final NavigatorState navigator = Navigator.of(context);
      if (authType == AuthType.login) {
        user = await instructorModel.authenticate(
            email: userInfo['email']!, password: userInfo['password']!, isLogin: true);
      } else {
        user = await instructorModel.authenticate(
            email: userInfo['email']!, password: userInfo['password']!, username: userInfo['username']!);
      }
      navigator.pop();
      notifyListeners();
      navigator.pushNamed(HomeView.routeName);
    } catch (e) {
      navigator.pop();
      String message = '';
      if (e == 'EMAIL_EXISTS') {
        message = 'The email address is already in use by another account.';
      } else if (e == 'TOO_MANY_ATTEMPTS_TRY_LATER') {
        message = 'We have blocked all requests from this device due to unusual activity. Try again later.';
      } else if (e == 'EMAIL_NOT_FOUND') {
        message = 'There is no user record corresponding to this identifier. The user may have been deleted.';
      } else if (e == 'INVALID_PASSWORD') {
        message = 'The password is invalid or the user does not have a password.';
      } else if (e == 'USER_DISABLED') {
        message = 'The user account has been disabled by an administrator.';
      } else {
        message = 'Something went wrong. Try again.';
      }
      showSnackbar(
          context,
          Snackbar(
            content: Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: Text(message),
            ),
            extended: true,
          ));
    }
  }
  Future<void> resetPassword(BuildContext context)async{
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return ContentDialog(
          title: const Text('Reset your password'),
          content: TextBox(
            controller: controller,
            header: 'Enter your email',
            placeholder: 'Email',
          ),
          actions: [
            Button(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FilledButton(
              child: const Text('Reset'),
              onPressed: () async {
                if (controller.text.isEmpty) {
                  showSnackbar(context, const Snackbar(content: Text('You must insert an email')));
                  return;
                }
                try {
                  await instructorModel .restPassword(controller.text).then((_) {
                    Navigator.pop(context);
                    showSnackbar(context, const Snackbar(content: Text('Check your email')),);
                  });

                } catch (e) {
                  showSnackbar(context, Snackbar(content: Text(e.toString())));
                }
              },
            ),
          ],
        );
      },
    );
  }
}

enum AuthType { login, signUp }
