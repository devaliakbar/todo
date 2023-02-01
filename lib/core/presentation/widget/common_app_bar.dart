import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const CommonAppBar({super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: double.infinity,
      color: Colors.white,
      child: actions.isEmpty
          ? Stack(
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
                  child: Text(title),
                )
              ],
            )
          : Row(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(title),
                ),
                const Spacer(),
                ...actions
              ],
            ),
    );
  }
}
