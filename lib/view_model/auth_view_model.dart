import 'package:attendance_system_flutter_desktop/models/instructor_model.dart';
import 'package:attendance_system_flutter_desktop/views/home_view.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AuthViewModel with ChangeNotifier {
  AuthType authType = AuthType.login;

  void changeAuthType() {
    authType = authType == AuthType.login ? AuthType.signUp : AuthType.login;
    notifyListeners();
  }

  InstructorModel? user;

  Future<void> authenticate(Map<String, String> userInfo, BuildContext context) async {
    try {
      if (authType == AuthType.login) {
        user = await InstructorModel().authenticate(
            email: userInfo['email']!, password: userInfo['password']!, isLogin: true);
      } else {
        user = await InstructorModel().authenticate(
            email: userInfo['email']!, password: userInfo['password']!, username: userInfo['username']!);
      }
      notifyListeners();
      Navigator.pushReplacementNamed(context, HomeView.routeName);
    } catch (e) {
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
}

enum AuthType { login, signUp }
