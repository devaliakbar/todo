import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/task/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:todo/features/timesheet/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/user/presentation/widget/profile/profile.dart';
import 'package:todo/features/task/presentation/widget/task_history/task_history.dart';
import 'package:todo/features/task/presentation/widget/tasks/tasks.dart';
import 'package:todo/features/timesheet/presentation/widget/kanban_board/kanban_board.dart';
import 'package:todo/features/welcome/presentation/widget/home_screen/home_bottom_navigation.dart';
import 'package:todo/injection_container.dart' as di;

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

    _currentIndex.addListener(() {
      _tabController.animateTo(_currentIndex.value);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _currentIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignInState userState =
        BlocProvider.of<UserBloc>(context, listen: false).state as SignInState;

    return Scaffold(
      body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            BlocProvider(
              create: (context) => di.sl<TasksTimesheetBloc>(),
              child: const KanbanBoard(),
            ),
            BlocProvider(
              create: (context) => di.sl<TasksBloc>()
                ..add(GetTasksEvent(
                    getCompltedTask: false, ownerId: userState.userInfo.id)),
              child: Builder(
                builder: (context) => Tasks(onReload: () {
                  BlocProvider.of<TasksBloc>(context, listen: false).add(
                      GetTasksEvent(
                          getCompltedTask: false,
                          ownerId: userState.userInfo.id));
                }),
              ),
            ),
            BlocProvider(
              create: (context) => di.sl<TasksBloc>()
                ..add(GetTasksEvent(
                    getCompltedTask: true, ownerId: userState.userInfo.id)),
              child: Builder(
                builder: (context) => TaskHistory(onReload: () {
                  BlocProvider.of<TasksBloc>(context, listen: false).add(
                      GetTasksEvent(
                          getCompltedTask: true,
                          ownerId: userState.userInfo.id));
                }),
              ),
            ),
            const Profile(),
          ]),
      bottomNavigationBar: HomeBottomNavigation(currentIndex: _currentIndex),
    );
  }
}
