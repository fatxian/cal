import 'dart:async';

import 'package:calendar_app/features/calendar/services/google_calendar_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('retries initialization', () async {
    var attempts = 0;
    final service = GoogleCalendarService.forTesting(
      platformInitializer: () async {
        attempts++;
        if (attempts == 1) {
          throw StateError('initialization failed');
        }
      },
    );
    addTearDown(service.dispose);

    await expectLater(service.initialize(), throwsStateError);
    await service.initialize();

    expect(attempts, 2);
  });

  test('shares initialization', () async {
    var attempts = 0;
    final completer = Completer<void>();
    final service = GoogleCalendarService.forTesting(
      platformInitializer: () {
        attempts++;
        return completer.future;
      },
    );
    addTearDown(service.dispose);

    final first = service.initialize();
    final second = service.initialize();
    completer.complete();
    await Future.wait([first, second]);

    expect(attempts, 1);
  });
}
