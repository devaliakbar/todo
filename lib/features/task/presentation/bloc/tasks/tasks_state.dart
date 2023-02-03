part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoadFail extends TasksState {}

class TasksLoaded extends TasksState {
  final List<TaskInfo> tasks;

  const TasksLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}
