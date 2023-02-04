import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/timesheet/data/model/tasks_timesheet_model.dart';
import 'package:todo/features/timesheet/data/model/timesheet_task_model.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';

abstract class ITimesheetRemoreDataSource {
  Future<TasksTimesheetModel> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams);
}

class TimesheetRemoreDataSource extends ITimesheetRemoreDataSource {
  final Logger _logger;

  TimesheetRemoreDataSource({required Logger logger}) : _logger = logger;

  @override
  Future<TasksTimesheetModel> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams) async {
    String where = "";
    String isEqualTo = "";
    if (getTimesheetParams.taskId != null) {
      where = "taskId";
      isEqualTo = getTimesheetParams.taskId!;
    }

    if (getTimesheetParams.userId != null) {
      where = "assignedToPersonId";
      isEqualTo = getTimesheetParams.userId!;
    }

    _logger.i("Filter: '$where' Value : '$isEqualTo'");

    CollectionReference tasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);

    ///Getting all the todo tasks
    var result = await tasks
        .where(where, isEqualTo: isEqualTo)
        .where("taskStatus", isEqualTo: "todo")
        .orderBy('createdOn', descending: true)
        .get();
    List<TimesheetTaskModel> todoTasks = [];
    for (var element in result.docs) {
      todoTasks.add(TimesheetTaskModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    ///Getting all the todo inprogress tasks
    result = await tasks
        .where(where, isEqualTo: isEqualTo)
        .where("taskStatus", isEqualTo: "inProgress")
        .orderBy('createdOn', descending: true)
        .get();
    List<TimesheetTaskModel> inprogressTasks = [];
    for (var element in result.docs) {
      inprogressTasks.add(TimesheetTaskModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    ///Getting all the todo done tasks
    result = await tasks
        .where(where, isEqualTo: isEqualTo)
        .where("taskStatus", isEqualTo: "done")
        .orderBy('createdOn', descending: true)
        .get();
    List<TimesheetTaskModel> doneTasks = [];
    for (var element in result.docs) {
      doneTasks.add(TimesheetTaskModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    final TasksTimesheetModel tasksTimesheetModel = TasksTimesheetModel(
        todoTasks: todoTasks,
        inprogressTasks: inprogressTasks,
        doneTasks: doneTasks);

    return tasksTimesheetModel;
  }
}
