import 'package:flutter/material.dart';
import 'package:todo/features/task/presentation/widget/task_edit_screen/task_edit_app_bar.dart';

class TaskEditScreen extends StatelessWidget {
  static const String routeName = '/task_edit_screen';

  const TaskEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TaskEditAppBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 50),
              children: [],
            ),
          )
        ],
      ),
    );
  }
}
