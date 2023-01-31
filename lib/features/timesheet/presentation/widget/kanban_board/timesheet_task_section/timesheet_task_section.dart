import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';
import 'package:todo/features/timesheet/presentation/widget/kanban_board/timesheet_task_section/timesheet_task_card.dart';

typedef OnUpdateTaskStatus = void Function(TimesheetTask taskInfo);

class TimesheetTaskSection extends StatefulWidget {
  final String title;
  final List<TimesheetTask> tasks;
  final OnUpdateTaskStatus onUpdateTaskStatus;
  final Function? onDragOver;

  const TimesheetTaskSection(
      {super.key,
      required this.title,
      required this.tasks,
      required this.onUpdateTaskStatus,
      this.onDragOver});

  @override
  State<TimesheetTaskSection> createState() => _TimesheetTaskSectionState();
}

class _TimesheetTaskSectionState extends State<TimesheetTaskSection> {
  final ValueNotifier<bool> _showMoveEffect = ValueNotifier(false);
  final CarouselController _carouselController = CarouselController();
  @override
  void dispose() {
    _showMoveEffect.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAccept: (data) {
        if (widget.onDragOver != null) {
          widget.onDragOver!();
        }

        if (_checkDragOverSameBody(data)) {
          return false;
        }

        _showMoveEffect.value = true;
        _carouselController.animateToPage(0);

        return true;
      },
      onLeave: (data) {
        if (_checkDragOverSameBody(data)) {
          return;
        }
        _carouselController.animateToPage(1);
        _showMoveEffect.value = false;
      },
      onAcceptWithDetails: (data) {
        _carouselController.animateToPage(0);
        _showMoveEffect.value = false;

        if (data is TimesheetTask) {
          widget.onUpdateTaskStatus(data as TimesheetTask);
        }
      },
      builder: (context, candidateData, rejectedData) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text("${widget.title} ${widget.tasks.length}"),
          ),
          ValueListenableBuilder(
            valueListenable: _showMoveEffect,
            builder: (context, bool showMoveEffect, child) => CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                aspectRatio: 2.8,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                initialPage: showMoveEffect ? 0 : 1,
              ),
              items: [
                if (showMoveEffect) const _ChildWhenDraggingWidget(),
                ...widget.tasks.map<Widget>((task) {
                  final GlobalKey taskCardKey = GlobalKey();

                  final Widget taskCard = TimesheetTaskCard(
                    timesheetTask: task,
                    key: taskCardKey,
                  );

                  return LongPressDraggable(
                    data: task,
                    feedback: _FeedbackWidget(
                        dragChildKey: taskCardKey, child: taskCard),
                    childWhenDragging: const _ChildWhenDraggingWidget(),
                    child: taskCard,
                  );
                }).toList()
              ],
            ),
          )
        ],
      ),
    );
  }

  bool _checkDragOverSameBody(var data) =>
      data is TimesheetTask &&
      widget.tasks.isNotEmpty &&
      data.taskStatus == widget.tasks.first.taskStatus;
}

class _ChildWhenDraggingWidget extends StatelessWidget {
  const _ChildWhenDraggingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _FeedbackWidget extends StatelessWidget {
  final GlobalKey dragChildKey;
  final Widget child;
  const _FeedbackWidget({required this.dragChildKey, required this.child});

  @override
  Widget build(BuildContext context) {
    final RenderBox? renderBoxRed =
        dragChildKey.currentContext!.findRenderObject() as RenderBox?;
    final size = renderBoxRed!.size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Material(
        color: Colors.transparent,
        child: RotationTransition(
            turns: const AlwaysStoppedAnimation(15 / 360),
            child: Transform.scale(scale: 1.05, child: child)),
      ),
    );
  }
}
