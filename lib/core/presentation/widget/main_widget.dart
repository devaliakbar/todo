import 'package:flutter/material.dart';
import 'package:todo/core/presentation/widget/app_loader.dart';

class MainWidget {
  const MainWidget();

  static Widget widget(BuildContext context, Widget? child) {
    return Stack(
      children: [
        if (child != null) child,
        const AppLoader(),
      ],
    );
  }
}
