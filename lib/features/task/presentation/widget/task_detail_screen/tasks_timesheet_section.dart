import 'dart:async';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/cached_image.dart';
import 'package:todo/core/app_theme/app_theme.dart';
import 'package:todo/core/presentation/widget/failed_view.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';
import 'package:todo/features/timesheet/presentation/view_controller/timesheet_edit_controller.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

class TasksTimesheetSection extends StatelessWidget {
  final TaskInfo taskInfo;
  final Function onChange;

  const TasksTimesheetSection(
      {super.key, required this.taskInfo, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Members status",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        BlocBuilder<TasksTimesheetBloc, TasksTimesheetState>(
          builder: (context, state) {
            if (state is TasksTimesheetLoadFail) {
              return FailedView(
                failMsg: "Oops!, something went wrong",
                addRetryBtn: true,
                onClickRetry: onChange,
              );
            }

            if (state is TasksTimesheetLoaded) {
              List<TimesheetTask> tasks = [];
              tasks.addAll(state.tasks.doneTasks);
              tasks.addAll(state.tasks.inprogressTasks);
              tasks.addAll(state.tasks.todoTasks);

              if (tasks.isEmpty) {
                return const FailedView(failMsg: "No members found");
              }

              return ListView.builder(
                itemCount: tasks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                itemBuilder: (context, index) {
                  final TimesheetTask timesheetTask = tasks[index];

                  final UserInfo userInfo = taskInfo.assignedTo.firstWhere(
                      (element) =>
                          element.id == timesheetTask.assignedToPersonId);

                  return _MemberProgress(
                    timesheetTask: timesheetTask,
                    userInfo: userInfo,
                    onChange: onChange,
                  );
                },
              );
            }

            return const Center(
              child: Text("Loading..."),
            );
          },
        )
      ],
    );
  }
}

class _MemberProgress extends StatefulWidget {
  final TimesheetTask timesheetTask;
  final UserInfo userInfo;
  final Function onChange;

  const _MemberProgress(
      {required this.timesheetTask,
      required this.userInfo,
      required this.onChange});

  @override
  State<_MemberProgress> createState() => _MemberProgressState();
}

class _MemberProgressState extends State<_MemberProgress> {
  final ValueNotifier<Duration> _taskHours = ValueNotifier(Duration.zero);
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.timesheetTask.timerStartSince == null) {
      _taskHours.value = widget.timesheetTask.hours;
    } else {
      _taskHours.value = widget.timesheetTask.hours +
          Utils.getTimerDuration(widget.timesheetTask.timerStartSince!);
      _startCountDown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _taskHours.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 24,
                width: 24,
                margin: const EdgeInsets.only(right: 10),
                child: ClipOval(
                  child: CachedImage(imageUrl: widget.userInfo.profilePic),
                ),
              ),
              Text(
                widget.userInfo.fullName,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Tapped(
                onTap: () {
                  if (widget.timesheetTask.taskStatus !=
                      TimesheetTaskStatus.done) {
                    Fluttertoast.showToast(
                        msg:
                            "You can only do this action if the status is done");
                  } else {
                    _changeStatus();
                  }
                },
                child: _getStatusWidget(
                    title: "Todo",
                    isSelected: widget.timesheetTask.taskStatus ==
                        TimesheetTaskStatus.todo),
              ),
              const SizedBox(width: 10),
              _getStatusWidget(
                  title: "In progress",
                  isSelected: widget.timesheetTask.taskStatus ==
                      TimesheetTaskStatus.inProgress),
              const SizedBox(width: 10),
              _getStatusWidget(
                  title: "Done",
                  isSelected: widget.timesheetTask.taskStatus ==
                      TimesheetTaskStatus.done),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: _taskHours,
                builder: (context, Duration taskHours, child) =>
                    Text("${Utils.getFormattedDuration(taskHours)} HRS"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _getStatusWidget({required String title, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected
              ? AppTheme.color.primaryColor.withOpacity(0.2)
              : AppTheme.color.dividerColor),
      child: Text(title),
    );
  }

  void _startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _taskHours.value = widget.timesheetTask.hours +
          Utils.getTimerDuration(widget.timesheetTask.timerStartSince!);
    });
  }

  Future<void> _changeStatus() async {
    final UpdateTimesheetStatusParam updateTask = UpdateTimesheetStatusParam(
        timesheetId: widget.timesheetTask.timesheetId,
        taskId: widget.timesheetTask.taskId,
        taskStatus: TimesheetTaskStatus.todo,
        doneOn: widget.timesheetTask.doneOn,
        timerStartSince: widget.timesheetTask.timerStartSince,
        hours: widget.timesheetTask.hours);

    final UpdateTimesheetStatusParam oldTask = UpdateTimesheetStatusParam(
        timesheetId: widget.timesheetTask.timesheetId,
        taskId: widget.timesheetTask.taskId,
        taskStatus: widget.timesheetTask.taskStatus,
        doneOn: widget.timesheetTask.doneOn,
        timerStartSince: widget.timesheetTask.timerStartSince,
        hours: widget.timesheetTask.hours);

    final AppLoaderBloc appLoaderBloc =
        BlocProvider.of<AppLoaderBloc>(context, listen: false);

    appLoaderBloc.add(ShowLoader());

    final dartz.Either result =
        await RepositoryProvider.of<TimesheetEditController>(context,
                listen: false)
            .updateTimesheet(
                updateTimesheetParams: UpdateTimesheetParams(
                    oldTask: oldTask, updatedTask: updateTask));

    appLoaderBloc.add(HideLoader());

    result.fold((l) => Fluttertoast.showToast(msg: "Failed to update"),
        (r) => widget.onChange());
  }
}
