import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_color.dart';

enum AppLanguage { english, german }

class AppTheme extends ChangeNotifier {
  static const _themeIndexKey = "theme_index_key";

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
          primaryColor: Colors.blueAccent,
          warningColor: const Color(0xFF7b403b)),
      AppColor(
          primaryColor: Colors.pinkAccent,
          warningColor: const Color(0xFF9b111e)),
    ]);

    _loadSavedTheme();
  }

  void changeTheme(int index) {
    if (index >= _colors.length) {
      _logger.e("Can't change the theme, passed index is invalid");

      return;
    }

    currentThemeIndex = index;

    _saveTheme(currentThemeIndex);

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
    if (language == AppLanguage.german) {
      context.setLocale(const Locale('de', 'DE'));
    } else {
      context.setLocale(const Locale('en', 'US'));
    }

    notifyListeners();
  }

  ///******************************************************************************///
  ///******************************************************************************///
  ///******************************************************************************///

  Future<void> _loadSavedTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final int? lastSavedThemeIndex = prefs.getInt(_themeIndexKey);
      if (lastSavedThemeIndex != null) {
        _logger.i("Last saved theme index $lastSavedThemeIndex");
        changeTheme(lastSavedThemeIndex);
      }
    } catch (_) {
      _logger.i("No saved theme index found");
    }
  }

  Future<void> _saveTheme(int themeIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setInt(_themeIndexKey, themeIndex);
      _logger.i("Saved theme index : $themeIndex");
    } catch (_) {
      _logger.e("Failed to save theme index");
    }
  }
}
