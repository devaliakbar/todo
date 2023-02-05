import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/res/app_theme/app_theme.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:provider/provider.dart';

class HomeBottomNavigation extends StatelessWidget {
  final ValueNotifier<int> currentIndex;

  const HomeBottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, __, ___) => ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, int currentIndex, child) => IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppTheme.color.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                )
              ],
            ),
            padding: EdgeInsets.only(
                top: 10, bottom: MediaQuery.of(context).padding.bottom + 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Tapped(
                  onTap: () => this.currentIndex.value = 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        size: 24,
                        color: currentIndex == 0
                            ? AppTheme.color.primaryColor
                            : AppTheme.color.black,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Home",
                        style: AppStyle.bottomNavText(currentIndex == 0),
                      )
                    ],
                  ),
                ),
                Tapped(
                  onTap: () => this.currentIndex.value = 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task,
                        size: 24,
                        color: currentIndex == 1
                            ? AppTheme.color.primaryColor
                            : AppTheme.color.black,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Task",
                        style: AppStyle.bottomNavText(currentIndex == 1),
                      )
                    ],
                  ),
                ),
                Tapped(
                  onTap: () => this.currentIndex.value = 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 24,
                        color: currentIndex == 2
                            ? AppTheme.color.primaryColor
                            : AppTheme.color.black,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "History",
                        style: AppStyle.bottomNavText(currentIndex == 2),
                      )
                    ],
                  ),
                ),
                Tapped(
                  onTap: () => this.currentIndex.value = 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 24,
                        color: currentIndex == 3
                            ? AppTheme.color.primaryColor
                            : AppTheme.color.black,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Profile",
                        style: AppStyle.bottomNavText(currentIndex == 3),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
