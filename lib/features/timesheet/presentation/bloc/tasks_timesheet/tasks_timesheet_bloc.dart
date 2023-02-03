import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/features/timesheet/domain/usecases/get_tasks_timesheet.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';

part 'tasks_timesheet_event.dart';
part 'tasks_timesheet_state.dart';

class TasksTimesheetBloc
    extends Bloc<TasksTimesheetEvent, TasksTimesheetState> {
  final GetTasksTimesheet _getTasksTimesheet;

  TasksTimesheetBloc({required GetTasksTimesheet getTasksTimesheet})
      : _getTasksTimesheet = getTasksTimesheet,
        super(TasksTimesheetInitial()) {
    on<GetTasksTimesheetEvent>(_mapGetTasksTimesheetEvent);
  }

  Future<void> _mapGetTasksTimesheetEvent(
      GetTasksTimesheetEvent event, Emitter<TasksTimesheetState> emit) async {
    emit(TasksTimesheetLoading());

    final Either<Failure, List<TimesheetTask>> result =
        await _getTasksTimesheet(GetTimesheetParams(taskId: event.taskId));

    result.fold((l) => emit(TasksTimesheetLoadFail()),
        (List<TimesheetTask> r) => emit(TasksTimesheetLoaded(tasks: r)));
  }
}
