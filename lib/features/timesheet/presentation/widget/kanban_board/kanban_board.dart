import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/presentation/widget/cached_image.dart';
import 'package:todo/core/utils/utils.dart';
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<TimesheetTask> _todos = [];

  final List<TimesheetTask> _inProgress = [];

  final List<TimesheetTask> _done = [];

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
                color: Colors.black54.withOpacity(0.15),
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
                  Text(
                    "Hi $userFullName",
                    style: const TextStyle(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              );
            },
          ),
        ),
        Expanded(
          child: ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 50),
            children: [
              const SizedBox(height: 30),
              TimesheetTaskSection(
                title: "Todo",
                tasks: _todos,
                onUpdateTaskStatus: (TimesheetTask timesheetTask) =>
                    _updateTaskStatus(timesheetTask, TimesheetTaskStatus.todo),
                onDragOver: () => _scrollTo(isScrollToTop: true),
              ),
              const SizedBox(height: 35),
              TimesheetTaskSection(
                title: "In progress",
                tasks: _inProgress,
                onUpdateTaskStatus: (TimesheetTask timesheetTask) =>
                    _updateTaskStatus(
                        timesheetTask, TimesheetTaskStatus.inProgress),
              ),
              const SizedBox(height: 35),
              TimesheetTaskSection(
                title: "Done",
                tasks: _done,
                onUpdateTaskStatus: (TimesheetTask timesheetTask) =>
                    _updateTaskStatus(timesheetTask, TimesheetTaskStatus.done),
                onDragOver: () => _scrollTo(isScrollToTop: false),
              ),
            ],
          ),
        )
      ],
    );
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

    // final TimesheetTask updatedTask = TimesheetTask(
    //     taskId: timesheetTask.taskId,
    //     taskName: timesheetTask.taskName,
    //     taskDescription: timesheetTask.taskDescription,
    //     taskStatus: newStatus,
    //     createdOn: timesheetTask.createdOn,
    //     doneOn: newStatus == TimesheetTaskStatus.done
    //         ? DateTime.now().toUtc()
    //         : null,
    //     timerStartSince: null,
    //     hours: hours);
  }
}
