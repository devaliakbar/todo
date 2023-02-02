import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';
import 'package:todo/core/presentation/widget/common_text_field.dart';
import 'package:todo/features/user/presentation/screen/select_user_screen.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';

class TaskEditScreen extends StatelessWidget {
  final TimesheetTask? timesheetTask;
  const TaskEditScreen({super.key, this.timesheetTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            title: timesheetTask == null ? "Add task" : "Edit task",
            actions: [
              Tapped(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.check,
                    size: 24,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(15),
              children: [
                const CommonTextField(title: "Task name"),
                const SizedBox(height: 20),
                const CommonTextField(
                  title: "Task Description",
                  maxLength: 100,
                  maxLine: 3,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Assign to :",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Tapped(
                      onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const SelectUserScreen())),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: Colors.red, size: 16),
                            Text(
                              "Add user",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Row(
                    children: [
                      const Expanded(
                        child: Text("Ali"),
                      ),
                      const SizedBox(width: 15),
                      Tapped(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
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
