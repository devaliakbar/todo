import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/timesheet/data/model/timesheet_task_model.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';

abstract class ITimesheetRemoreDataSource {
  Future<List<TimesheetTaskModel>> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams);
}

class TimesheetRemoreDataSource extends ITimesheetRemoreDataSource {
  final Logger _logger;

  TimesheetRemoreDataSource({required Logger logger}) : _logger = logger;

  @override
  Future<List<TimesheetTaskModel>> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams) async {
    CollectionReference tasks = FirebaseFirestore.instance
        .collection(FirestoreCollectionNames.cTimesheetTasks);

    var result = await tasks
        .where('taskId', isEqualTo: getTimesheetParams.taskId)
        // .orderBy('createdOn', descending: true)
        .get();

    List<TimesheetTaskModel> tasksRes = [];
    for (var element in result.docs) {
      tasksRes.add(TimesheetTaskModel.fromFirestore(
          element.id, element.data() as Map<String, dynamic>));
    }

    return tasksRes;
  }
}
