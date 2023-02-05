import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/core/service/app_notification_service.dart';
import 'package:todo/core/service/notification_message_model.dart';
import 'package:todo/features/task/data/model/task_info_model.dart';
import 'package:todo/features/timesheet/data/model/task_status_change_model.dart';
import 'package:todo/features/timesheet/data/model/tasks_timesheet_model.dart';
import 'package:todo/features/timesheet/data/model/timesheet_task_model.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';
import 'package:todo/features/user/data/model/user_info_model.dart';

abstract class ITimesheetRemoreDataSource {
  Future<TasksTimesheetModel> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams);

  Future<TaskInfoModel> getTask(String taskId);

  Future<TimesheetTaskModel> getTimesheetTask(String timesheetId);

  Future<void> updateTimesheet(UpdateTimesheetStatusParam updatedTimesheet,
      TaskStatusChangeModel? updatedTask);

  Future<void> sendNotification(String creatorId);
}

class TimesheetRemoreDataSource extends ITimesheetRemoreDataSource {
  final AppNotificationService _appNotificationService;
  final Logger _logger;

  TimesheetRemoreDataSource(
      {required AppNotificationService appNotificationService,
      required Logger logger})
      : _appNotificationService = appNotificationService,
        _logger = logger;

  @override
  Future<TasksTimesheetModel> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams) async {
    String where = "";
    String isEqualTo = "";
    if (getTimesheetParams.taskId != null) {
      where = "taskId";
      isEqualTo = getTimesheetParams.taskId!;
    }

    if (getTimesheetParams.userId != null) {
      where = "assignedToPersonId";
      isEqualTo = getTimesheetParams.userId!;
    }

    _logger.i("Filter: '$where' Value : '$isEqualTo'");

    CollectionReference tasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);

    ///Getting all the todo tasks
    var result = await tasks
        .where(where, isEqualTo: isEqualTo)
        .where("taskStatus", isEqualTo: "todo")
        .orderBy('createdOn', descending: true)
        .get();
    List<TimesheetTaskModel> todoTasks = [];
    for (var element in result.docs) {
      todoTasks.add(TimesheetTaskModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    ///Getting all the todo inprogress tasks
    result = await tasks
        .where(where, isEqualTo: isEqualTo)
        .where("taskStatus", isEqualTo: "inProgress")
        .orderBy('createdOn', descending: true)
        .get();
    List<TimesheetTaskModel> inprogressTasks = [];
    for (var element in result.docs) {
      inprogressTasks.add(TimesheetTaskModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    ///Getting all the todo done tasks
    result = await tasks
        .where(where, isEqualTo: isEqualTo)
        .where("taskStatus", isEqualTo: "done")
        .orderBy('createdOn', descending: true)
        .get();
    List<TimesheetTaskModel> doneTasks = [];
    for (var element in result.docs) {
      doneTasks.add(TimesheetTaskModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    final TasksTimesheetModel tasksTimesheetModel = TasksTimesheetModel(
        todoTasks: todoTasks,
        inprogressTasks: inprogressTasks,
        doneTasks: doneTasks);

    return tasksTimesheetModel;
  }

  @override
  Future<TaskInfoModel> getTask(String taskId) async {
    CollectionReference tasks =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cTasks);

    var result =
        await tasks.where(FieldPath.documentId, isEqualTo: taskId).get();

    return TaskInfoModel.fromFirestore(result.docs.single.id,
        result.docs.single.data() as Map<String, dynamic>);
  }

  @override
  Future<TimesheetTaskModel> getTimesheetTask(String timesheetId) async {
    CollectionReference timesheetTasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);

    var result = await timesheetTasks
        .where(FieldPath.documentId, isEqualTo: timesheetId)
        .get();

    return TimesheetTaskModel.fromFirestore(result.docs.single.id,
        result.docs.single.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateTimesheet(UpdateTimesheetStatusParam updatedTimesheet,
      TaskStatusChangeModel? updatedTask) async {
    CollectionReference tasks =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cTasks);

    CollectionReference timesheetTasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);

    try {
      ///Transaction
      WriteBatch writeBatch = FirebaseFirestore.instance.batch();

      var timesheetQuery = await timesheetTasks
          .where(FieldPath.documentId, isEqualTo: updatedTimesheet.timesheetId)
          .get();

      ///Updating timesheet
      writeBatch.update(timesheetQuery.docs.single.reference,
          TaskStatusChangeModel.getTimesheetUpdateJson(updatedTimesheet));

      ///Updating task
      if (updatedTask != null) {
        var taskQuery = await tasks
            .where(FieldPath.documentId, isEqualTo: updatedTask.taskId)
            .get();

        writeBatch.update(taskQuery.docs.single.reference,
            TaskStatusChangeModel.getTaskUpdateJson(updatedTask));
      }

      // Commit
      await writeBatch.commit();
    } catch (e) {
      _logger.e("Failed to update timesheet : $e");
    }
  }

  @override
  Future<void> sendNotification(String creatorId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cUser);

    var result = await users.where("id", isEqualTo: creatorId).get();
    final UserInfoResponseModel userRes = UserInfoResponseModel.fromJson(
        result.docs.single.data() as Map<String, dynamic>);

    const NotificationMessageModel message = NotificationMessageModel(
        messageTitle: "Task done",
        messsageBody: "One user completed your task.");

    for (String token in userRes.notificationTokens) {
      _appNotificationService.sendNotification(
          userToken: token, model: message);
    }
  }
}
