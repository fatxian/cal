import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay?> showCupertinoTimePickerSheet({
  required BuildContext context,
  required String title,
  required TimeOfDay initialTime,
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) =>
        _CupertinoTimePickerSheet(title: title, initialTime: initialTime),
  );
}

class _CupertinoTimePickerSheet extends StatefulWidget {
  const _CupertinoTimePickerSheet({
    required this.title,
    required this.initialTime,
  });

  final String title;
  final TimeOfDay initialTime;

  @override
  State<_CupertinoTimePickerSheet> createState() =>
      _CupertinoTimePickerSheetState();
}

class _CupertinoTimePickerSheetState extends State<_CupertinoTimePickerSheet> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    selectedDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      widget.initialTime.hour,
      widget.initialTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 330,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(TimeOfDay.fromDateTime(selectedDateTime)),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: selectedDateTime,
              use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
              onDateTimeChanged: (dateTime) {
                selectedDateTime = dateTime;
              },
            ),
          ),
        ],
      ),
    );
  }
}
