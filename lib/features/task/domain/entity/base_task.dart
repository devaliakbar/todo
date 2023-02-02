import 'package:equatable/equatable.dart';

class BaseTask extends Equatable {
  final String taskId;
  final String taskName;
  final String taskDescription;
  final DateTime createdOn;

  const BaseTask(
      {required this.taskId,
      required this.taskName,
      required this.taskDescription,
      required this.createdOn});

  @override
  List<Object?> get props => [taskId, taskName, taskDescription, createdOn];
}
