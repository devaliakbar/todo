import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/cached_image.dart';
import 'package:todo/core/presentation/widget/main_screen_app_bar.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/auth/presentation/screen/sign_in_screen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MainScreenAppBar(title: "Profile"),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            children: [
              BlocBuilder<UserBloc, UserState>(builder: (_, UserState state) {
                final String userFullName =
                    state is SignInState ? state.userInfo.fullName : "";

                final String? userImage =
                    state is SignInState ? state.userInfo.profilePic : null;
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 75,
                        width: 75,
                        child: ClipOval(
                          child: CachedImage(imageUrl: userImage),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        userFullName,
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      "Language",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: const [
                          _LanguageFlag(
                              isSelect: true, flag: AppAssets.usFlagImg),
                          SizedBox(width: 20),
                          _LanguageFlag(
                              isSelect: false, flag: AppAssets.deFlagImg)
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      "Theme",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: const [
                          _ThemeColors(
                              color1: Colors.red,
                              color2: Colors.yellow,
                              isSelect: true),
                          SizedBox(width: 20),
                          _ThemeColors(
                            color1: Colors.blue,
                            color2: Colors.pink,
                            isSelect: false,
                          )
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<UserBloc>(context, listen: false)
                      .add(SignOutEvent());

                  Navigator.pushReplacementNamed(
                      context, SignInScreen.routeName);
                },
                child: const Text("Sign out"),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _ThemeColors extends StatelessWidget {
  final bool isSelect;
  final Color color1;
  final Color color2;

  const _ThemeColors(
      {required this.isSelect, required this.color1, required this.color2});

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: () {},
      child: Container(
        decoration: isSelect
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black, width: 2))
            : null,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                color: color1,
              ),
              height: 22,
              width: 12,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: color2,
              ),
              height: 22,
              width: 12,
            )
          ],
        ),
      ),
    );
  }
}

class _LanguageFlag extends StatelessWidget {
  final bool isSelect;
  final String flag;

  const _LanguageFlag({required this.isSelect, required this.flag});

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: () {},
      child: Container(
        decoration: isSelect
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2.5))
            : null,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
          ),
          height: 22,
          width: 24,
          child: Image.asset(flag, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
