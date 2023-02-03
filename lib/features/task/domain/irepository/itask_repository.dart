import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';

abstract class ItaskRepository {
  Future<Either<Failure, TaskInfo>> createTask(
      CreateTaskParams createTaskParams);
  Future<Either<Failure, TaskInfo>> updateTask(
      UpdateTaskParams updateTaskParams);

  Future<Either<Failure, List<TaskInfo>>> getTasks();

  Future<Either<Failure, List<TimesheetTask>>> getTasksTimesheet(String taskId);
}
