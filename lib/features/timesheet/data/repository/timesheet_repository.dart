import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/task/data/model/task_info_model.dart';
import 'package:todo/features/timesheet/data/datasource/timesheet_remore_data_source.dart';
import 'package:todo/features/timesheet/data/model/task_status_change_model.dart';
import 'package:todo/features/timesheet/data/model/tasks_timesheet_model.dart';
import 'package:todo/features/timesheet/domain/entity/tasks_timesheet.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/domain/irepository/itimesheet_repository.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';

class TimesheetRepository extends ITimesheetRepository {
  final ITimesheetRemoreDataSource _timesheetRemoreDataSource;

  TimesheetRepository(
      {required ITimesheetRemoreDataSource timesheetRemoreDataSource})
      : _timesheetRemoreDataSource = timesheetRemoreDataSource;

  @override
  Future<Either<Failure, TasksTimesheet>> getTasksTimesheet(
      GetTimesheetParams getTimesheetParams) async {
    try {
      return Right(await _timesheetRemoreDataSource
          .getTasksTimesheet(getTimesheetParams));
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, void>> updateTaskStatus(
      UpdateTimesheetParams updateTaskStatusParams) async {
    try {
      final bool isTotalHourChanged = updateTaskStatusParams.oldTask.hours !=
          updateTaskStatusParams.updatedTask.hours;

      final bool isStatusChangeToDone =
          updateTaskStatusParams.updatedTask.taskStatus ==
                  TimesheetTaskStatus.done &&
              updateTaskStatusParams.updatedTask.taskStatus !=
                  updateTaskStatusParams.oldTask.taskStatus;

      final bool isStatusChangeFromDone =
          updateTaskStatusParams.oldTask.taskStatus ==
                  TimesheetTaskStatus.done &&
              updateTaskStatusParams.updatedTask.taskStatus !=
                  TimesheetTaskStatus.done;

      final TaskStatusChangeModel? taskStatusChangeModel =
          await _getTaskChangeModel(
              updateTaskStatusParams: updateTaskStatusParams,
              isTotalHourChanged: isTotalHourChanged,
              isStatusChangeToDone: isStatusChangeToDone,
              isStatusChangeFromDone: isStatusChangeFromDone);

      await _timesheetRemoreDataSource.updateTimesheet(
          updateTaskStatusParams.updatedTask, taskStatusChangeModel);

      return const Right(null);
    } catch (_) {}

    return Left(UnexpectedFailure());
  }

  ///[_getTaskChangeModel] will return updated Task details
  Future<TaskStatusChangeModel?> _getTaskChangeModel({
    required UpdateTimesheetParams updateTaskStatusParams,
    required bool isTotalHourChanged,
    required bool isStatusChangeToDone,
    required bool isStatusChangeFromDone,
  }) async {
    ///If any of the below true, then update TaskInfo
    if (isTotalHourChanged || isStatusChangeToDone || isStatusChangeFromDone) {
      final TaskInfoModel taskInfoModel = await _timesheetRemoreDataSource
          .getTask(updateTaskStatusParams.updatedTask.taskId);

      Duration? updatedTotalHour = taskInfoModel.totalHours;
      bool isTaskComplete = taskInfoModel.isCompleted;
      DateTime? taskCompletedOn = taskInfoModel.completedOn;

      if (isTotalHourChanged) {
        updatedTotalHour =
            taskInfoModel.totalHours + updateTaskStatusParams.updatedTask.hours;
        updatedTotalHour -= updateTaskStatusParams.oldTask.hours;
      }

      if (isStatusChangeFromDone && taskInfoModel.isCompleted) {
        isTaskComplete = false;
        taskCompletedOn = null;
      }

      if (isStatusChangeToDone) {
        final TasksTimesheetModel tasks = await _timesheetRemoreDataSource
            .getTasksTimesheet(GetTimesheetParams(
                taskId: updateTaskStatusParams.updatedTask.taskId));

        bool isTodoHasOtherTask = _checkTaskStatusListHasOtherTask(
            status: TimesheetTaskStatus.todo,
            updateTaskStatusParams: updateTaskStatusParams,
            tasks: tasks.todoTasks);

        final bool isInProgressHasOtherTask = _checkTaskStatusListHasOtherTask(
            status: TimesheetTaskStatus.inProgress,
            updateTaskStatusParams: updateTaskStatusParams,
            tasks: tasks.inprogressTasks);

        ///If there is any tasks which are not done, then
        if (isTodoHasOtherTask || isInProgressHasOtherTask) {
          isTaskComplete = false;
          taskCompletedOn = null;
        } else {
          isTaskComplete = true;
          taskCompletedOn = DateTime.now().toUtc();
        }
      }

      return TaskStatusChangeModel(
          taskId: taskInfoModel.taskId,
          totalHours: updatedTotalHour,
          isComplete: isTaskComplete,
          completedOn: taskCompletedOn);
    }

    return null;
  }

  bool _checkTaskStatusListHasOtherTask(
      {required TimesheetTaskStatus status,
      required UpdateTimesheetParams updateTaskStatusParams,
      required List<TimesheetTask> tasks}) {
    if (tasks.length > 1) {
      return true;
    }

    return updateTaskStatusParams.oldTask.taskStatus != status &&
        tasks.isNotEmpty;
  }
}
