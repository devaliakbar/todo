import 'package:flutter/material.dart';
import 'package:todo/features/auth/presentation/screen/sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then((value) =>
        Navigator.pushReplacementNamed(context, SignInScreen.routeName));

    return const Scaffold(
      body: Center(
        child: Text("Todo", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
