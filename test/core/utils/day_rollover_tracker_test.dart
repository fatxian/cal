import 'package:calendar_app/core/utils/day_rollover_tracker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('detects day change', () {
    final tracker = DayRolloverTracker(DateTime(2026, 8, 3, 9));

    expect(tracker.update(DateTime(2026, 8, 3, 23, 59)), isFalse);
    expect(tracker.update(DateTime(2026, 8, 4)), isTrue);
    expect(tracker.currentDay, DateTime(2026, 8, 4));
    expect(tracker.update(DateTime(2026, 8, 4, 12)), isFalse);
  });
}
