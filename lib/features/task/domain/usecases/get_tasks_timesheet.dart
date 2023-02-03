import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/task/domain/irepository/itask_repository.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';

class GetTasksTimesheet extends UseCase<List<TimesheetTask>, Params> {
  final ItaskRepository _taskRepository;

  GetTasksTimesheet({required ItaskRepository taskRepository})
      : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, List<TimesheetTask>>> call(Params params) async {
    return await _taskRepository.getTasksTimesheet(params.taskId);
  }
}

class Params extends Equatable {
  final String taskId;

  const Params({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
