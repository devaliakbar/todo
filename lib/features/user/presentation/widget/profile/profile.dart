import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/cached_image.dart';
import 'package:todo/core/presentation/widget/main_screen_app_bar.dart';
import 'package:todo/core/res/app_theme/app_theme.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/user/presentation/screen/sign_in_screen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, AppTheme appTheme, ___) => Column(
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
                                isSelect: false, flag: AppAssets.usFlagImg),
                            SizedBox(width: 20),
                            _LanguageFlag(
                                isSelect: true, flag: AppAssets.deFlagImg)
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
                          children: [
                            _ThemeColors(
                                onSelect: () {
                                  appTheme.changeTheme(0);
                                },
                                color1: Colors.pinkAccent,
                                color2: const Color(0xFF9b111e),
                                isSelect: AppTheme.currentThemeIndex == 0),
                            const SizedBox(width: 20),
                            _ThemeColors(
                              onSelect: () {
                                appTheme.changeTheme(1);
                              },
                              color1: Colors.blueAccent,
                              color2: const Color(0xFF7b403b),
                              isSelect: AppTheme.currentThemeIndex == 1,
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
      ),
    );
  }
}

class _ThemeColors extends StatelessWidget {
  final Function onSelect;
  final bool isSelect;
  final Color color1;
  final Color color2;

  const _ThemeColors(
      {required this.onSelect,
      required this.isSelect,
      required this.color1,
      required this.color2});

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: onSelect,
      child: Container(
        decoration: isSelect
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppTheme.color.primaryColor, width: 3))
            : null,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 1, bottom: 1, left: 1),
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
              margin: const EdgeInsets.only(top: 1, bottom: 1, right: 1),
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
                border:
                    Border.all(color: AppTheme.color.primaryColor, width: 3))
            : null,
        child: Container(
          margin: const EdgeInsets.all(2),
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
