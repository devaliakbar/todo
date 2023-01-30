import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:todo/features/task/presentation/widget/home_screen/task_section/task_card.dart';

class TaskSection extends StatelessWidget {
  final String title;
  const TaskSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Text("$title 7"),
        ),
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.8,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 1,
          ),
          items: const [
            TaskCard(),
            TaskCard(),
            TaskCard(),
          ],
        )
      ],
    );
  }
}
