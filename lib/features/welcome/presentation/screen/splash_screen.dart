import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/auth/presentation/screen/sign_in_screen.dart';
import 'package:todo/features/welcome/presentation/screen/home_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    Future.delayed(const Duration(seconds: 2)).then((value) =>
        BlocProvider.of<UserBloc>(context, listen: false)
            .add(CheckSignInEvent()));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Center(
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is SignInState) {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName);

                return;
              }

              if (state is! SignInLoadingState) {
                Navigator.pushReplacementNamed(context, SignInScreen.routeName);
              }
            },
            child: const Text(
              "Todo",
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
