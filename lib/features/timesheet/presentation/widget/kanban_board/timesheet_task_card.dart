import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/presentation/screen/timesheet_task_detail_screen.dart';

class TimesheetTaskCard extends StatefulWidget {
  final TimesheetTask timesheetTask;
  const TimesheetTaskCard({super.key, required this.timesheetTask});

  @override
  State<TimesheetTaskCard> createState() => _TimesheetTaskCardState();
}

class _TimesheetTaskCardState extends State<TimesheetTaskCard> {
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
    final bool showDoneDate =
        widget.timesheetTask.taskStatus == TimesheetTaskStatus.done &&
            widget.timesheetTask.doneOn != null;

    final bool isTimerOn = widget.timesheetTask.timerStartSince != null;

    return Tapped(
      onTap: () => Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const TimsheetTaskDetailScreen())),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.timesheetTask.taskName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            if (widget.timesheetTask.taskStatus == TimesheetTaskStatus.done)
              Expanded(
                child: Center(
                  child: Text(
                    "Total Hours : ${Utils.getFormattedDuration(widget.timesheetTask.hours)}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            if (widget.timesheetTask.taskStatus ==
                TimesheetTaskStatus.inProgress)
              Expanded(
                child: Row(
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
              ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: showDoneDate
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Text(
                      "Created: ${Utils.getFormattedDate(widget.timesheetTask.createdOn)}",
                      style: const TextStyle(fontSize: 13)),
                  if (showDoneDate)
                    Text(
                        "Done by: ${Utils.getFormattedDate(widget.timesheetTask.doneOn!)}",
                        style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _taskHours.value = widget.timesheetTask.hours +
          Utils.getTimerDuration(widget.timesheetTask.timerStartSince!);
    });
  }

  void _toggleTimer({required bool isStart}) {
    final Duration hours;
    final DateTime? timerStartSince;
    if (isStart) {
      hours = widget.timesheetTask.hours;
      timerStartSince = DateTime.now().toUtc();
    } else {
      _timer?.cancel();

      hours = widget.timesheetTask.hours +
          Utils.getTimerDuration(widget.timesheetTask.timerStartSince!);
      timerStartSince = null;
    }

    final TimesheetTask updatedTask = TimesheetTask(
        taskId: widget.timesheetTask.taskId,
        taskName: widget.timesheetTask.taskName,
        taskDescription: widget.timesheetTask.taskDescription,
        taskStatus: widget.timesheetTask.taskStatus,
        createdOn: widget.timesheetTask.createdOn,
        doneOn: widget.timesheetTask.doneOn,
        timerStartSince: timerStartSince,
        hours: hours);
  }
}