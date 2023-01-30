import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/auth/presentation/screen/sign_in_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 15),
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (_, UserState state) {
                final String userFullName =
                    state is SignInState ? state.userInfo.fullName : "";
                return Text(
                  "Hi $userFullName",
                  style: const TextStyle(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          Tapped(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.history,
                size: 24,
              ),
            ),
          ),
          Tapped(
            onTap: () {
              BlocProvider.of<UserBloc>(context, listen: false)
                  .add(SignOutEvent());

              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            },
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.logout,
                size: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
