import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/task/domain/irepository/itask_repository.dart';

class DeleteTask extends UseCase<void, DeleteTaskParam> {
  final ItaskRepository taskRepository;
  DeleteTask({required this.taskRepository});

  @override
  Future<Either<Failure, void>> call(DeleteTaskParam params) async {
    return await taskRepository.deleteTask(params.taskId);
  }
}

class DeleteTaskParam extends Equatable {
  final String taskId;

  const DeleteTaskParam({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
