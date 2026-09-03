import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/calendar_event.dart';
import '../models/calendar_event_category.dart';
import '../models/event_energy_impact.dart';
import 'event_category_selector.dart';
import 'event_energy_impact_selector.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onCategorySelected,
    required this.onEnergyImpactSelected,
    this.now,
    this.onEditEvent,
    this.onDeleteEvent,
  });

  final CalendarEvent event;
  final ValueChanged<CalendarEventCategory> onCategorySelected;
  final ValueChanged<EventEnergyImpact> onEnergyImpactSelected;
  final DateTime? now;
  final VoidCallback? onEditEvent;
  final VoidCallback? onDeleteEvent;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late bool isChoosingCategory;

  @override
  void initState() {
    super.initState();
    isChoosingCategory = widget.event.category == null;
  }

  @override
  void didUpdateWidget(EventCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.event.id != widget.event.id) {
      isChoosingCategory = widget.event.category == null;
    } else if (oldWidget.event.category != null &&
        widget.event.category == null) {
      isChoosingCategory = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final event = widget.event;
    final hasEnded = !event.endTime.isAfter(widget.now ?? DateTime.now());

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 64, child: _EventTimeRange(event: event)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (event.category != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                event.category!.label,
                                style: textTheme.labelMedium?.copyWith(
                                  color: AppColors.mintText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isChoosingCategory = !isChoosingCategory;
                                });
                              },
                              child: Text(
                                isChoosingCategory ? 'Close' : 'Edit',
                                style: textTheme.labelMedium?.copyWith(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.onEditEvent != null || widget.onDeleteEvent != null)
                  PopupMenuButton<_EventMenuAction>(
                    tooltip: 'Activity options',
                    onSelected: (action) {
                      switch (action) {
                        case _EventMenuAction.edit:
                          widget.onEditEvent?.call();
                        case _EventMenuAction.delete:
                          widget.onDeleteEvent?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      if (widget.onEditEvent != null)
                        const PopupMenuItem(
                          value: _EventMenuAction.edit,
                          child: Text('Edit activity'),
                        ),
                      if (widget.onDeleteEvent != null)
                        const PopupMenuItem(
                          value: _EventMenuAction.delete,
                          child: Text('Delete activity'),
                        ),
                    ],
                  ),
              ],
            ),
            if (isChoosingCategory) ...[
              const SizedBox(height: 22),
              Text(
                event.category == null
                    ? 'Choose a category'
                    : 'Change category',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              EventCategorySelector(
                selectedCategory: event.category,
                onSelected: (category) {
                  widget.onCategorySelected(category);
                  setState(() {
                    isChoosingCategory = false;
                  });
                },
              ),
            ],
            if (hasEnded) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Text(
                'How did this activity affect your energy?',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 14),
              EventEnergyImpactSelector(
                selectedImpact: event.energyImpact,
                onSelected: widget.onEnergyImpactSelected,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _EventMenuAction { edit, delete }

class _EventTimeRange extends StatelessWidget {
  const _EventTimeRange({required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w600,
    );

    if (event.isAllDay) {
      return Text('All day', style: style);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_formatTime(event.startTime), style: style),
        Container(width: 1, height: 10, color: AppColors.textMuted),
        Text(_formatTime(event.endTime), style: style),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
