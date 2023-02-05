part of 'app_theme.dart';

class _CommonAppColor {
  final Color black = Colors.black;
  final Color greyLight = Colors.grey[400]!;
  final Color dividerColor = Colors.grey[200]!;
  final Color shadowColor = Colors.black54.withOpacity(0.15);

  _CommonAppColor();
}

class AppColor extends _CommonAppColor {
  final Color primaryColor;
  final Color warningColor;

  AppColor({required this.primaryColor, required this.warningColor});
}
