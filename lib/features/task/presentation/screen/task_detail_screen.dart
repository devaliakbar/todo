import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/presentation/screen/task_edit_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final Function onChange;

  final TaskInfo taskInfo;

  const TaskDetailScreen(
      {super.key, required this.taskInfo, required this.onChange});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskInfo taskInfo;

  @override
  void initState() {
    taskInfo = widget.taskInfo;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            title: "Task detail",
            actions: [
              Tapped(
                onTap: () => Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: TaskEditScreen(
                          taskInfo: taskInfo,
                          onSaved: (TaskInfo newTaskInfo) {
                            setState(() {
                              taskInfo = newTaskInfo;
                            });

                            widget.onChange();
                          },
                        ))),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.edit,
                    size: 24,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  taskInfo.taskName,
                  style: const TextStyle(fontSize: 17),
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                Text(
                    "Status : ${taskInfo.isCompleted ? "Completed" : "Not completed"}"),
                Divider(
                  color: Colors.grey[200],
                ),
                Text(
                    "Total Hour Spend : ${Utils.getFormattedDuration(taskInfo.totalHours)}"),
                Divider(
                  color: Colors.grey[200],
                ),
                const Text("Description"),
                Text(
                  taskInfo.taskDescription,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Created on"),
                        Text(
                          Utils.getFormattedFullDate(taskInfo.createdOn),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    if (taskInfo.completedOn != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Completed on"),
                          Text(
                            Utils.getFormattedFullDate(taskInfo.completedOn!),
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      )
                  ],
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                const Text(
                  "Members status",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                ListView.builder(
                  itemCount: 3,
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
