import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';

class TimesheetEditController {
  final UpdateTimesheetStatus _updateTimesheetStatus;

  TimesheetEditController(
      {required UpdateTimesheetStatus updateTimesheetStatus})
      : _updateTimesheetStatus = updateTimesheetStatus;

  Future<Either<Failure, void>> updateTimesheet(
      {required UpdateTimesheetParams updateTimesheetParams}) async {
    return await _updateTimesheetStatus(updateTimesheetParams);
  }
}
