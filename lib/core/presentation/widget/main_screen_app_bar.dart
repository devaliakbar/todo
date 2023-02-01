import 'package:flutter/material.dart';

class MainScreenAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const MainScreenAppBar(
      {super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              (actions.isNotEmpty ? 0 : 15),
          left: 15,
          bottom: actions.isNotEmpty ? 0 : 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...actions
        ],
      ),
    );
  }
}
