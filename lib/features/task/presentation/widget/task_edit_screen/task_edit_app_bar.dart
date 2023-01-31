import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class TaskEditAppBar extends StatelessWidget {
  const TaskEditAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Tapped(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 15),
            child: const Text("Edit Task"),
          )
        ],
      ),
    );
  }
}
