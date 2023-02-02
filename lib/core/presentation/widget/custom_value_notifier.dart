import 'package:flutter/material.dart';

class CustomValueNotifier<T> extends ValueNotifier<T> {
  CustomValueNotifier(T value) : super(value);

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
