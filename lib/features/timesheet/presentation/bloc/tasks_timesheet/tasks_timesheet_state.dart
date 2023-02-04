part of 'tasks_timesheet_bloc.dart';

abstract class TasksTimesheetState extends Equatable {
  const TasksTimesheetState();

  @override
  List<Object> get props => [];
}

class TasksTimesheetInitial extends TasksTimesheetState {}

class TasksTimesheetLoading extends TasksTimesheetState {}

class TasksTimesheetLoadFail extends TasksTimesheetState {}

class TasksTimesheetLoaded extends TasksTimesheetState {
  final TasksTimesheet tasks;

  const TasksTimesheetLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}
