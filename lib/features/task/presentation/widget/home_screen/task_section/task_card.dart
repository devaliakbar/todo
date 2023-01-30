import 'package:flutter/material.dart';
import 'package:todo/core/utils/utils.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';

class TaskCard extends StatelessWidget {
  final TaskInfo taskInfo;
  const TaskCard({super.key, required this.taskInfo});

  @override
  Widget build(BuildContext context) {
    final bool showDoneDate =
        taskInfo.taskStatus == TaskStatus.done && taskInfo.doneOn != null;

    return AspectRatio(
      aspectRatio: 2.8,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    taskInfo.taskName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17),
                  )),
                  const Icon(Icons.edit, size: 17)
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.play_arrow_rounded,
                    size: 25,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    Utils.getFormattedDuration(taskInfo.hours),
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: showDoneDate
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Text("Created: ${Utils.getFormattedDate(taskInfo.createdOn)}",
                      style: const TextStyle(fontSize: 13)),
                  if (showDoneDate)
                    Text("Done by: ${Utils.getFormattedDate(taskInfo.doneOn!)}",
                        style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
