import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

class TasksTimesheetSection extends StatelessWidget {
  final TaskInfo taskInfo;

  const TasksTimesheetSection({super.key, required this.taskInfo});

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
            if (state is TasksTimesheetLoaded) {
              return ListView.builder(
                itemCount: state.tasks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                itemBuilder: (context, index) {
                  final TimesheetTask timesheetTask = state.tasks[index];

                  final UserInfo userInfo = taskInfo.assignedTo.firstWhere(
                      (element) =>
                          element.id == timesheetTask.assignedToPersonId);

                  return _MemberProgress(
                      timesheetTask: timesheetTask, userInfo: userInfo);
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

  const _MemberProgress({required this.timesheetTask, required this.userInfo});

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
          Text(
            widget.userInfo.fullName,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Tapped(
                onTap: () {},
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
          color: isSelected ? Colors.yellow[200] : Colors.grey[200]),
      child: Text(title),
    );
  }

  void _startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _taskHours.value = widget.timesheetTask.hours +
          Utils.getTimerDuration(widget.timesheetTask.timerStartSince!);
    });
  }
}
