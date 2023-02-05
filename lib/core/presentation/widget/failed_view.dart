import 'package:flutter/material.dart';
import 'package:todo/core/res/app_resources.dart';

class FailedView extends StatelessWidget {
  final String failMsg;
  final bool addRetryBtn;
  final Function? onClickRetry;

  const FailedView(
      {super.key,
      required this.failMsg,
      this.addRetryBtn = false,
      this.onClickRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          failMsg,
          style: AppStyle.mainInfo,
        ),
        if (addRetryBtn)
          ElevatedButton(
              onPressed: () {
                if (onClickRetry != null) {
                  onClickRetry!();
                }
              },
              child: const Text("Retry"))
      ],
    );
  }
}
