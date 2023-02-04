import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/timesheet/domain/entity/tasks_timesheet.dart';
import 'package:todo/features/timesheet/domain/irepository/itimesheet_repository.dart';

class GetTasksTimesheet extends UseCase<TasksTimesheet, GetTimesheetParams> {
  final ITimesheetRepository _timesheetRepository;

  GetTasksTimesheet({required ITimesheetRepository timesheetRepository})
      : _timesheetRepository = timesheetRepository;

  @override
  Future<Either<Failure, TasksTimesheet>> call(
      GetTimesheetParams params) async {
    return await _timesheetRepository.getTasksTimesheet(params);
  }
}

class GetTimesheetParams extends Equatable {
  final String? userId;
  final String? taskId;

  const GetTimesheetParams({this.taskId, this.userId});

  @override
  List<Object?> get props => [taskId];
}
