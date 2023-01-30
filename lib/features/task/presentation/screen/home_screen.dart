import 'package:flutter/material.dart';
import 'package:todo/features/task/presentation/widget/home_screen/home_app_bar.dart';
import 'package:todo/features/task/presentation/widget/home_screen/task_section/task_section.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: const [
                SizedBox(height: 30),
                TaskSection(title: "Todo"),
                SizedBox(height: 35),
                TaskSection(title: "In progress"),
                SizedBox(height: 35),
                TaskSection(title: "Done"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
