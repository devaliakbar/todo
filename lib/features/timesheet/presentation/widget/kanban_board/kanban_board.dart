import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/cached_image.dart';
import 'package:todo/core/app_theme/app_theme.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/timesheet/domain/usecases/update_timesheet_status.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';
import 'package:todo/features/timesheet/presentation/view_controller/timesheet_edit_controller.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/presentation/widget/kanban_board/timesheet_task_section.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _getData();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 15,
              left: 15,
              bottom: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppTheme.color.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 0),
              )
            ],
          ),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (_, UserState state) {
              final String userFullName =
                  state is SignInState ? state.userInfo.fullName : "";

              final String? userImage =
                  state is SignInState ? state.userInfo.profilePic : null;
              return Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: ClipOval(
                      child: CachedImage(imageUrl: userImage),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      "Hi $userFullName",
                      style: const TextStyle(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              );
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<TasksTimesheetBloc, TasksTimesheetState>(
            buildWhen:
                (TasksTimesheetState previous, TasksTimesheetState current) =>
                    previous is! TasksTimesheetLoaded,
            builder: (context, state) {
              if (state is TasksTimesheetLoadFail) {
                return const Center(
                  child: Text("oops! something went wrong."),
                );
              }

              if (state is TasksTimesheetLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    _getData();

                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 50),
                    children: [
                      const SizedBox(height: 30),
                      TimesheetTaskSection(
                        title: "Todo",
                        tasks: state.tasks.todoTasks,
                        onUpdateTaskStatus: (TimesheetTask timesheetTask) =>
                            _updateTaskStatus(
                                timesheetTask, TimesheetTaskStatus.todo),
                        onDragOver: () => _scrollTo(isScrollToTop: true),
                      ),
                      const SizedBox(height: 35),
                      TimesheetTaskSection(
                        title: "In progress",
                        tasks: state.tasks.inprogressTasks,
                        onUpdateTaskStatus: (TimesheetTask timesheetTask) =>
                            _updateTaskStatus(
                                timesheetTask, TimesheetTaskStatus.inProgress),
                      ),
                      const SizedBox(height: 35),
                      TimesheetTaskSection(
                        title: "Done",
                        tasks: state.tasks.doneTasks,
                        onUpdateTaskStatus: (TimesheetTask timesheetTask) =>
                            _updateTaskStatus(
                                timesheetTask, TimesheetTaskStatus.done),
                        onDragOver: () => _scrollTo(isScrollToTop: false),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: Text("Loading..."),
              );
            },
          ),
        )
      ],
    );
  }

  void _getData() {
    final UserState userState =
        BlocProvider.of<UserBloc>(context, listen: false).state;

    if (userState is SignInState) {
      BlocProvider.of<TasksTimesheetBloc>(context, listen: false)
          .add(GetTasksTimesheetEvent(userId: userState.userInfo.id));
    }
  }

  void _scrollTo({required bool isScrollToTop}) {
    _scrollController.animateTo(
      isScrollToTop ? 0 : _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  Future<void> _updateTaskStatus(
      TimesheetTask timesheetTask, TimesheetTaskStatus newStatus) async {
    Duration hours = timesheetTask.hours;

    ///Checking whether timer is On
    if (timesheetTask.taskStatus == TimesheetTaskStatus.inProgress &&
        timesheetTask.timerStartSince != null) {
      hours = timesheetTask.hours +
          Utils.getTimerDuration(timesheetTask.timerStartSince!);
    }

    final UpdateTimesheetStatusParam updatedInfo = UpdateTimesheetStatusParam(
        timesheetId: timesheetTask.timesheetId,
        taskId: timesheetTask.taskId,
        taskStatus: newStatus,
        doneOn: newStatus == TimesheetTaskStatus.done ? DateTime.now() : null,
        timerStartSince: null,
        hours: hours);

    final UpdateTimesheetStatusParam oldInfo = UpdateTimesheetStatusParam(
        timesheetId: timesheetTask.timesheetId,
        taskId: timesheetTask.taskId,
        taskStatus: timesheetTask.taskStatus,
        doneOn: timesheetTask.doneOn,
        timerStartSince: timesheetTask.timerStartSince,
        hours: timesheetTask.hours);

    final AppLoaderBloc appLoaderBloc =
        BlocProvider.of<AppLoaderBloc>(context, listen: false);

    appLoaderBloc.add(ShowLoader());

    final dartz.Either result =
        await RepositoryProvider.of<TimesheetEditController>(context,
                listen: false)
            .updateTimesheet(
                updateTimesheetParams: UpdateTimesheetParams(
                    oldTask: oldInfo, updatedTask: updatedInfo));

    appLoaderBloc.add(HideLoader());

    result.fold((l) => Fluttertoast.showToast(msg: "Failed to update"),
        (r) => _getData());
  }
}
