import 'dart:async';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';
import 'package:todo/features/timesheet/presentation/view_controller/timesheet_edit_controller.dart';
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
                  style: const TextStyle(fontSize: 17),
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                Text("Created by : ${timesheetTask.creatorName}"),
                Divider(
                  color: Colors.grey[200],
                ),
                Row(
                  children: [
                    const Text("Status"),
                    const SizedBox(width: 15),
                    Tapped(
                      onTap: () => _updateTaskStatus(TimesheetTaskStatus.todo),
                      child: _getStatusWidget(
                          title: "Todo",
                          isSelected: timesheetTask.taskStatus ==
                              TimesheetTaskStatus.todo),
                    ),
                    const SizedBox(width: 10),
                    Tapped(
                      onTap: () =>
                          _updateTaskStatus(TimesheetTaskStatus.inProgress),
                      child: _getStatusWidget(
                          title: "In progress",
                          isSelected: timesheetTask.taskStatus ==
                              TimesheetTaskStatus.inProgress),
                    ),
                    const SizedBox(width: 10),
                    Tapped(
                      onTap: () => _updateTaskStatus(TimesheetTaskStatus.done),
                      child: _getStatusWidget(
                          title: "Done",
                          isSelected: timesheetTask.taskStatus ==
                              TimesheetTaskStatus.done),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                if (timesheetTask.taskStatus == TimesheetTaskStatus.done)
                  Text(
                    "Total Hours : ${Utils.getFormattedDuration(timesheetTask.hours)}",
                    style: const TextStyle(fontSize: 15),
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
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 15),
                      ValueListenableBuilder(
                        valueListenable: _taskHours,
                        builder: (context, Duration taskHours, child) => Text(
                          Utils.getFormattedDuration(taskHours),
                          style: const TextStyle(fontSize: 15),
                        ),
                      )
                    ],
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
                          Utils.getFormattedDate(timesheetTask.createdOn),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    if (timesheetTask.doneOn != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Done on"),
                          Text(
                            Utils.getFormattedDate(timesheetTask.doneOn!),
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      )
                  ],
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                const Text("Description"),
                Text(
                  timesheetTask.taskDescription,
                  style: const TextStyle(fontStyle: FontStyle.italic),
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
          color: isSelected ? Colors.yellow[200] : Colors.grey[200]),
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
