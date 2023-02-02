import 'package:todo/features/auth/domain/enity/user_info.dart';
import 'package:todo/features/task/domain/entity/base_task.dart';

class TaskInfo extends BaseTask {
  final bool isCompleted;
  final double totalHours;
  final DateTime? completedOn;
  final List<UserInfo> assignedTo;

  const TaskInfo(
      {required super.taskId,
      required super.taskName,
      required super.taskDescription,
      required this.isCompleted,
      required this.totalHours,
      required super.createdOn,
      required this.completedOn,
      required this.assignedTo});

  @override
  List<Object?> get props => [
        taskId,
        taskName,
        taskDescription,
        isCompleted,
        totalHours,
        createdOn,
        completedOn,
        assignedTo
      ];
}
