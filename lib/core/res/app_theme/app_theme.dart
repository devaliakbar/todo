import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:easy_localization/easy_localization.dart';

part 'app_color.dart';

enum AppLanguage { english, german }

class AppTheme extends ChangeNotifier {
  final Logger _logger;

  AppLanguage appLanguage = AppLanguage.english;

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

  AppLanguage getCurrentAppLanguage(BuildContext context) {
    if (context.locale.languageCode == "de" &&
        context.locale.countryCode == "DE") {
      return AppLanguage.german;
    }

    return AppLanguage.english;
  }

  void switchLanguage(BuildContext context, AppLanguage language) {
    appLanguage = language;

    if (language == AppLanguage.german) {
      context.setLocale(const Locale('de', 'DE'));
    } else {
      context.setLocale(const Locale('en', 'US'));
    }

    notifyListeners();
  }
}
