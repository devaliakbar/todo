import 'package:intl/intl.dart';
import 'package:todo/features/timesheet/domain/entity/timesheet_task.dart';

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

  static String getFormattedFullDate(DateTime date) {
    return DateFormat("dd MMM yyyy").format(date);
  }

  static Duration getTimerDuration(DateTime timerStartSince) {
    return DateTime.now().toUtc().difference(timerStartSince);
  }

  static Duration parseDuration(String duration) {
    try {
      List<String> durationSplit = duration.split(".").first.split(":");
      return Duration(
          hours: int.parse(durationSplit.first),
          minutes: int.parse(durationSplit[1]),
          seconds: int.parse(durationSplit[2]));
    } catch (_) {}

    return Duration.zero;
  }

  static String getTaskStatusInString(TimesheetTaskStatus status) {
    if (status == TimesheetTaskStatus.inProgress) {
      return "inProgress";
    } else if (status == TimesheetTaskStatus.done) {
      return "done";
    }

    return "todo";
  }

  static TimesheetTaskStatus getTaskStatusInEnum(String status) {
    if (status == "inProgress") {
      return TimesheetTaskStatus.inProgress;
    } else if (status == "done") {
      return TimesheetTaskStatus.done;
    }

    return TimesheetTaskStatus.todo;
  }
}
