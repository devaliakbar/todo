import 'package:equatable/equatable.dart';

enum TimesheetTaskStatus { todo, inProgress, done }

class TimesheetTask extends Equatable {
  final String taskId;
  final String taskName;
  final String taskDescription;
  final TimesheetTaskStatus taskStatus;
  final DateTime createdOn;
  final DateTime? doneOn;
  final DateTime? timerStartSince;
  final Duration hours;

  const TimesheetTask(
      {required this.taskId,
      required this.taskName,
      required this.taskDescription,
      required this.taskStatus,
      required this.createdOn,
      this.doneOn,
      this.timerStartSince,
      this.hours = Duration.zero});

  @override
  List<Object?> get props => [
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
