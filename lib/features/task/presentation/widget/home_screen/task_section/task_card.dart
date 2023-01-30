import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';

class TaskCard extends StatefulWidget {
  final TaskInfo taskInfo;
  const TaskCard({super.key, required this.taskInfo});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final ValueNotifier<Duration> _taskHours = ValueNotifier(Duration.zero);
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.taskInfo.timerStartSince == null) {
      _taskHours.value = widget.taskInfo.hours;
    } else {
      _taskHours.value = widget.taskInfo.hours +
          Utils.getTimerDuration(widget.taskInfo.timerStartSince!);
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
    final bool showDoneDate = widget.taskInfo.taskStatus == TaskStatus.done &&
        widget.taskInfo.doneOn != null;

    final bool isTimerOn = widget.taskInfo.timerStartSince != null;

    return Container(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  widget.taskInfo.taskName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17),
                )),
                const Icon(Icons.edit, size: 17)
              ],
            ),
          ),
          if (widget.taskInfo.taskStatus == TaskStatus.done)
            Expanded(
              child: Center(
                child: Text(
                  "Total Hours : ${Utils.getFormattedDuration(widget.taskInfo.hours)}",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          if (widget.taskInfo.taskStatus == TaskStatus.inProgress)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tapped(
                    onTap: () => _toggleTimer(isStart: !isTimerOn),
                    child: Icon(
                      isTimerOn ? Icons.stop_rounded : Icons.play_arrow_rounded,
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
                    "Created: ${Utils.getFormattedDate(widget.taskInfo.createdOn)}",
                    style: const TextStyle(fontSize: 13)),
                if (showDoneDate)
                  Text(
                      "Done by: ${Utils.getFormattedDate(widget.taskInfo.doneOn!)}",
                      style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _taskHours.value = widget.taskInfo.hours +
          Utils.getTimerDuration(widget.taskInfo.timerStartSince!);
    });
  }

  void _toggleTimer({required bool isStart}) {
    final Duration hours;
    final DateTime? timerStartSince;
    if (isStart) {
      hours = widget.taskInfo.hours;
      timerStartSince = DateTime.now().toUtc();
    } else {
      _timer?.cancel();

      hours = widget.taskInfo.hours +
          Utils.getTimerDuration(widget.taskInfo.timerStartSince!);
      timerStartSince = null;
    }

    final TaskInfo updatedTaskInfo = TaskInfo(
        taskId: widget.taskInfo.taskId,
        taskName: widget.taskInfo.taskName,
        taskDescription: widget.taskInfo.taskDescription,
        taskStatus: widget.taskInfo.taskStatus,
        createdOn: widget.taskInfo.createdOn,
        doneOn: widget.taskInfo.doneOn,
        timerStartSince: timerStartSince,
        hours: hours);
  }
}
