import 'package:intl/intl.dart';

class Utils {
  static String getFormattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String getFormattedDate(DateTime date) {
    return DateFormat("dd MMM").format(date);
  }

  static Duration getTimerDuration(DateTime timerStartSince) {
    return DateTime.now().toUtc().difference(timerStartSince);
  }
}
