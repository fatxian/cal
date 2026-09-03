import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cupertino_time_picker_sheet.dart';
import '../models/calendar_event.dart';
import '../models/calendar_event_category.dart';
import '../models/manual_calendar_event_input.dart';
import '../widgets/event_category_selector.dart';

class ManualEventEditorScreen extends StatefulWidget {
  const ManualEventEditorScreen({
    super.key,
    required this.day,
    this.initialEvent,
  });

  final DateTime day;
  final CalendarEvent? initialEvent;

  @override
  State<ManualEventEditorScreen> createState() =>
      _ManualEventEditorScreenState();
}

class _ManualEventEditorScreenState extends State<ManualEventEditorScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  CalendarEventCategory? selectedCategory;
  String? formError;

  @override
  void initState() {
    super.initState();
    final event = widget.initialEvent;
    final defaultStart = event?.startTime ?? _defaultStartTime();
    final defaultEnd = event?.endTime ?? _defaultEndTime(defaultStart);

    titleController = TextEditingController(text: event?.title ?? '');
    startTime = TimeOfDay.fromDateTime(defaultStart);
    endTime = TimeOfDay.fromDateTime(defaultEnd);
    selectedCategory = event?.category;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialEvent == null ? 'Add activity' : 'Edit activity',
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                controller: titleController,
                autofocus: widget.initialEvent == null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Activity name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an activity name.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Date', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 20),
                const SizedBox(width: 10),
                Text(_formatDate(widget.day), style: textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 24),
            Text('Time', style: textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _TimeButton(
                    label: 'Starts',
                    time: startTime,
                    onTap: () => _selectTime(isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeButton(
                    label: 'Ends',
                    time: endTime,
                    onTap: () => _selectTime(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Text('Category', style: textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Choose the closest match so Cal can use this activity in your forecast.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            EventCategorySelector(
              selectedCategory: selectedCategory,
              onSelected: (category) {
                setState(() {
                  selectedCategory = category;
                  formError = null;
                });
              },
            ),
            if (formError != null) ...[
              const SizedBox(height: 12),
              Text(
                formError!,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.error),
              ),
            ],
            const SizedBox(height: 30),
            FilledButton(onPressed: _save, child: const Text('Save activity')),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime({required bool isStart}) async {
    final selected = await showCupertinoTimePickerSheet(
      context: context,
      title: isStart ? 'Start time' : 'End time',
      initialTime: isStart ? startTime : endTime,
    );
    if (selected == null || !mounted) return;

    setState(() {
      if (isStart) {
        startTime = selected;
      } else {
        endTime = selected;
      }
      formError = null;
    });
  }

  void _save() {
    final category = selectedCategory;
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (category == null) {
      setState(() {
        formError = 'Choose a category or Not sure.';
      });
      return;
    }

    final start = _combine(widget.day, startTime);
    final end = _combine(widget.day, endTime);
    if (!end.isAfter(start)) {
      setState(() {
        formError = 'End time must be after start time.';
      });
      return;
    }

    Navigator.of(context).pop(
      ManualCalendarEventInput(
        title: titleController.text.trim(),
        startTime: start,
        endTime: end,
        category: category,
      ),
    );
  }

  DateTime _defaultStartTime() {
    final now = DateTime.now();
    if (!_isSameDay(now, widget.day)) {
      return DateTime(widget.day.year, widget.day.month, widget.day.day, 9);
    }

    if (now.hour == 23 && now.minute >= 30) {
      return DateTime(widget.day.year, widget.day.month, widget.day.day, 23);
    }

    final roundedMinute = now.minute < 30 ? 30 : 0;
    final extraHour = now.minute < 30 ? 0 : 1;
    return DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      now.hour + extraHour,
      roundedMinute,
    );
  }

  DateTime _defaultEndTime(DateTime start) {
    if (start.hour == 23) {
      return DateTime(start.year, start.month, start.day, 23, 59);
    }

    return start.add(const Duration(hours: 1));
  }

  DateTime _combine(DateTime day, TimeOfDay time) {
    return DateTime(day.year, day.month, day.day, time.hour, time.minute);
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _formatDate(DateTime day) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[day.month - 1]} ${day.day}, ${day.year}';
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(time.format(context)),
        ],
      ),
    );
  }
}
