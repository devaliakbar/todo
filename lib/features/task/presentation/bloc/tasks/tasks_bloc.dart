import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/usecases/get_tasks.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasks _getTasks;

  TasksBloc({required GetTasks getTasks})
      : _getTasks = getTasks,
        super(TasksInitial()) {
    on<GetTasksEvent>(_mapGetTasksEvent);
  }

  Future<void> _mapGetTasksEvent(
      GetTasksEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());

    final Either<Failure, List<TaskInfo>> result = await _getTasks(
        GetTasksParams(
            ownerId: event.ownerId, getCompltedTask: event.getCompltedTask));

    result.fold((l) => emit(TasksLoadFail()),
        (List<TaskInfo> r) => emit(TasksLoaded(tasks: r)));
  }
}
