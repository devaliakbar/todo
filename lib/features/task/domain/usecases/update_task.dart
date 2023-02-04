import 'package:todo/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:todo/core/usecases/usecase.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/irepository/itask_repository.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';

class UpdateTask extends UseCase<TaskInfo, UpdateTaskParams> {
  final ItaskRepository taskRepository;
  UpdateTask({required this.taskRepository});

  @override
  Future<Either<Failure, TaskInfo>> call(UpdateTaskParams params) async {
    return await taskRepository.updateTask(params);
  }
}

class UpdateTaskParams extends CreateTaskParams {
  final String taskId;
  final DateTime taskCreatedTime;
  final List<UserInfo> removedUsers;

  const UpdateTaskParams(
      {required this.taskId,
      required super.creatorInfo,
      required this.taskCreatedTime,
      required super.taskName,
      required super.taskDescription,
      required super.users,
      required this.removedUsers});

  @override
  List<Object?> get props =>
      [...super.props, taskId, taskCreatedTime, removedUsers];
}
