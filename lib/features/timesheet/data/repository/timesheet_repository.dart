import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/timesheet/data/datasource/timesheet_remore_data_source.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/irepository/itimesheet_repository.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';

class TimesheetRepository extends ITimesheetRepository {
  final ITimesheetRemoreDataSource _timesheetRemoreDataSource;

  TimesheetRepository(
      {required ITimesheetRemoreDataSource timesheetRemoreDataSource})
      : _timesheetRemoreDataSource = timesheetRemoreDataSource;

  @override
  Future<Either<Failure, List<TimesheetTask>>> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams) async {
    try {
      return Right(await _timesheetRemoreDataSource
          .getTasksTimesheet(getTimesheetParams));
    } catch (_) {}

    return Left(UnexpectedFailure());
  }
}
