import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/main_screen_app_bar.dart';
import 'package:todo/features/task/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:todo/features/task/presentation/screen/task_edit_screen.dart';
import 'package:todo/features/task/presentation/widget/task_list.dart';

class Tasks extends StatelessWidget {
  final Function onReload;

  const Tasks({super.key, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainScreenAppBar(
          title: "Task",
          actions: [
            Tapped(
              onTap: () {
                final TasksBloc tasksBloc =
                    BlocProvider.of<TasksBloc>(context, listen: false);

                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: TaskEditScreen(
                          onSaved: (_) => tasksBloc
                              .add(const GetTasksEvent(getCompltedTask: false)),
                        )));
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.add_circle_outline_sharp,
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
