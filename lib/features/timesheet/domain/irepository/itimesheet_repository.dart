import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/timesheet/domain/entity/tasks_timesheet.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';

abstract class ITimesheetRepository {
  Future<Either<Failure, TasksTimesheet>> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams);

  Future<Either<Failure, void>> updateTaskStatus(
      UpdateTimesheetParams updateTaskStatusParams);
}
