part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TasksEvent {
  final String ownerId;
  final bool? getCompltedTask;

  const GetTasksEvent({required this.ownerId, this.getCompltedTask});

  @override
  List<Object?> get props => [ownerId, getCompltedTask];
}
