import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';
import 'package:todo/features/user/data/model/user_info_model.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

class TaskInfoModel extends TaskInfo {
  const TaskInfoModel(
      {required super.taskId,
      required super.taskName,
      required super.taskDescription,
      required super.isCompleted,
      required super.totalHours,
      required super.createdOn,
      required super.completedOn,
      required super.assignedTo});

  factory TaskInfoModel.fromFirestore(
      String taskId, Map<String, dynamic> json) {
    return TaskInfoModel(
      taskId: taskId,
      taskName: json["taskName"],
      taskDescription: json["taskDescription"],
      isCompleted: json["isCompleted"],
      totalHours: Utils.parseDuration(json["totalHours"]),
      createdOn: DateTime.parse(json["createdOn"]),
      completedOn: json["completedOn"] == null
          ? null
          : DateTime.parse(json["completedOn"]),
      assignedTo: json["assignedTo"]
          .map<UserInfo>((e) => UserInfoModel.fromJson(e))
          .toList(),
    );
  }

  static Map<String, dynamic> toFirestoreCreateJson(CreateTaskParams taskInfo) {
    return {
      "taskName": taskInfo.taskName,
      "taskDescription": taskInfo.taskDescription,
      "isCompleted": false,
      "totalHours": Duration.zero.toString(),
      "createdOn": DateTime.now().toUtc().toString(),
      "completedOn": null,
      "assignedTo": taskInfo.users
          .map<Map<String, dynamic>>((e) => UserInfoModel.toJson(e))
          .toList()
    };
  }

  static Map<String, dynamic> toFirestoreUpdateJson(UpdateTaskParams taskInfo) {
    return {
      "taskName": taskInfo.taskName,
      "taskDescription": taskInfo.taskDescription,
      "assignedTo": taskInfo.users
          .map<Map<String, dynamic>>((e) => UserInfoModel.toJson(e))
          .toList()
    };
  }
}
