import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/res/app_resources.dart';

class HomeBottomNavigation extends StatelessWidget {
  final ValueNotifier<int> currentIndex;

  const HomeBottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (context, int currentIndex, child) => IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black54.withOpacity(0.15),
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
                      color: currentIndex == 0 ? Colors.yellow : Colors.black,
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
                      color: currentIndex == 1 ? Colors.yellow : Colors.black,
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
                      color: currentIndex == 2 ? Colors.yellow : Colors.black,
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
                      color: currentIndex == 3 ? Colors.yellow : Colors.black,
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
    );
  }
}
