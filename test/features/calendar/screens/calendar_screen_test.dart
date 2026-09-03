import 'dart:async';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/models/event_energy_impact.dart';
import 'package:calendar_app/features/calendar/screens/calendar_screen.dart';
import 'package:calendar_app/features/calendar/services/calendar_event_collection_service.dart';
import 'package:calendar_app/features/calendar/services/calendar_sync_service.dart';
import 'package:calendar_app/features/calendar/services/event_user_data_service.dart';
import 'package:calendar_app/features/calendar/services/google_calendar_service.dart';
import 'package:calendar_app/features/calendar/services/manual_calendar_event_service.dart';
import 'package:calendar_app/features/check_in/services/daily_reflection_service.dart';
import 'package:calendar_app/features/forecast/services/daily_intention_service.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_calculator.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_service.dart';
import 'package:calendar_app/features/prediction/services/energy_model_service.dart';
import 'package:calendar_app/features/prediction/services/personalised_model_update_service.dart';
import 'package:calendar_app/features/prediction/services/prediction_dataset_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps selected day', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final syncedEventService = EventUserDataService(database: database);
    final manualEventService = ManualCalendarEventService(database: database);
    final eventCollectionService = _ControlledEventCollectionService(
      syncedEventService: syncedEventService,
      manualEventService: manualEventService,
    );
    final energyModelService = EnergyModelService(database: database);
    final predictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: energyModelService,
    );
    final datasetService = PredictionDatasetService(database: database);

    addTearDown(database.close);

    await tester.pumpWidget(
      MaterialApp(
        home: CalendarScreen(
          googleCalendarService: _FakeGoogleCalendarService(),
          calendarEventCollectionService: eventCollectionService,
          calendarSyncService: CalendarSyncService(database: database),
          dailyReflectionService: DailyReflectionService(database: database),
          dailyIntentionService: DailyIntentionService(database: database),
          dailyPredictionService: predictionService,
          personalisedModelUpdateService: PersonalisedModelUpdateService(
            datasetService: datasetService,
            energyModelService: energyModelService,
          ),
          onCalendarSynced: () {},
          onOpenForecast: () {},
        ),
      ),
    );
    await tester.pump();

    final today = _dateOnly(DateTime.now());
    final selectedDay = today.weekday == DateTime.monday
        ? today.add(const Duration(days: 1))
        : today.subtract(const Duration(days: 1));

    await tester.tap(
      find.byKey(ValueKey('date-pill-${selectedDay.toIso8601String()}')),
    );
    await tester.pump();

    eventCollectionService.complete(selectedDay, [
      _eventFor(selectedDay, id: 'selected', title: 'Selected day activity'),
    ]);
    await tester.pump();
    await tester.pump();

    expect(find.text('Selected day activity'), findsOneWidget);

    eventCollectionService.complete(today, [
      _eventFor(today, id: 'stale', title: 'Stale activity'),
    ]);
    await tester.pump();
    await tester.pump();

    expect(find.text('Selected day activity'), findsOneWidget);
    expect(find.text('Stale activity'), findsNothing);
  });

  testWidgets('queues activity updates', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final syncedEventService = EventUserDataService(database: database);
    final manualEventService = ManualCalendarEventService(database: database);
    final today = _dateOnly(DateTime.now());
    final event = CalendarEvent(
      id: 'rapid-update',
      title: 'Focused work',
      startTime: DateTime(today.year, today.month, today.day),
      endTime: DateTime(today.year, today.month, today.day, 0, 1),
      category: CalendarEventCategory.focus,
      source: CalendarEventSource.google,
      externalId: 'rapid-update',
    );
    final eventCollectionService = _ControlledSaveEventCollectionService(
      syncedEventService: syncedEventService,
      manualEventService: manualEventService,
      events: [event],
    );
    final energyModelService = EnergyModelService(database: database);
    final predictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: energyModelService,
    );

    addTearDown(database.close);

    await tester.pumpWidget(
      MaterialApp(
        home: CalendarScreen(
          googleCalendarService: _FakeGoogleCalendarService(),
          calendarEventCollectionService: eventCollectionService,
          calendarSyncService: CalendarSyncService(database: database),
          dailyReflectionService: DailyReflectionService(database: database),
          dailyIntentionService: DailyIntentionService(database: database),
          dailyPredictionService: predictionService,
          personalisedModelUpdateService: PersonalisedModelUpdateService(
            datasetService: PredictionDatasetService(database: database),
            energyModelService: energyModelService,
          ),
          onCalendarSynced: () {},
          onOpenForecast: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Decreased'));
    await tester.pump();
    await tester.tap(find.text('Increased'));
    await tester.pump();

    expect(eventCollectionService.saveRequests, hasLength(1));
    expect(
      eventCollectionService.saveRequests.first.energyImpact,
      EventEnergyImpact.decreased,
    );

    eventCollectionService.completeSave(0);
    await tester.pump();
    await tester.pump();

    expect(eventCollectionService.saveRequests, hasLength(2));
    expect(
      eventCollectionService.saveRequests.last.energyImpact,
      EventEnergyImpact.increased,
    );

    eventCollectionService.completeSave(1);
    await tester.pump();
  });
}

class _ControlledEventCollectionService extends CalendarEventCollectionService {
  _ControlledEventCollectionService({
    required super.syncedEventService,
    required super.manualEventService,
  });

  final Map<String, Completer<List<CalendarEvent>>> _requests = {};

  @override
  Future<List<CalendarEvent>> loadEventsForDay(DateTime day) {
    return _requests.putIfAbsent(_dateKey(day), Completer.new).future;
  }

  void complete(DateTime day, List<CalendarEvent> events) {
    _requests.putIfAbsent(_dateKey(day), Completer.new).complete(events);
  }
}

class _FakeGoogleCalendarService extends GoogleCalendarService {
  _FakeGoogleCalendarService() : super(googleWebClientId: 'test-client-id');

  @override
  Future<void> initialize() async {}
}

class _ControlledSaveEventCollectionService
    extends CalendarEventCollectionService {
  _ControlledSaveEventCollectionService({
    required super.syncedEventService,
    required super.manualEventService,
    required this.events,
  });

  final List<CalendarEvent> events;
  final List<CalendarEvent> saveRequests = [];
  final List<Completer<void>> _saveCompleters = [];

  @override
  Future<List<CalendarEvent>> loadEventsForDay(DateTime day) async => events;

  @override
  Future<void> saveEventChanges(CalendarEvent event) {
    saveRequests.add(event);
    final completer = Completer<void>();
    _saveCompleters.add(completer);
    return completer.future;
  }

  void completeSave(int index) {
    _saveCompleters[index].complete();
  }
}

CalendarEvent _eventFor(
  DateTime day, {
  required String id,
  required String title,
}) {
  return CalendarEvent(
    id: id,
    title: title,
    startTime: DateTime(day.year, day.month, day.day, 10),
    endTime: DateTime(day.year, day.month, day.day, 11),
    source: CalendarEventSource.google,
  );
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

String _dateKey(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
