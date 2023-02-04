import 'package:equatable/equatable.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';

class TaskStatusChangeModel extends Equatable {
  final String taskId;
  final Duration? totalHours;
  final bool isComplete;
  final DateTime? completedOn;

  const TaskStatusChangeModel(
      {required this.taskId,
      required this.totalHours,
      required this.isComplete,
      required this.completedOn});

  @override
  List<Object?> get props => [taskId, totalHours, isComplete];

  static Map<String, dynamic> getTimesheetUpdateJson(
      UpdateTimesheetStatusParam updateTimesheetStatusParam) {
    return {
      "taskStatus":
          Utils.getTaskStatusInString(updateTimesheetStatusParam.taskStatus),
      "doneOn": updateTimesheetStatusParam.doneOn != null
          ? (updateTimesheetStatusParam.doneOn.toString())
          : null,
      "hours": updateTimesheetStatusParam.hours.toString(),
      "timerStartSince": updateTimesheetStatusParam.timerStartSince != null
          ? (updateTimesheetStatusParam.timerStartSince.toString())
          : null
    };
  }

  static Map<String, dynamic> getTaskUpdateJson(
      TaskStatusChangeModel taskStatusChangeModel) {
    return {
      "totalHours": taskStatusChangeModel.totalHours.toString(),
      "isCompleted": taskStatusChangeModel.isComplete,
      "completedOn": taskStatusChangeModel.completedOn != null
          ? (taskStatusChangeModel.completedOn.toString())
          : null,
    };
  }
}
