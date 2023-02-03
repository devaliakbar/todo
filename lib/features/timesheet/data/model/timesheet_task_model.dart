import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/base_task.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

class TimesheetTaskModel extends TimesheetTask {
  const TimesheetTaskModel(
      {required super.timesheetId,
      required super.assignedToPersonId,
      required super.creatorId,
      required super.creatorName,
      required super.taskId,
      required super.taskName,
      required super.taskDescription,
      required super.taskStatus,
      required super.createdOn,
      required super.hours,
      required super.timerStartSince,
      required super.doneOn});

  factory TimesheetTaskModel.fromFirestore(
      String timesheetId, Map<String, dynamic> json) {
    return TimesheetTaskModel(
        timesheetId: timesheetId,
        assignedToPersonId: json["assignedToPersonId"],
        creatorId: json["creatorId"],
        creatorName: json["creatorName"],
        taskId: json["taskId"],
        taskName: json["taskName"],
        taskDescription: json["taskDescription"],
        taskStatus: Utils.getTaskStatusInEnum(json["taskStatus"]),
        createdOn: DateTime.parse(json["createdOn"]),
        hours: Utils.parseDuration(json["hours"]),
        timerStartSince: json["timerStartSince"] == null
            ? null
            : DateTime.parse(json["timerStartSince"]),
        doneOn: json["doneOn"] == null ? null : DateTime.parse(json["doneOn"]));
  }

  static Map<String, dynamic> toFirestoreCreateJson(
      String assignedToPersonId, UserInfo creator, BaseTask baseTask) {
    return {
      "assignedToPersonId": assignedToPersonId,
      "creatorId": creator.id,
      "creatorName": creator.fullName,
      "taskId": baseTask.taskId,
      "taskName": baseTask.taskName,
      "taskDescription": baseTask.taskDescription,
      "taskStatus": Utils.getTaskStatusInString(TimesheetTaskStatus.todo),
      "createdOn": baseTask.createdOn.toString(),
      "hours": Duration.zero.toString(),
      "timerStartSince": null,
      "doneOn": null
    };
  }

  static Map<String, dynamic> toFirestoreUpdateTaskDetailsJson(
      UpdateTaskParams updateTaskParams) {
    return {
      "taskName": updateTaskParams.taskName,
      "taskDescription": updateTaskParams.taskDescription,
    };
  }
}
