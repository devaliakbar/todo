import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/irepository/itimesheet_repository.dart';

class UpdateTimesheetStatus
    extends UseCase<TimesheetTask, UpdateTimesheetParams> {
  final ITimesheetRepository _timesheetRepository;

  UpdateTimesheetStatus({required ITimesheetRepository timesheetRepository})
      : _timesheetRepository = timesheetRepository;

  @override
  Future<Either<Failure, TimesheetTask>> call(
      UpdateTimesheetParams params) async {
    return await _timesheetRepository.updateTaskStatus(params);
  }
}

class UpdateTimesheetParams extends Equatable {
  final UpdateTimesheetStatusParam oldTask;
  final UpdateTimesheetStatusParam updatedTask;

  const UpdateTimesheetParams(
      {required this.oldTask, required this.updatedTask});

  @override
  List<Object?> get props => [oldTask, updatedTask];
}

class UpdateTimesheetStatusParam extends Equatable {
  final String timesheetId;
  final String taskId;
  final TimesheetTaskStatus taskStatus;
  final DateTime? doneOn;
  final DateTime? timerStartSince;
  final Duration hours;

  const UpdateTimesheetStatusParam({
    required this.timesheetId,
    required this.taskId,
    required this.taskStatus,
    required this.doneOn,
    required this.timerStartSince,
    required this.hours,
  });

  @override
  List<Object?> get props => [];
}
