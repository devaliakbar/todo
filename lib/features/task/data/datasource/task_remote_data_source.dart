import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/error/exceptions.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/core/service/app_notification_service.dart';
import 'package:todo/core/service/notification_message_model.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/data/model/task_info_model.dart';
import 'package:todo/features/task/domain/entity/base_task.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/task/domain/usecases/get_tasks.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';
import 'package:todo/features/timesheet/data/model/timesheet_task_model.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/user/data/model/user_info_model.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

abstract class ITaskRemoteDataSource {
  /// Throws a [FirestoreException] for any failure.
  Future<TaskInfoModel> createTask(CreateTaskParams createTaskParams);

  /// Throws a [FirestoreException] for any failure.
  Future<TaskInfoModel> updateTask(UpdateTaskParams updateTaskParams);

  Future<List<TaskInfoModel>> getTasks(GetTasksParams params);

  /// Throws a [FirestoreException] for any failure.
  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSource extends ITaskRemoteDataSource {
  final AppNotificationService _appNotificationService;
  final Logger _logger;

  TaskRemoteDataSource(
      {required AppNotificationService appNotificationService,
      required Logger logger})
      : _appNotificationService = appNotificationService,
        _logger = logger;

  ///***************************************************************************************************************************///                                              ///
  ///                                                                                                                           ///
  ///***************************************************************************************************************************///
  @override
  Future<TaskInfoModel> createTask(CreateTaskParams createTaskParams) async {
    CollectionReference tasks =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cTasks);

    CollectionReference timesheetTasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);

    try {
      ///Transaction
      WriteBatch writeBatch = FirebaseFirestore.instance.batch();

      ///Creating task
      final Map<String, dynamic> createTaskJson =
          TaskInfoModel.toFirestoreCreateJson(createTaskParams);
      var newTask = tasks.doc();
      writeBatch.set(newTask, createTaskJson);

      ///Creating timesheet tasks for each users which are assigned
      for (UserInfo userInfo in createTaskParams.users) {
        final Map<String, dynamic> createTimesheetTaskJson =
            TimesheetTaskModel.toFirestoreCreateJson(
                userInfo.id,
                createTaskParams.creatorInfo,
                BaseTask(
                    taskId: newTask.id,
                    taskName: createTaskParams.taskName,
                    taskDescription: createTaskParams.taskDescription,
                    createdOn: DateTime.parse(createTaskJson["createdOn"])));

        var newTimesheetTask = timesheetTasks.doc();
        writeBatch.set(newTimesheetTask, createTimesheetTaskJson);
      }

      // Commit
      await writeBatch.commit();
      _logger.i("Successfully created task");

      _sendNotification(createTaskParams.users);

      return TaskInfoModel.fromFirestore(newTask.id, createTaskJson);
    } catch (e) {
      _logger.e("Failed to create task : $e");
    }

    throw FirestoreException();
  }

  ///***************************************************************************************************************************///                                              ///
  ///                                                                                                                           ///
  ///***************************************************************************************************************************///
  @override
  Future<TaskInfoModel> updateTask(UpdateTaskParams updateTaskParams) async {
    CollectionReference tasks =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cTasks);

    CollectionReference timesheetTasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);
    try {
      var taskResult = await tasks
          .where(FieldPath.documentId, isEqualTo: updateTaskParams.taskId)
          .get();

      if (taskResult.docs.isNotEmpty) {
        ///Transaction
        WriteBatch writeBatch = FirebaseFirestore.instance.batch();

        ///Deleting old user's timesheet and update new details
        var timesheetQuery = await timesheetTasks
            .where('taskId', isEqualTo: updateTaskParams.taskId)
            .get();

        final List<UserInfo> newUsers = [...updateTaskParams.users];

        ///This is for reduce the deleted users hours from the task total hour
        Duration reduceDuration = Duration.zero;

        bool isCurrentTaskCompleted = true;
        for (var element in timesheetQuery.docs) {
          final TimesheetTaskModel timesheetTaskModel =
              TimesheetTaskModel.fromFirestore(
                  element.id, element.data() as Map<String, dynamic>);

          var matchIndex = updateTaskParams.removedUsers.indexWhere(
              (element) => element.id == timesheetTaskModel.assignedToPersonId);

          ///This timesheet will be deleted
          if (matchIndex != -1) {
            reduceDuration += timesheetTaskModel.hours;

            writeBatch.delete(element.reference);
          } else {
            if (timesheetTaskModel.taskStatus != TimesheetTaskStatus.done) {
              isCurrentTaskCompleted = false;
            }

            ///Updating new values
            writeBatch.update(
                element.reference,
                TimesheetTaskModel.toFirestoreUpdateTaskDetailsJson(
                    updateTaskParams));

            newUsers.removeWhere((element) =>
                element.id == timesheetTaskModel.assignedToPersonId);
          }
        }

        if (newUsers.isNotEmpty) {
          isCurrentTaskCompleted = false;
        }

        ///Creating timesheet tasks for each users which are newly assigned
        for (UserInfo userInfo in newUsers) {
          final Map<String, dynamic> createTimesheetTaskJson =
              TimesheetTaskModel.toFirestoreCreateJson(
                  userInfo.id,
                  updateTaskParams.creatorInfo,
                  BaseTask(
                      taskId: updateTaskParams.taskId,
                      taskName: updateTaskParams.taskName,
                      taskDescription: updateTaskParams.taskDescription,
                      createdOn: updateTaskParams.taskCreatedTime));

          var newTimesheetTask = timesheetTasks.doc();
          writeBatch.set(newTimesheetTask, createTimesheetTaskJson);
        }

        ///Reducing deleted users durations from total duration
        final Duration updatedHours =
            Utils.parseDuration(taskResult.docs.single["totalHours"]) -
                reduceDuration;

        ///Updating task
        final Map<String, dynamic> updateTaskJson =
            TaskInfoModel.toFirestoreUpdateJson(
                updateTaskParams, isCurrentTaskCompleted, updatedHours);
        writeBatch.update(taskResult.docs.single.reference, updateTaskJson);

        // Commit
        await writeBatch.commit();

        // Re-fetching updated data
        taskResult = await tasks
            .where(FieldPath.documentId, isEqualTo: updateTaskParams.taskId)
            .get();

        _sendNotification(newUsers);

        return TaskInfoModel.fromFirestore(taskResult.docs.single.id,
            taskResult.docs.single.data() as Map<String, dynamic>);
      }
    } catch (e) {
      _logger.e("Failed to update task : $e");
    }

    throw FirestoreException();
  }

  ///***************************************************************************************************************************///                                              ///
  ///                                                                                                                           ///
  ///***************************************************************************************************************************///
  @override
  Future<List<TaskInfoModel>> getTasks(GetTasksParams params) async {
    CollectionReference tasks =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cTasks);

    String? where;
    bool? isEqualTo;

    if (params.getCompltedTask != null) {
      where = "isCompleted";
      isEqualTo = params.getCompltedTask;
    }

    QuerySnapshot<Object?> result;
    if (where != null && isEqualTo != null) {
      result = await tasks
          .where(where, isEqualTo: isEqualTo)
          .where("creatorId", isEqualTo: params.ownerId)
          .orderBy('createdOn', descending: true)
          .get();
    } else {
      result = await tasks
          .where("creatorId", isEqualTo: params.ownerId)
          .orderBy('createdOn', descending: true)
          .get();
    }

    List<TaskInfoModel> tasksRes = [];
    for (var element in result.docs) {
      tasksRes.add(TaskInfoModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    return tasksRes;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    CollectionReference tasks =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cTasks);

    CollectionReference timesheetTasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);

    try {
      ///Transaction
      WriteBatch writeBatch = FirebaseFirestore.instance.batch();

      var taskResult =
          await tasks.where(FieldPath.documentId, isEqualTo: taskId).get();

      writeBatch.delete(taskResult.docs.single.reference);

      var timesheetQuery =
          await timesheetTasks.where('taskId', isEqualTo: taskId).get();

      for (var element in timesheetQuery.docs) {
        writeBatch.delete(element.reference);
      }

      await writeBatch.commit();
    } catch (e) {
      _logger.e("Failed to delete task : $e");
      throw FirestoreException();
    }
  }

  Future<void> _sendNotification(List<UserInfo> usersList) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cUser);

    var result = await users
        .where("id", whereIn: usersList.map<String>((e) => e.id).toList())
        .get();

    const NotificationMessageModel message = NotificationMessageModel(
        messageTitle: "New task", messsageBody: "You got a new task");

    for (var element in result.docs) {
      final UserInfoResponseModel userRes = UserInfoResponseModel.fromJson(
          element.data() as Map<String, dynamic>);

      for (String token in userRes.notificationTokens) {
        _appNotificationService.sendNotification(
            userToken: token, model: message);
      }
    }
  }
}
