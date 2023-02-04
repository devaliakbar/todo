import 'package:equatable/equatable.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';

class TasksTimesheet extends Equatable {
  final List<TimesheetTask> todoTasks;
  final List<TimesheetTask> inprogressTasks;
  final List<TimesheetTask> doneTasks;

  const TasksTimesheet(
      {required this.todoTasks,
      required this.inprogressTasks,
      required this.doneTasks});

  @override
  List<Object?> get props => [todoTasks, inprogressTasks, doneTasks];
}
