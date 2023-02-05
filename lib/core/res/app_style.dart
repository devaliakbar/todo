part of 'app_resources.dart';

class AppStyle {
  static TextStyle bottomNavText(bool isSelect) => TextStyle(
        fontSize: 11,
        color: isSelect ? AppTheme.color.primaryColor : AppTheme.color.black,
      );

  static TextStyle get title => TextStyle(
        fontSize: 16,
        color: AppTheme.color.primaryColor,
      );

  static TextStyle get mainInfo => TextStyle(
        fontSize: 15,
        color: AppTheme.color.primaryColor,
      );

  static TextStyle subInfo({bool isItalic = false}) => TextStyle(
        fontSize: 14,
        color: AppTheme.color.black.withOpacity(0.6),
        fontStyle: isItalic ? FontStyle.italic : null,
      );

  static TextStyle get signIn => const TextStyle(
        fontSize: 15,
        color: Colors.white,
      );
}
