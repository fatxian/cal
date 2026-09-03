import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/insights/utils/insight_cycle.dart';

void main() {
  test('builds seven-day cycle', () {
    final anchor = DateTime(2026, 7, 16);

    expect(
      startOfInsightCycle(anchor: anchor, day: DateTime(2026, 7, 16)),
      DateTime(2026, 7, 16),
    );
    expect(
      startOfInsightCycle(anchor: anchor, day: DateTime(2026, 7, 22)),
      DateTime(2026, 7, 16),
    );
    expect(
      startOfInsightCycle(anchor: anchor, day: DateTime(2026, 7, 23)),
      DateTime(2026, 7, 23),
    );
    expect(
      startOfInsightCycle(anchor: anchor, day: DateTime(2026, 8, 5)),
      DateTime(2026, 7, 30),
    );
  });
}
