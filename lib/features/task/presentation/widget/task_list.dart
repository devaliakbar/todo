import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/failed_view.dart';
import 'package:todo/core/res/app_resources.dart';
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
            return FailedView(
              failMsg: "oops! something went wrong",
              addRetryBtn: true,
              onClickRetry: onReLoad,
            );
          }

          if (state is TasksLoaded) {
            if (state.tasks.isEmpty) {
              return FailedView(
                failMsg: AppString.noDataFound,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                onReLoad();

                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: state.tasks.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.tasks[index].taskName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.mainInfo,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "${AppString.createdOn}: ${Utils.getFormattedDate(state.tasks[index].createdOn)}",
                            style: AppStyle.subInfo(),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.tasks[index].isCompleted
                                    ? AppString.complete
                                    : AppString.notComplete,
                                style: AppStyle.subInfo(),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "${Utils.getFormattedDuration(state.tasks[index].totalHours)} HRS",
                                style: AppStyle.subInfo(),
                              ),
                            ],
                          )
                        ],
                      ),
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
