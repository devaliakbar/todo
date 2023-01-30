import 'package:equatable/equatable.dart';

enum TaskStatus { todo, inProgress, done }

class TaskInfo extends Equatable {
  final String taskId;
  final String taskName;
  final String taskDescription;
  final TaskStatus taskStatus;
  final DateTime createdOn;
  final DateTime? doneOn;
  final Duration hours;

  const TaskInfo(
      {required this.taskId,
      required this.taskName,
      required this.taskDescription,
      required this.taskStatus,
      required this.createdOn,
      this.doneOn,
      required this.hours});

  @override
  List<Object?> get props =>
      [taskId, taskName, taskDescription, taskStatus, createdOn, doneOn, hours];
}
