import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/welcome/presentation/screen/home_screen.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = '/sign_in_screen';

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<UserBloc, UserState>(
          listenWhen: (_, UserState current) =>
              current is SignInFailedState || current is SignInState,
          listener: (_, UserState state) {
            if (state is SignInFailedState) {
              Fluttertoast.showToast(msg: "Failed to Sign In");
              return;
            }

            if (state is SignInState) {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            }
          },
          builder: (_, UserState state) => ElevatedButton(
              onPressed: state is SignInState || state is SignInLoadingState
                  ? null
                  : () => BlocProvider.of<UserBloc>(context, listen: false)
                      .add(SignInEvent()),
              child: Text(AppString.signinGoogle)),
        ),
      ),
    );
  }
}
