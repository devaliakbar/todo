part of 'tasks_timesheet_bloc.dart';

abstract class TasksTimesheetEvent extends Equatable {
  const TasksTimesheetEvent();

  @override
  List<Object> get props => [];
}

class GetTasksTimesheetEvent extends TasksTimesheetEvent {
  final String taskId;

  const GetTasksTimesheetEvent({required this.taskId});

  @override
  List<Object> get props => [taskId];
}
