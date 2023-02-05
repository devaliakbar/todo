import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/core/presentation/bloc/app_loader/app_loader_bloc.dart';
import 'package:todo/core/presentation/widget/cached_image.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';
import 'package:todo/core/presentation/widget/common_text_field.dart';
import 'package:todo/core/presentation/widget/custom_value_notifier.dart';
import 'package:todo/core/app_theme/app_theme.dart';
import 'package:todo/core/res/app_resources.dart';
import 'package:todo/features/task/domain/entity/task_info.dart';
import 'package:todo/features/task/domain/usecases/create_task.dart';
import 'package:todo/features/task/domain/usecases/update_task.dart';
import 'package:todo/features/task/presentation/ui_helper/task_edit_helper.dart';
import 'package:todo/features/task/presentation/view_controller/task_edit_controller.dart';
import 'package:todo/features/user/domain/enity/user_info.dart';
import 'package:todo/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:todo/features/user/presentation/screen/select_user_screen.dart';

typedef OnSaved = Function(TaskInfo taskInfo);

class TaskEditScreen extends StatefulWidget {
  final TaskInfo? taskInfo;
  final OnSaved? onSaved;
  const TaskEditScreen({super.key, this.taskInfo, this.onSaved});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  final CustomValueNotifier<List<UserInfo>> _selectedUsers =
      CustomValueNotifier<List<UserInfo>>([]);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.taskInfo != null) {
      _taskNameController.text = widget.taskInfo!.taskName;
      _taskDescriptionController.text = widget.taskInfo!.taskDescription;
      _selectedUsers.value = [...widget.taskInfo!.assignedTo];
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            title: widget.taskInfo == null
                ? AppString.addTask
                : AppString.editTask,
            actions: [
              Tapped(
                onTap: _save,
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
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CommonTextField(
                            title: AppString.taskName,
                            controller: _taskNameController,
                            validator: TaskEditHelper.validateTaskName),
                        const SizedBox(height: 20),
                        CommonTextField(
                          title: AppString.taskDescription,
                          controller: _taskDescriptionController,
                          validator: TaskEditHelper.validateTaskDescription,
                          maxLength: 100,
                          maxLine: 3,
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppString.assignTo} :",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Tapped(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: SelectUserScreen(
                                  selectedUsers: _selectedUsers.value,
                                  onUsersSelect:
                                      (List<UserInfo> selectedUsers) {
                                    _selectedUsers.value = selectedUsers;
                                  },
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Icon(Icons.add,
                                color: AppTheme.color.warningColor, size: 16),
                            Text(
                              AppString.addUser,
                              style:
                                  TextStyle(color: AppTheme.color.warningColor),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: _selectedUsers,
                  builder: (context, List<UserInfo> selectedUsers, child) =>
                      ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                    itemCount: selectedUsers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Row(
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          margin: const EdgeInsets.only(right: 10),
                          child: ClipOval(
                            child: CachedImage(
                                imageUrl: selectedUsers[index].profilePic),
                          ),
                        ),
                        Expanded(
                          child: Text(selectedUsers[index].fullName),
                        ),
                        const SizedBox(width: 15),
                        Tapped(
                          onTap: () {
                            selectedUsers.removeAt(index);
                            _selectedUsers.notifyListeners();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Icon(
                              Icons.delete,
                              size: 18,
                              color: AppTheme.color.warningColor,
                            ),
                          ),
                        )
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

  Future<void> _save() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      if (_selectedUsers.value.isEmpty) {
        Fluttertoast.showToast(msg: "Please select atleast one user");
        return;
      }

      final String taskName = _taskNameController.text.trim();
      final String taskDescription = _taskDescriptionController.text.trim();

      final UserState userState =
          BlocProvider.of<UserBloc>(context, listen: false).state;

      if (userState is SignInState) {
        final TaskEditController taskEditController =
            RepositoryProvider.of<TaskEditController>(context, listen: false);

        final dartz.Either<Failure, TaskInfo> result;

        final AppLoaderBloc appLoaderBloc =
            BlocProvider.of<AppLoaderBloc>(context, listen: false);

        appLoaderBloc.add(ShowLoader());

        if (widget.taskInfo != null) {
          result = await taskEditController.updateTask(UpdateTaskParams(
              taskId: widget.taskInfo!.taskId,
              creatorInfo: userState.userInfo,
              taskCreatedTime: widget.taskInfo!.createdOn,
              taskName: taskName,
              taskDescription: taskDescription,
              users: [..._selectedUsers.value],
              removedUsers: TaskEditHelper.getRemovedUser(
                  widget.taskInfo!.assignedTo, _selectedUsers.value)));
        } else {
          result = await taskEditController.createTask(CreateTaskParams(
              creatorInfo: userState.userInfo,
              taskName: taskName,
              taskDescription: taskDescription,
              users: [..._selectedUsers.value]));
        }

        appLoaderBloc.add(HideLoader());

        result.fold((l) => Fluttertoast.showToast(msg: "Failed to save"),
            (TaskInfo result) {
          Fluttertoast.showToast(msg: "Saved successfully");
          if (widget.onSaved != null) {
            widget.onSaved!(result);
          }

          Navigator.pop(context);
        });
      }
    }
  }
}
