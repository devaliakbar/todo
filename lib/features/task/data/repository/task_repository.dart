import 'package:todo/features/task/data/datasource/task_local_data_source.dart';
import 'package:todo/features/task/data/datasource/task_remote_data_source.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/features/task/domain/irepository/itask_repository.dart';
import 'package:todo/features/task/domain/usecases/get_tasks.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';

class TaskRepository extends ItaskRepository {
  final ITaskLocalDataSource _taskLocalDataSource;
  final ITaskRemoteDataSource _taskRemoteDataSource;
  TaskRepository(
      {required ITaskRemoteDataSource taskRemoteDataSource,
      required ITaskLocalDataSource taskLocalDataSource})
      : _taskLocalDataSource = taskLocalDataSource,
        _taskRemoteDataSource = taskRemoteDataSource;

  @override
  Future<Either<Failure, TaskInfo>> createTask(
      CreateTaskParams createTaskParams) async {
    try {
      return Right(await _taskRemoteDataSource.createTask(createTaskParams));
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, TaskInfo>> updateTask(
      UpdateTaskParams updateTaskParams) async {
    try {
      return Right(await _taskRemoteDataSource.updateTask(updateTaskParams));
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, List<TaskInfo>>> getTasks(
      GetTasksParams params) async {
    try {
      return Right(await _taskRemoteDataSource.getTasks(params));
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, String>> exportTasksToCsv(List<TaskInfo> tasks) async {
    try {
      return Right(await _taskLocalDataSource.exportTasksToCsv(tasks));
    } catch (_) {}

    return Left(UnexpectedFailure());
  }
}
