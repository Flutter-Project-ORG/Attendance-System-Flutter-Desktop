import 'package:flutter/material.dart';
import '../models/instructor_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                InstructorModel instructorModel = await InstructorModel().authenticate(
                  username: 'Osama Assaf',
                  email: 'osama@gmail.com',
                  password: '123456',
                );
              },
              child: const Text('Sign Up'),
            ), ElevatedButton(
              onPressed: () async {
                InstructorModel instructorModel = await InstructorModel().authenticate(
                  email: 'osama@gmail.com',
                  password: '123456',
                  isLogin: true
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
