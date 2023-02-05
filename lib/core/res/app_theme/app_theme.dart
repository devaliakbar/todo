import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

part 'app_color.dart';

class AppTheme extends ChangeNotifier {
  final Logger _logger;

  static final List<AppColor> _colors = [];

  static int currentThemeIndex = 0;
  static AppColor get color {
    return _colors[currentThemeIndex];
  }

  ///Define color here
  AppTheme({required Logger logger}) : _logger = logger {
    _colors.addAll([
      AppColor(
          primaryColor: Colors.pinkAccent,
          warningColor: const Color(0xFF9b111e)),
      AppColor(
          primaryColor: Colors.blueAccent,
          warningColor: const Color(0xFF7b403b)),
    ]);
  }

  void changeTheme(int index) {
    if (index >= _colors.length) {
      _logger.e("Can't change the theme, passed index is invalid");

      return;
    }

    currentThemeIndex = index;
    notifyListeners();

    _logger.i("Theme switched to index $index");
  }
}
