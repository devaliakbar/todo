part of 'tasks_timesheet_bloc.dart';

abstract class TasksTimesheetEvent extends Equatable {
  const TasksTimesheetEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksTimesheetEvent extends TasksTimesheetEvent {
  final String? taskId;
  final String? userId;

  const GetTasksTimesheetEvent({this.taskId, this.userId});

  @override
  List<Object?> get props => [taskId, userId];
}
