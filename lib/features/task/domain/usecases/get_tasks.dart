import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/irepository/itask_repository.dart';

class GetTasks extends UseCase<List<TaskInfo>, GetTasksParams> {
  final ItaskRepository _taskRepository;

  GetTasks({required ItaskRepository taskRepository})
      : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, List<TaskInfo>>> call(GetTasksParams params) async {
    return await _taskRepository.getTasks(params);
  }
}

class GetTasksParams extends Equatable {
  final String ownerId;
  final bool? getCompltedTask;

  const GetTasksParams({required this.ownerId, required this.getCompltedTask});

  @override
  List<Object?> get props => [ownerId, getCompltedTask];
}
