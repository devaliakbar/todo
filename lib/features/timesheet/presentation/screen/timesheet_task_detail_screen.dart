import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/common_app_bar.dart';

class TimsheetTaskDetailScreen extends StatelessWidget {
  const TimsheetTaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CommonAppBar(title: "Task detail"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text(
                  "Task name",
                  style: TextStyle(fontSize: 17),
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                const Text("Created by : Ali Akbar"),
                Divider(
                  color: Colors.grey[200],
                ),
                Row(
                  children: [
                    const Text("Status"),
                    const SizedBox(width: 15),
                    Tapped(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.yellow[200]),
                        child: const Text("Todo"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tapped(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200]),
                        child: const Text("In progress"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tapped(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200]),
                        child: const Text("Done"),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                Row(
                  children: [
                    const Text("Total Hour Spend : "),
                    Tapped(
                      onTap: () {},
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("00:00:00"),
                  ],
                ),
                Divider(
                  color: Colors.grey[200],
                ),
                const Text("Description"),
                const Text(
                  "TaskDescription zxfjhkhgsda jfkbn,maf jkhesagf,mba§,mfgjahs mgfj,mgash,m§hg",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
