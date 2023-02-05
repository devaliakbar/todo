import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';
import 'package:todo/core/app_theme/app_theme.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/presentation/screen/task_edit_screen.dart';
import 'package:todo/features/task/presentation/view_controller/task_edit_controller.dart';
import 'package:todo/features/task/presentation/widget/task_detail_screen/tasks_timesheet_section.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';

import 'package:todo/injection_container.dart' as di;
import 'package:dartz/dartz.dart' as dartz;

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
                Tapped(
                  onTap: _deleteTaskConfirmation,
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(
                      Icons.delete,
                      size: 24,
                    ),
                  ),
                ),
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
                ),
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
                    style: AppStyle.mainInfo,
                  ),
                  Divider(
                    color: AppTheme.color.dividerColor,
                  ),
                  Text(
                    "Status : ${taskInfo.isCompleted ? "Completed" : "Not completed"}",
                    style: AppStyle.subInfo(),
                  ),
                  Divider(
                    color: AppTheme.color.dividerColor,
                  ),
                  Text(
                    "Total Hour Spend : ${Utils.getFormattedDuration(taskInfo.totalHours)}",
                    style: AppStyle.subInfo(),
                  ),
                  Divider(
                    color: AppTheme.color.dividerColor,
                  ),
                  Text(
                    "Description",
                    style: AppStyle.subInfo(),
                  ),
                  Text(taskInfo.taskDescription,
                      style: AppStyle.subInfo(isItalic: true)),
                  Divider(
                    color: AppTheme.color.dividerColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Created on",
                            style: AppStyle.subInfo(),
                          ),
                          Text(
                            Utils.getFormattedDate(taskInfo.createdOn),
                            style: AppStyle.subInfo(isItalic: true),
                          ),
                        ],
                      ),
                      if (taskInfo.completedOn != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Completed on",
                              style: AppStyle.subInfo(),
                            ),
                            Text(
                              Utils.getFormattedDate(taskInfo.completedOn!),
                              style: AppStyle.subInfo(isItalic: true),
                            ),
                          ],
                        )
                    ],
                  ),
                  Divider(
                    color: AppTheme.color.dividerColor,
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

  void _deleteTaskConfirmation() {
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Navigator.pop(context);

        _deleteTask();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure, do you like to delete?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _deleteTask() async {
    final TaskEditController taskEditController =
        RepositoryProvider.of<TaskEditController>(context, listen: false);

    final AppLoaderBloc appLoaderBloc =
        BlocProvider.of<AppLoaderBloc>(context, listen: false);

    appLoaderBloc.add(ShowLoader());

    final dartz.Either<Failure, void> result =
        await taskEditController.deleteTask(widget.taskInfo.taskId);

    appLoaderBloc.add(HideLoader());

    result.fold((l) => Fluttertoast.showToast(msg: "Failed to delete task."),
        (r) {
      Fluttertoast.showToast(msg: "Task deleted successfully.");

      Navigator.pop(context);

      widget.onChange();
    });
  }
}
