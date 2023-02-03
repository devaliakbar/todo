import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/presentation/bloc/tasks_timesheet/tasks_timesheet_bloc.dart';

class TasksTimesheetSection extends StatelessWidget {
  final TaskInfo taskInfo;

  const TasksTimesheetSection({super.key, required this.taskInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Members status",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        BlocBuilder<TasksTimesheetBloc, TasksTimesheetState>(
          builder: (context, state) {
            if (state is TasksTimesheetLoaded) {
              return ListView.builder(
                itemCount: state.tasks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Username",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Tapped(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.yellow[200]),
                              child: const Text("Todo"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Tapped(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[200]),
                              child: const Text("In progress"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Tapped(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[200]),
                              child: const Text("Done"),
                            ),
                          ),
                          const Spacer(),
                          const Text("00:00:00 HRS")
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: Text("Loading..."),
            );
          },
        )
      ],
    );
  }
}
