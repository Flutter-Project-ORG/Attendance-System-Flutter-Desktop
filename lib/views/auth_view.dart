import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../view_model/auth_view_model.dart';
import 'home/home_view.dart';

class AuthView extends StatelessWidget {
  AuthView({Key? key}) : super(key: key);
  static const String routeName = '/auth';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> userInfo = {};

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        automaticallyImplyLeading: false,
        title: Text("Auth"),
      ),
      content: ScaffoldPage(
        header: const Center(
          child: Text('Authenticate Screen'),
        ),
        content: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            Expanded(
              flex: 3,
              child: Consumer<AuthViewModel>(
                builder: (BuildContext context, AuthViewModel provider, _) {
                  return Center(
                    child: Card(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  RegExp emailValid =
                                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
                                onPressed: () {},
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Center(
                                child: FilledButton(
                                child: Text(provider.authType == AuthType.login ? 'LOGIN' : 'SIGNUP'),
                                onPressed: () async{
                                  if(_formKey.currentState!.validate()){
                                    _formKey.currentState!.save();
                                   await provider.authenticate(userInfo,context);
                                  }
                                },
                              ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                children: [
                                  Text(provider.authType == AuthType.login ? 'Don\'t have an account? ' : 'Already have an account? '),
                                  TextButton(
                                    onPressed: provider.changeAuthType,
                                    child: Text(provider.authType == AuthType.login ? 'Sign Up' : 'Login'),
                                  ),
                                ],
                              ),

                            ],
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
    );
  }
}
