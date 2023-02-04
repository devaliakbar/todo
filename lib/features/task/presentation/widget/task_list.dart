import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:todo/features/task/presentation/screen/task_detail_screen.dart';

class TaskList extends StatelessWidget {
  final Function onReLoad;

  const TaskList({super.key, required this.onReLoad});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, TasksState state) {
          if (state is TasksLoadFail) {
            return const Center(
              child: Text("oops! something went wrong"),
            );
          }

          if (state is TasksLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, int index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Tapped(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: TaskDetailScreen(
                              taskInfo: state.tasks[index],
                              onChange: onReLoad,
                            )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              state.tasks[index].taskName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                            const SizedBox(width: 15),
                            Text(
                                "${Utils.getFormattedDuration(state.tasks[index].totalHours)} HRS"),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Created on : ${Utils.getFormattedDate(state.tasks[index].createdOn)}"),
                            Text(state.tasks[index].isCompleted
                                ? "Completed"
                                : "Not completed"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return const Center(child: Text("Loading"));
        },
      ),
    );
  }
}
