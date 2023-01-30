import 'package:flutter/material.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/presentation/widget/home_screen/home_app_bar.dart';
import 'package:todo/features/task/presentation/widget/home_screen/task_section/task_section.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TaskInfo> _todos = [
    TaskInfo(
      taskId: "1",
      taskName: "Random Task1",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.todo,
      createdOn: DateTime.now(),
      hours: const Duration(),
    ),
    TaskInfo(
      taskId: "2",
      taskName: "Random Task2 with little big title",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.todo,
      createdOn: DateTime.now(),
      hours: const Duration(),
    ),
    TaskInfo(
      taskId: "3",
      taskName:
          "Random Task3 with extra big title. so here is the extra big title which probably",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.todo,
      createdOn: DateTime.now(),
      hours: const Duration(),
    ),
    TaskInfo(
      taskId: "4",
      taskName: "Random Task4",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.todo,
      createdOn: DateTime.now(),
      hours: const Duration(),
    ),
  ];

  final List<TaskInfo> _inProgress = [
    TaskInfo(
      taskId: "5",
      taskName: "Random Task1",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.inProgress,
      createdOn: DateTime.now(),
      hours: const Duration(),
    ),
    TaskInfo(
      taskId: "7",
      taskName:
          "Random Task3 with extra big title. so here is the extra big title which probably",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.inProgress,
      createdOn: DateTime.now(),
      hours: const Duration(),
    ),
    TaskInfo(
      taskId: "6",
      taskName: "Random Task2 with little big title",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.inProgress,
      createdOn: DateTime.now(),
      hours: const Duration(),
    ),
  ];

  final List<TaskInfo> _done = [
    TaskInfo(
      taskId: "8",
      taskName: "Task Task1",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.done,
      createdOn: DateTime.now(),
      doneOn: DateTime.now().add(const Duration(days: 2)),
      hours: const Duration(),
    ),
    TaskInfo(
      taskId: "9",
      taskName: "Task Task2 with little big title",
      taskDescription:
          "Random Task Description. It must be more than 1 line. so here we go with a big description",
      taskStatus: TaskStatus.done,
      createdOn: DateTime.now(),
      doneOn: DateTime.now().add(const Duration(days: 1)),
      hours: const Duration(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 30),
                TaskSection(title: "Todo", tasks: _todos),
                const SizedBox(height: 35),
                TaskSection(title: "In progress", tasks: _inProgress),
                const SizedBox(height: 35),
                TaskSection(title: "Done", tasks: _done),
              ],
            ),
          )
        ],
      ),
    );
  }
}
