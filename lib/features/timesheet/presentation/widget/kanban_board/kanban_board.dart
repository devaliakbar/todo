import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/presentation/widget/cached_image.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/auth/presentation/bloc/user/user_bloc.dart';
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

  final List<TimesheetTask> _todos = [
    TimesheetTask(
      taskId: "1",
      taskName: "Random Task1",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TimesheetTaskStatus.todo,
      createdOn: DateTime.now(),
      hours: const Duration(),
      assignedPersonId: "",
      creatorId: "",
      creatorName: "",
      timesheetId: "",
    ),
    TimesheetTask(
      taskId: "2",
      taskName: "Random Task2 with little big title",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TimesheetTaskStatus.todo,
      createdOn: DateTime.now(),
      hours: const Duration(),
      assignedPersonId: "",
      creatorId: "",
      creatorName: "",
      timesheetId: "",
    ),
    TimesheetTask(
      taskId: "3",
      taskName:
          "Random Task3 with extra big title. so here is the extra big title which probably",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TimesheetTaskStatus.todo,
      createdOn: DateTime.now(),
      hours: const Duration(),
      assignedPersonId: "",
      creatorId: "",
      creatorName: "",
      timesheetId: "",
    ),
    TimesheetTask(
      taskId: "4",
      taskName: "Random Task4",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TimesheetTaskStatus.todo,
      createdOn: DateTime.now(),
      hours: const Duration(),
      assignedPersonId: "",
      creatorId: "",
      creatorName: "",
      timesheetId: "",
    ),
  ];

  final List<TimesheetTask> _inProgress = [
    TimesheetTask(
        taskId: "5",
        taskName: "Random Task1",
        taskDescription:
            "Random Task Description. It must be more than 1 line. so here we go with a big description",
        taskStatus: TimesheetTaskStatus.inProgress,
        createdOn: DateTime.now(),
        assignedPersonId: "",
        creatorId: "",
        creatorName: "",
        timesheetId: "",
        hours: const Duration(hours: 2, minutes: 10, seconds: 25),
        timerStartSince: DateTime.now().toUtc()),
    TimesheetTask(
      taskId: "7",
      taskName:
          "Random Task3 with extra big title. so here is the extra big title which probably",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TimesheetTaskStatus.inProgress,
      createdOn: DateTime.now(),
      assignedPersonId: "",
      creatorId: "",
      creatorName: "",
      timesheetId: "",
      hours: const Duration(),
    ),
    TimesheetTask(
      taskId: "6",
      taskName: "Random Task2 with little big title",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TimesheetTaskStatus.inProgress,
      createdOn: DateTime.now(),
      assignedPersonId: "",
      creatorId: "",
      creatorName: "",
      timesheetId: "",
      hours: const Duration(),
    ),
  ];

  final List<TimesheetTask> _done = [
    TimesheetTask(
      taskId: "8",
      taskName: "Task Task1",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TimesheetTaskStatus.done,
      createdOn: DateTime.now(),
      doneOn: DateTime.now().add(const Duration(days: 2)),
      hours: const Duration(),
      assignedPersonId: "",
      creatorId: "",
      creatorName: "",
      timesheetId: "",
    ),
    TimesheetTask(
      taskId: "9",
      taskName: "Task Task2 with little big title",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TimesheetTaskStatus.done,
      createdOn: DateTime.now(),
      assignedPersonId: "",
      creatorId: "",
      creatorName: "",
      timesheetId: "",
      doneOn: DateTime.now().add(const Duration(days: 1)),
      hours: const Duration(),
    ),
  ];

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
