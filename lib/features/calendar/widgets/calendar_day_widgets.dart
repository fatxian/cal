part of '../screens/calendar_screen.dart';

class _WeekSelector extends StatefulWidget {
  const _WeekSelector({required this.selectedDay, required this.onDaySelected});

  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  @override
  State<_WeekSelector> createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<_WeekSelector> {
  static const int currentWeekPage = 5200;

  late final DateTime today;
  late final DateTime currentWeekStart;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    today = _dateOnly(DateTime.now());
    currentWeekStart = _startOfWeek(today);
    pageController = PageController(
      initialPage: currentWeekPage + _weekOffsetFor(widget.selectedDay),
    );
  }

  @override
  void didUpdateWidget(_WeekSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameDay(oldWidget.selectedDay, widget.selectedDay)) {
      final targetPage = currentWeekPage + _weekOffsetFor(widget.selectedDay);
      if (pageController.hasClients) {
        pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: PageView.builder(
        controller: pageController,
        itemCount: currentWeekPage + 1,
        itemBuilder: (context, pageIndex) {
          final weekOffset = pageIndex - currentWeekPage;
          final weekStart = currentWeekStart.add(
            Duration(days: weekOffset * 7),
          );
          final days = _weekDaysFor(weekStart);

          return Row(
            children: [
              for (var index = 0; index < days.length; index++) ...[
                Expanded(
                  child: _DatePill(
                    day: days[index],
                    today: today,
                    onTap: () => widget.onDaySelected(days[index].date),
                  ),
                ),
                if (index != days.length - 1) const SizedBox(width: 6),
              ],
            ],
          );
        },
      ),
    );
  }

  List<_DayItem> _weekDaysFor(DateTime weekStart) {
    return [
      for (var offset = 0; offset < 7; offset++)
        _DayItem(
          weekStart.add(Duration(days: offset)),
          isSelected: _isSameDay(
            widget.selectedDay,
            weekStart.add(Duration(days: offset)),
          ),
        ),
    ];
  }

  int _weekOffsetFor(DateTime day) {
    return _startOfWeek(day).difference(currentWeekStart).inDays ~/ 7;
  }

  DateTime _startOfWeek(DateTime day) {
    final normalizedDay = _dateOnly(day);
    return normalizedDay.subtract(
      Duration(days: normalizedDay.weekday - DateTime.monday),
    );
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({
    required this.day,
    required this.today,
    required this.onTap,
  });

  final _DayItem day;
  final DateTime today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isToday = _isSameDay(day.date, today);
    final foreground = day.isSelected ? Colors.white : AppColors.textSecondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        key: ValueKey('date-pill-${day.date.toIso8601String()}'),
        decoration: BoxDecoration(
          color: day.isSelected ? AppColors.ink : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isToday && !day.isSelected
                ? AppColors.forestGreen
                : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.weekdayLabel,
              style: textTheme.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              day.dayLabel,
              style: textTheme.titleLarge?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _EmptyCalendarCard extends StatelessWidget {
  const _EmptyCalendarCard({required this.hasSuccessfulSync});

  final bool hasSuccessfulSync;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Text(
          hasSuccessfulSync
              ? 'No events scheduled for this day.'
              : 'No calendar events loaded yet. Please pull down to sync.',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _CalendarSyncMessageCard extends StatelessWidget {
  const _CalendarSyncMessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: AppColors.surfaceSoft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.forestGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyReflectionCard extends StatelessWidget {
  const _DailyReflectionCard({required this.energyScore, required this.onTap});

  final int? energyScore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Daily Reflection',
                      style: textTheme.titleLarge?.copyWith(fontSize: 20),
                    ),
                    if (energyScore == null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Review your day and record your energy',
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                    SizedBox(height: energyScore == null ? 24 : 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          energyScore == null
                              ? 'Add reflection'
                              : 'View or edit',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.ink,
                          size: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (energyScore != null) ...[
                const SizedBox(width: 16),
                EnergyMoodBadge(score: energyScore!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DayItem {
  const _DayItem(this.date, {this.isSelected = false});

  final DateTime date;
  final bool isSelected;

  String get weekdayLabel {
    return switch (date.weekday) {
      DateTime.monday => 'Mon',
      DateTime.tuesday => 'Tue',
      DateTime.wednesday => 'Wed',
      DateTime.thursday => 'Thu',
      DateTime.friday => 'Fri',
      DateTime.saturday => 'Sat',
      DateTime.sunday => 'Sun',
      _ => '',
    };
  }

  String get dayLabel => date.day.toString();
}
