import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/presentation/widget/main_screen_app_bar.dart';

class TaskHistory extends StatelessWidget {
  const TaskHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainScreenAppBar(title: "History", actions: [
          Tapped(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.download_rounded,
                size: 24,
              ),
            ),
          )
        ]),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Tapped(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   PageTransition(
                  //       type: PageTransitionType.rightToLeft,
                  //       child: const TaskDetailScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Expanded(
                              child: Text(
                            "Task Name",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          SizedBox(width: 15),
                          Text("32 HRS"),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Created on : 22 Jun"),
                          Text("Completed on : 27 Jun"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
