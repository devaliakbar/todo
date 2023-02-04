import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/main_screen_app_bar.dart';
import 'package:todo/features/task/presentation/widget/task_list.dart';

class TaskHistory extends StatelessWidget {
  final Function onReload;

  const TaskHistory({super.key, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainScreenAppBar(
          title: "History",
          actions: [
            Tapped(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.download_rounded,
                  size: 24,
                ),
              ),
            )
          ],
        ),
        TaskList(onReLoad: onReload),
      ],
    );
  }
}
