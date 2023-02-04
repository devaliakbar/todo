import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/presentation/screen/task_edit_screen.dart';
import 'package:todo/features/task/presentation/widget/task_detail_screen/tasks_timesheet_section.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';

import 'package:todo/injection_container.dart' as di;

class TaskDetailScreen extends StatefulWidget {
  final Function onChange;

  final TaskInfo taskInfo;

  const TaskDetailScreen(
      {super.key, required this.taskInfo, required this.onChange});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskInfo taskInfo;

  @override
  void initState() {
    taskInfo = widget.taskInfo;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksTimesheetBloc>(
      create: (context) => di.sl<TasksTimesheetBloc>()
        ..add(GetTasksTimesheetEvent(taskId: taskInfo.taskId)),
      child: Scaffold(
        body: Column(
          children: [
            CommonAppBar(
              title: "Task detail",
              actions: [
                Builder(
                  builder: (context) => Tapped(
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: TaskEditScreen(
                              taskInfo: taskInfo,
                              onSaved: (TaskInfo newTaskInfo) {
                                BlocProvider.of<TasksTimesheetBloc>(context,
                                        listen: false)
                                    .add(GetTasksTimesheetEvent(
                                        taskId: taskInfo.taskId));
                                setState(() {
                                  taskInfo = newTaskInfo;
                                });

                                widget.onChange();
                              },
                            ))),
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Icon(
                        Icons.edit,
                        size: 24,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    taskInfo.taskName,
                    style: const TextStyle(fontSize: 17),
                  ),
                  Divider(
                    color: Colors.grey[200],
                  ),
                  Text(
                      "Status : ${taskInfo.isCompleted ? "Completed" : "Not completed"}"),
                  Divider(
                    color: Colors.grey[200],
                  ),
                  Text(
                      "Total Hour Spend : ${Utils.getFormattedDuration(taskInfo.totalHours)}"),
                  Divider(
                    color: Colors.grey[200],
                  ),
                  const Text("Description"),
                  Text(
                    taskInfo.taskDescription,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Divider(
                    color: Colors.grey[200],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Created on"),
                          Text(
                            Utils.getFormattedDate(taskInfo.createdOn),
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      if (taskInfo.completedOn != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Completed on"),
                            Text(
                              Utils.getFormattedDate(taskInfo.completedOn!),
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        )
                    ],
                  ),
                  Divider(
                    color: Colors.grey[200],
                  ),
                  Builder(
                    builder: (context) => TasksTimesheetSection(
                      taskInfo: taskInfo,
                      onChange: () {
                        BlocProvider.of<TasksTimesheetBloc>(context,
                                listen: false)
                            .add(GetTasksTimesheetEvent(
                                taskId: taskInfo.taskId));

                        widget.onChange();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
