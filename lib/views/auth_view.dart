import 'package:attendance_system_flutter_desktop/res/custom_text_theme.dart';
import 'package:attendance_system_flutter_desktop/widgets/project_name_animation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../view_model/auth_view_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AuthView extends StatelessWidget {
  AuthView({Key? key}) : super(key: key);
  static const String routeName = '/auth';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> userInfo = {};
  final colorizeTextStyle =
      const TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold
          //fontFamily: 'Horizon',
          );
  final colorizeColors = [
    Colors.white,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return NavigationView(
      content: ScaffoldPage(
        content: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            children: [
              if (width > 600)
                Expanded(
                  flex: 2,
                  child: ProjectNameAnimation(
                    textStyle: CustomTextTheme.projectNameAuth,
                  ),
                ),
              if (width > 600)
                const SizedBox(
                  width: 16.0,
                ),
              Expanded(
                flex: 3,
                child: Consumer<AuthViewModel>(
                  builder: (BuildContext context, AuthViewModel provider, _) {
                    return Center(
                      child: Card(
                        child: Form(
                          key: _formKey,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: provider.authType == AuthType.signUp
                                ? 350
                                : 290,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (provider.authType == AuthType.signUp)
                                    TextFormBox(
                                      key: UniqueKey(),
                                      header: 'Enter your username',
                                      placeholder: 'Username',
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Username cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        userInfo['username'] = value!;
                                      },
                                    ),
                                  if (provider.authType == AuthType.signUp)
                                    const SizedBox(
                                      height: 16.0,
                                    ),
                                  TextFormBox(
                                    header: 'Enter your email',
                                    placeholder: 'Email',
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email cannot be empty';
                                      }
                                      RegExp emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                      if (!emailValid.hasMatch(value)) {
                                        return 'Email not valid';
                                      }
                                      return null;
                                    },
                                    onSaved: (String? value) {
                                      userInfo['email'] = value!;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  TextFormBox(
                                    header: 'Enter your password',
                                    placeholder: 'Password',
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password cannot be empty';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                    onSaved: (String? value) {
                                      userInfo['password'] = value!;
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Forget Password?'),
                                    onPressed: () {
                                      provider.resetPassword(context);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  FilledButton(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 28.0),
                                      child: Text(
                                          provider.authType == AuthType.login
                                              ? 'LOGIN'
                                              : 'SIGNUP'),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        await provider.authenticate(
                                            userInfo, context);
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Row(
                                    children: [
                                      Text(provider.authType == AuthType.login
                                          ? 'Don\'t have an account? '
                                          : 'Already have an account? '),
                                      TextButton(
                                        onPressed: provider.changeAuthType,
                                        child: Text(
                                            provider.authType == AuthType.login
                                                ? 'Sign Up'
                                                : 'Login'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
