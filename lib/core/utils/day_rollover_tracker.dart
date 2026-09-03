import 'date_key.dart';

class DayRolloverTracker {
  DayRolloverTracker(DateTime initialTime)
    : _currentDay = _dateOnly(initialTime);

  DateTime _currentDay;

  DateTime get currentDay => _currentDay;

  bool update(DateTime time) {
    final nextDay = _dateOnly(time);
    if (dateKey(nextDay) == dateKey(_currentDay)) {
      return false;
    }

    _currentDay = nextDay;
    return true;
  }

  static DateTime _dateOnly(DateTime time) {
    return DateTime(time.year, time.month, time.day);
  }
}
