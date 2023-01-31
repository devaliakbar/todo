import 'package:flutter/material.dart';
import 'package:todo/features/timesheet/presentation/widget/kanban_board/kanban_board.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: KanbanBoard(),
    );
  }
}
