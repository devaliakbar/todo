import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/error/exceptions.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/data/model/task_info_model.dart';
import 'package:todo/features/task/domain/entity/base_task.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';
import 'package:todo/features/timesheet/data/model/timesheet_task_model.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

abstract class ITaskRemoteDataSource {
  /// Throws a [FirestoreException] for any failure.
  Future<TaskInfoModel> createTask(CreateTaskParams createTaskParams);

  /// Throws a [FirestoreException] for any failure.
  Future<TaskInfoModel> updateTask(UpdateTaskParams updateTaskParams);

  Future<List<TaskInfoModel>> getTasks();

  Future<List<TimesheetTaskModel>> getTasksTimesheet(String taskId);
}

class TaskRemoteDataSource extends ITaskRemoteDataSource {
  final Logger _logger;

  TaskRemoteDataSource({required Logger logger}) : _logger = logger;

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

        ///This is for reduce the deleted users hours from the task total hour
        Duration reduceDuration = Duration.zero;
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
            ///Updating new values
            writeBatch.update(
                element.reference,
                TimesheetTaskModel.toFirestoreUpdateTaskDetailsJson(
                    updateTaskParams));
          }
        }

        ///Reducing deleted users durations from total duration
        final Duration updatedHours =
            Utils.parseDuration(taskResult.docs.single["totalHours"]) -
                reduceDuration;

        ///Updating task
        final Map<String, dynamic> updateTaskJson =
            TaskInfoModel.toFirestoreUpdateJson(updateTaskParams, updatedHours);
        writeBatch.update(taskResult.docs.single.reference, updateTaskJson);

        // Commit
        await writeBatch.commit();

        // Re-fetching updated data
        taskResult = await tasks
            .where(FieldPath.documentId, isEqualTo: updateTaskParams.taskId)
            .get();

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
  Future<List<TaskInfoModel>> getTasks() async {
    CollectionReference tasks =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cTasks);

    var result = await tasks.orderBy('createdOn', descending: true).get();

    List<TaskInfoModel> tasksRes = [];
    for (var element in result.docs) {
      tasksRes.add(TaskInfoModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    return tasksRes;
  }

  @override
  Future<List<TimesheetTaskModel>> getTasksTimesheet(String taskId) async {
    CollectionReference tasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);

    var result = await tasks
        .where('taskId', isEqualTo: taskId)
        // .orderBy('createdOn', descending: true)
        .get();

    List<TimesheetTaskModel> tasksRes = [];
    for (var element in result.docs) {
      tasksRes.add(TimesheetTaskModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    return tasksRes;
  }
}
