import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:tapped/tapped.dart';
import 'package:todo/core/res/app_theme/app_theme.dart';
import 'package:todo/core/utils/utils.dart';

typedef OnHourUpdate = Function(Duration newHour);

class TimesheetTimeSelector extends StatelessWidget {
  final Duration hours;
  final OnHourUpdate onHourUpdate;

  const TimesheetTimeSelector(
      {super.key, required this.hours, required this.onHourUpdate});

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: () async {
        Duration? resultingDuration = await showDurationPicker(
          context: context,
          initialTime: hours,
        );

        if (resultingDuration != null) {
          // ignore: use_build_context_synchronously
          _showConfirmationToUpdateTime(context, resultingDuration);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.color.greyLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(Utils.getFormattedDuration(hours)),
      ),
    );
  }

  void _showConfirmationToUpdateTime(BuildContext context, Duration duration) {
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Navigator.pop(context);

        onHourUpdate(duration);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure, do you like to update hour?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
