import 'dart:async';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';
import 'package:todo/core/app_theme/app_theme.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';
import 'package:todo/features/timesheet/presentation/view_controller/timesheet_edit_controller.dart';
import 'package:todo/features/timesheet/presentation/widget/timesheet_task_detail_screen/timesheet_time_selector.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';

class TimsheetTaskDetailScreen extends StatefulWidget {
  final TimesheetTask timesheetTask;

  const TimsheetTaskDetailScreen({super.key, required this.timesheetTask});

  @override
  State<TimsheetTaskDetailScreen> createState() =>
      _TimsheetTaskDetailScreenState();
}

class _TimsheetTaskDetailScreenState extends State<TimsheetTaskDetailScreen> {
  late TimesheetTask timesheetTask;

  final ValueNotifier<Duration> _taskHours = ValueNotifier(Duration.zero);
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    timesheetTask = widget.timesheetTask;

    _initHour();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _taskHours.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTimerOn = timesheetTask.timerStartSince != null;

    return Scaffold(
      body: Column(
        children: [
          const CommonAppBar(title: "Task detail"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  timesheetTask.taskName,
                  style: AppStyle.mainInfo,
                ),
                Divider(
                  color: AppTheme.color.dividerColor,
                ),
                Text(
                  "Created by : ${timesheetTask.creatorName}",
                  style: AppStyle.subInfo(),
                ),
                Divider(
                  color: AppTheme.color.dividerColor,
                ),
                Row(
                  children: [
                    Text(
                      "Status",
                      style: AppStyle.subInfo(),
                    ),
                    const SizedBox(width: 15),
                    Tapped(
                      onTap: () => _updateTaskStatus(TimesheetTaskStatus.todo),
                      child: _getStatusWidget(
                          title: AppString.todo,
                          isSelected: timesheetTask.taskStatus ==
                              TimesheetTaskStatus.todo),
                    ),
                    const SizedBox(width: 10),
                    Tapped(
                      onTap: () =>
                          _updateTaskStatus(TimesheetTaskStatus.inProgress),
                      child: _getStatusWidget(
                          title: AppString.inProgress,
                          isSelected: timesheetTask.taskStatus ==
                              TimesheetTaskStatus.inProgress),
                    ),
                    const SizedBox(width: 10),
                    Tapped(
                      onTap: () => _updateTaskStatus(TimesheetTaskStatus.done),
                      child: _getStatusWidget(
                          title: AppString.done,
                          isSelected: timesheetTask.taskStatus ==
                              TimesheetTaskStatus.done),
                    ),
                  ],
                ),
                Divider(
                  color: AppTheme.color.dividerColor,
                ),
                if (timesheetTask.taskStatus == TimesheetTaskStatus.done)
                  Text(
                    "Total Hours : ${Utils.getFormattedDuration(timesheetTask.hours)}",
                    style: AppStyle.subInfo(),
                  ),
                if (timesheetTask.taskStatus == TimesheetTaskStatus.inProgress)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tapped(
                        onTap: () => _toggleTimer(isStart: !isTimerOn),
                        child: Icon(
                          isTimerOn
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                          color: AppTheme.color.primaryColor,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 15),
                      ValueListenableBuilder(
                        valueListenable: _taskHours,
                        builder: (context, Duration taskHours, child) =>
                            isTimerOn
                                ? Text(
                                    Utils.getFormattedDuration(taskHours),
                                    style: AppStyle.subInfo(),
                                  )
                                : TimesheetTimeSelector(
                                    hours: taskHours,
                                    onHourUpdate: _onHourChanged,
                                  ),
                      )
                    ],
                  ),
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
                          AppString.createdOn,
                          style: AppStyle.subInfo(),
                        ),
                        Text(
                          Utils.getFormattedDate(timesheetTask.createdOn),
                          style: AppStyle.subInfo(isItalic: true),
                        ),
                      ],
                    ),
                    if (timesheetTask.doneOn != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Done on", style: AppStyle.subInfo()),
                          Text(Utils.getFormattedDate(timesheetTask.doneOn!),
                              style: AppStyle.subInfo(isItalic: true)),
                        ],
                      )
                  ],
                ),
                Divider(
                  color: AppTheme.color.dividerColor,
                ),
                Text(
                  AppString.description,
                  style: AppStyle.subInfo(),
                ),
                Text(
                  timesheetTask.taskDescription,
                  style: AppStyle.subInfo(isItalic: true),
                ),
              ],
            ),
          )
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

  void _initHour() {
    _timer?.cancel();

    if (timesheetTask.timerStartSince == null) {
      _taskHours.value = timesheetTask.hours;
    } else {
      _taskHours.value = timesheetTask.hours +
          Utils.getTimerDuration(timesheetTask.timerStartSince!);
      _startCountDown();
    }
  }

  void _startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _taskHours.value = timesheetTask.hours +
          Utils.getTimerDuration(timesheetTask.timerStartSince!);
    });
  }

  void _toggleTimer({required bool isStart}) {
    final Duration hours;
    final DateTime? timerStartSince;
    if (isStart) {
      hours = timesheetTask.hours;
      timerStartSince = DateTime.now();
    } else {
      _timer?.cancel();

      hours = timesheetTask.hours +
          Utils.getTimerDuration(timesheetTask.timerStartSince!);
      timerStartSince = null;
    }

    final UpdateTimesheetStatusParam updatedInfo = UpdateTimesheetStatusParam(
        timesheetId: timesheetTask.timesheetId,
        taskId: timesheetTask.taskId,
        taskStatus: timesheetTask.taskStatus,
        doneOn: timesheetTask.doneOn,
        timerStartSince: timerStartSince,
        hours: hours);

    final UpdateTimesheetStatusParam oldInfo = UpdateTimesheetStatusParam(
        timesheetId: timesheetTask.timesheetId,
        taskId: timesheetTask.taskId,
        taskStatus: timesheetTask.taskStatus,
        doneOn: timesheetTask.doneOn,
        timerStartSince: timesheetTask.timerStartSince,
        hours: timesheetTask.hours);

    _update(UpdateTimesheetParams(oldTask: oldInfo, updatedTask: updatedInfo));
  }

  void _onHourChanged(Duration newHour) {
    final UpdateTimesheetStatusParam updatedInfo = UpdateTimesheetStatusParam(
        timesheetId: timesheetTask.timesheetId,
        taskId: timesheetTask.taskId,
        taskStatus: timesheetTask.taskStatus,
        doneOn: timesheetTask.doneOn,
        timerStartSince: timesheetTask.timerStartSince,
        hours: newHour);

    final UpdateTimesheetStatusParam oldInfo = UpdateTimesheetStatusParam(
        timesheetId: timesheetTask.timesheetId,
        taskId: timesheetTask.taskId,
        taskStatus: timesheetTask.taskStatus,
        doneOn: timesheetTask.doneOn,
        timerStartSince: timesheetTask.timerStartSince,
        hours: timesheetTask.hours);

    _update(UpdateTimesheetParams(oldTask: oldInfo, updatedTask: updatedInfo));
  }

  void _updateTaskStatus(TimesheetTaskStatus newStatus) {
    Duration hours = timesheetTask.hours;

    ///Checking whether timer is On
    if (timesheetTask.taskStatus == TimesheetTaskStatus.inProgress &&
        timesheetTask.timerStartSince != null) {
      hours = timesheetTask.hours +
          Utils.getTimerDuration(timesheetTask.timerStartSince!);
    }

    final UpdateTimesheetStatusParam updatedInfo = UpdateTimesheetStatusParam(
        timesheetId: timesheetTask.timesheetId,
        taskId: timesheetTask.taskId,
        taskStatus: newStatus,
        doneOn: newStatus == TimesheetTaskStatus.done ? DateTime.now() : null,
        timerStartSince: null,
        hours: hours);

    final UpdateTimesheetStatusParam oldInfo = UpdateTimesheetStatusParam(
        timesheetId: timesheetTask.timesheetId,
        taskId: timesheetTask.taskId,
        taskStatus: timesheetTask.taskStatus,
        doneOn: timesheetTask.doneOn,
        timerStartSince: timesheetTask.timerStartSince,
        hours: timesheetTask.hours);

    _update(UpdateTimesheetParams(oldTask: oldInfo, updatedTask: updatedInfo));
  }

  Future<void> _update(UpdateTimesheetParams updateTimesheetParams) async {
    final AppLoaderBloc appLoaderBloc =
        BlocProvider.of<AppLoaderBloc>(context, listen: false);

    appLoaderBloc.add(ShowLoader());

    final dartz.Either<Failure, TimesheetTask> result =
        await RepositoryProvider.of<TimesheetEditController>(context,
                listen: false)
            .updateTimesheet(updateTimesheetParams: updateTimesheetParams);

    appLoaderBloc.add(HideLoader());

    result.fold((l) => Fluttertoast.showToast(msg: "Failed to update"),
        (TimesheetTask r) {
      timesheetTask = r;
      _initHour();
      setState(() {});

      final UserState userState =
          BlocProvider.of<UserBloc>(context, listen: false).state;

      if (userState is SignInState) {
        BlocProvider.of<TasksTimesheetBloc>(context, listen: false)
            .add(GetTasksTimesheetEvent(userId: userState.userInfo.id));
      }
    });
  }
}
