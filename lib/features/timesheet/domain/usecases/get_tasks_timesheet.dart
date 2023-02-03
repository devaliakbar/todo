import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/irepository/itimesheet_repository.dart';

class GetTasksTimesheet
    extends UseCase<List<TimesheetTask>, GetTimesheetParams> {
  final ITimesheetRepository _timesheetRepository;

  GetTasksTimesheet({required ITimesheetRepository timesheetRepository})
      : _timesheetRepository = timesheetRepository;

  @override
  Future<Either<Failure, List<TimesheetTask>>> call(
      GetTimesheetParams params) async {
    return await _timesheetRepository.getTasksTimesheet(params);
  }
}

class GetTimesheetParams extends Equatable {
  final String taskId;

  const GetTimesheetParams({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
