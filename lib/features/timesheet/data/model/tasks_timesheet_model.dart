import 'package:todo/features/timesheet/domain/entity/tasks_timesheet.dart';

class TasksTimesheetModel extends TasksTimesheet {
  const TasksTimesheetModel(
      {required super.todoTasks,
      required super.inprogressTasks,
      required super.doneTasks});
}
