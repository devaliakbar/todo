import 'package:flutter/material.dart';
import 'package:todo/features/task/presentation/screen/home_screen.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = '/sign_in_screen';

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, HomeScreen.routeName),
            child: const Text("Sign in with google")),
      ),
    );
  }
}
