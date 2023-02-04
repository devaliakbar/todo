import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/task/domain/usecases/export_tasks_csv.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';

class TaskEditController {
  final CreateTask _createTask;
  final UpdateTask _updateTask;
  final ExportTasksCsv _exportTasksCsv;

  const TaskEditController(
      {required CreateTask createTask,
      required UpdateTask updateTask,
      required ExportTasksCsv exportTasksCsv})
      : _createTask = createTask,
        _updateTask = updateTask,
        _exportTasksCsv = exportTasksCsv;

  Future<Either<Failure, TaskInfo>> createTask(CreateTaskParams task) async =>
      await _createTask(task);

  Future<Either<Failure, TaskInfo>> updateTask(UpdateTaskParams task) async =>
      await _updateTask(task);

  Future<Either<Failure, String>> exportTasksToCsv(
          List<TaskInfo> tasks) async =>
      await _exportTasksCsv(Param(tasks: tasks));
}
