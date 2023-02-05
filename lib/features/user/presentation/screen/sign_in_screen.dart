import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/app_theme/app_theme.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/welcome/presentation/screen/home_screen.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = '/sign_in_screen';

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 70.h),
          child: Column(
            children: [
              Image.asset(
                AppAssets.appIcon,
                width: screenWidth / 2,
              ),
              const Spacer(),
              BlocConsumer<UserBloc, UserState>(
                listenWhen: (_, UserState current) =>
                    current is SignInFailedState || current is SignInState,
                listener: (_, UserState state) {
                  if (state is SignInFailedState) {
                    Fluttertoast.showToast(msg: "Failed to Sign In");
                    return;
                  }

                  if (state is SignInState) {
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName);
                  }
                },
                builder: (_, UserState state) => Tapped(
                  onTap: state is SignInState || state is SignInLoadingState
                      ? null
                      : () => BlocProvider.of<UserBloc>(context, listen: false)
                          .add(SignInEvent()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: AppTheme.color.primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      AppString.signinGoogle,
                      style: AppStyle.signIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
