import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';

class TimesheetEditController {
  final UpdateTimesheetStatus _updateTimesheetStatus;

  TimesheetEditController(
      {required UpdateTimesheetStatus updateTimesheetStatus})
      : _updateTimesheetStatus = updateTimesheetStatus;

  Future<Either<Failure, TimesheetTask>> updateTimesheet(
      {required UpdateTimesheetParams updateTimesheetParams}) async {
    return await _updateTimesheetStatus(updateTimesheetParams);
  }
}
