import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/error/exceptions.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/task/data/model/task_info_model.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';

abstract class ITaskRemoteDataSource {
  /// Throws a [FirestoreException] for any failure.
  Future<TaskInfoModel> createTask(CreateTaskParams createTaskParams);

  /// Throws a [FirestoreException] for any failure.
  Future<TaskInfoModel> updateTask(UpdateTaskParams updateTaskParams);
}

class TaskRemoteDataSource extends ITaskRemoteDataSource {
  final Logger _logger;

  TaskRemoteDataSource({required Logger logger}) : _logger = logger;

  @override
  Future<TaskInfoModel> createTask(CreateTaskParams createTaskParams) async {
    final Map<String, dynamic> createTaskJson =
        TaskInfoModel.toFirestoreCreateJson(createTaskParams);

    CollectionReference tasks =
        FirebaseFirestore.instance.collection(FirestoreCollectionNames.cTasks);

    try {
      var result = await tasks.add(createTaskJson);
      _logger.e("Successfully created task");

      return TaskInfoModel.fromFirestore(result.id, createTaskJson);
    } catch (e) {
      _logger.e("Failed to create task : $e");
    }

    throw FirestoreException();
  }

  @override
  Future<TaskInfoModel> updateTask(UpdateTaskParams updateTaskParams) async {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
