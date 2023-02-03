import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';

abstract class ITimesheetRepository {
  Future<Either<Failure, List<TimesheetTask>>> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams);
}
