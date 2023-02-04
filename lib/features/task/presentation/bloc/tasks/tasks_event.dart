part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TasksEvent {
  final bool? getCompltedTask;

  const GetTasksEvent({this.getCompltedTask});

  @override
  List<Object?> get props => [getCompltedTask];
}
