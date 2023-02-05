import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/main_screen_app_bar.dart';
import 'package:todo/features/task/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:todo/features/task/presentation/view_controller/task_edit_controller.dart';
import 'package:todo/features/task/presentation/widget/task_list.dart';
import 'package:open_file/open_file.dart';

class TaskHistory extends StatelessWidget {
  final Function onReload;

  const TaskHistory({super.key, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainScreenAppBar(
          title: "History",
          actions: [
            Tapped(
              onTap: () async {
                final TasksState tasksState =
                    BlocProvider.of<TasksBloc>(context, listen: false).state;

                if (tasksState is TasksLoaded) {
                  if (tasksState.tasks.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "You don't have any tasks to export");
                    return;
                  }

                  final TaskEditController taskEditController =
                      RepositoryProvider.of<TaskEditController>(context,
                          listen: false);

                  final AppLoaderBloc appLoaderBloc =
                      BlocProvider.of<AppLoaderBloc>(context, listen: false);

                  appLoaderBloc.add(ShowLoader());

                  final dartz.Either<Failure, String> result =
                      await taskEditController
                          .exportTasksToCsv(tasksState.tasks);

                  appLoaderBloc.add(HideLoader());

                  result.fold(
                      (l) => Fluttertoast.showToast(msg: "Failed to export."),
                      (String filename) {
                    _showSuccessExportDialogue(context, filename);
                  });
                } else {
                  Fluttertoast.showToast(
                      msg: "Please try after data is loaded");
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.download_rounded,
                  size: 24,
                ),
              ),
            )
          ],
        ),
        TaskList(onReLoad: onReload),
      ],
    );
  }

  void _showSuccessExportDialogue(BuildContext context, String filename) {
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Navigator.pop(context);

        OpenFile.open(filename);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Export Success"),
      content: const Text("Would you like to open exported file?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
