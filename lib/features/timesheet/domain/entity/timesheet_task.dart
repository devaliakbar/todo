import 'package:todo/features/task/domain/entity/base_task.dart';

enum TimesheetTaskStatus { todo, inProgress, done }

class TimesheetTask extends BaseTask {
  final String timesheetId;
  final String assignedToPersonId;
  final String creatorId;
  final String creatorName;
  final TimesheetTaskStatus taskStatus;
  final DateTime? doneOn;
  final DateTime? timerStartSince;
  final Duration hours;

  const TimesheetTask(
      {required this.timesheetId,
      required this.assignedToPersonId,
      required this.creatorId,
      required this.creatorName,
      required super.taskId,
      required super.taskName,
      required super.taskDescription,
      required this.taskStatus,
      required super.createdOn,
      required this.doneOn,
      required this.timerStartSince,
      required this.hours});

  @override
  List<Object?> get props => [
        timesheetId,
        assignedToPersonId,
        creatorId,
        creatorName,
        taskId,
        taskName,
        taskDescription,
        taskStatus,
        createdOn,
        doneOn,
        timerStartSince,
        hours
      ];
}
