import 'package:flutter/material.dart';

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
        Text(failMsg),
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
