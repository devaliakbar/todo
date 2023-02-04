import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/irepository/itask_repository.dart';

class ExportTasksCsv extends UseCase<String, Param> {
  final ItaskRepository _taskRepository;

  ExportTasksCsv({required ItaskRepository taskRepository})
      : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, String>> call(Param params) async {
    return await _taskRepository.exportTasksToCsv(params.tasks);
  }
}

class Param extends Equatable {
  final List<TaskInfo> tasks;

  const Param({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}
