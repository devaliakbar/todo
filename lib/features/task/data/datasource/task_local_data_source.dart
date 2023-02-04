import 'dart:io';

import 'package:logger/logger.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:csv/csv.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:external_path/external_path.dart';

abstract class ITaskLocalDataSource {
  Future<String> exportTasksToCsv(List<TaskInfo> tasks);
}

class TaskLocalDataSource extends ITaskLocalDataSource {
  final Logger _logger;

  TaskLocalDataSource({required Logger logger}) : _logger = logger;

  @override
  Future<String> exportTasksToCsv(List<TaskInfo> tasks) async {
    List<List<dynamic>> rows = [];

    List<dynamic> header = [];
    header.add("Sl.No");
    header.add("Task name");
    header.add("Task description");
    header.add("Created at");
    header.add("Total hours");
    header.add("Completed at");

    rows.add(header);

    for (int i = 0; i < tasks.length; i++) {
      List<dynamic> column = [];
      column.add("${i + 1}");
      column.add(tasks[i].taskName);
      column.add(tasks[i].taskDescription);
      column.add(Utils.getFormattedDate(tasks[i].createdOn));
      column.add(Utils.getFormattedDurationCSV(tasks[i].totalHours));
      column.add(Utils.getFormattedDate(tasks[i].completedOn!));

      rows.add(column);
    }

    String csv = const ListToCsvConverter().convert(rows);
    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    File file = File("$dir/filename.csv");
    file.writeAsString(csv);

    return file.path;
  }
}
