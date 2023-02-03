import 'package:equatable/equatable.dart';
import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/irepository/itask_repository.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

class CreateTask extends UseCase<TaskInfo, CreateTaskParams> {
  final ItaskRepository taskRepository;
  CreateTask({required this.taskRepository});

  @override
  Future<Either<Failure, TaskInfo>> call(CreateTaskParams params) async {
    return await taskRepository.createTask(params);
  }
}

class CreateTaskParams extends Equatable {
  final UserInfo creatorInfo;
  final String taskName;
  final String taskDescription;
  final List<UserInfo> users;

  const CreateTaskParams(
      {required this.creatorInfo,
      required this.taskName,
      required this.taskDescription,
      required this.users});

  @override
  List<Object?> get props => [taskName, taskDescription, users];
}
