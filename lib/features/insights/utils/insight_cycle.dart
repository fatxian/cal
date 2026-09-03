DateTime startOfInsightCycle({
  required DateTime anchor,
  required DateTime day,
}) {
  final anchorDate = DateTime(anchor.year, anchor.month, anchor.day);
  final targetDate = DateTime(day.year, day.month, day.day);
  if (!targetDate.isAfter(anchorDate)) return anchorDate;

  final elapsedDays = targetDate.difference(anchorDate).inDays;
  return anchorDate.add(Duration(days: (elapsedDays ~/ 7) * 7));
}
