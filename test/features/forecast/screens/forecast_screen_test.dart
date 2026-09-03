import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/models/manual_calendar_event_input.dart';
import 'package:calendar_app/features/calendar/services/calendar_event_collection_service.dart';
import 'package:calendar_app/features/calendar/services/calendar_sync_service.dart';
import 'package:calendar_app/features/calendar/services/event_user_data_service.dart';
import 'package:calendar_app/features/calendar/services/manual_calendar_event_service.dart';
import 'package:calendar_app/features/forecast/screens/forecast_screen.dart';
import 'package:calendar_app/features/forecast/services/daily_intention_service.dart';
import 'package:calendar_app/features/forecast/services/forecast_reflection_service.dart';
import 'package:calendar_app/features/forecast/services/forecast_reflection_option_service.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_calculator.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_service.dart';
import 'package:calendar_app/features/prediction/services/energy_model_service.dart';

void main() {
  testWidgets('asks before reveal', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventService = EventUserDataService(database: database);
    final calendarSyncService = CalendarSyncService(database: database);
    final modelService = EnergyModelService(database: database);
    final predictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: modelService,
    );
    final selectedTabNotifier = ValueNotifier(1);
    final calendarSyncNotifier = ValueNotifier(0);
    var forecastViewCount = 0;
    addTearDown(() async {
      selectedTabNotifier.dispose();
      calendarSyncNotifier.dispose();
      await database.close();
    });
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final events = [
      CalendarEvent(
        id: 'study',
        title: 'Study',
        startTime: DateTime(day.year, day.month, day.day, 10),
        endTime: DateTime(day.year, day.month, day.day, 11),
        category: CalendarEventCategory.focus,
      ),
      CalendarEvent(
        id: 'exercise',
        title: 'Exercise',
        startTime: DateTime(day.year, day.month, day.day, 15),
        endTime: DateTime(day.year, day.month, day.day, 16),
        category: CalendarEventCategory.exercise,
      ),
    ];
    await eventService.replaceCachedEventsForDay(day, events);
    await calendarSyncService.saveSuccessfulSync(
      day: day,
      source: CalendarEventSource.google,
      syncedAt: now,
      eventCount: events.length,
    );
    await modelService.saveActiveModel(
      parameters: LogisticModelParameters(
        featureVersion: EnergyModelContract.featureVersion,
        targetVersion: EnergyModelContract.targetVersion,
        modelVersion: 'questionnaire-baseline-test',
        intercept: 0,
        coefficients: {
          for (final feature in EnergyModelContract.orderedFeatures)
            feature: switch (feature) {
              EnergyModelFeature.focusMinutes => 1,
              EnergyModelFeature.exerciseMinutes => -1,
              _ => 0,
            },
        },
      ),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );
    await predictionService.loadOrCreateInitialPrediction(
      day: day,
      events: events,
      capturedAt: now,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ForecastScreen(
          calendarEventCollectionService: CalendarEventCollectionService(
            syncedEventService: eventService,
            manualEventService: ManualCalendarEventService(database: database),
          ),
          calendarSyncService: calendarSyncService,
          dailyIntentionService: DailyIntentionService(database: database),
          forecastReflectionService: ForecastReflectionService(
            database: database,
          ),
          dailyPredictionService: predictionService,
          energyModelService: modelService,
          reflectionOptionService: const ForecastReflectionOptionService(),
          calendarSyncNotifier: calendarSyncNotifier,
          selectedTabNotifier: selectedTabNotifier,
          onOpenToday: () {},
          onViewed: () {
            forecastViewCount++;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(forecastViewCount, 0);
    selectedTabNotifier.value = 0;
    await tester.pump();
    selectedTabNotifier.value = 1;
    await tester.pumpAndSettle();
    expect(forecastViewCount, 1);
    await tester.pump();
    expect(forecastViewCount, 1);

    expect(find.text('Curious what Cal noticed?'), findsOneWidget);
    expect(
      find.text('Focused activities may ask more of your mental energy today.'),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('supportive-factor-dropdown')),
      findsNothing,
    );

    await tester.ensureVisible(find.text('Reveal and reflect'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reveal and reflect'));
    await tester.pumpAndSettle();

    final supportiveDropdown = find.byKey(
      const ValueKey('supportive-factor-dropdown'),
    );
    await tester.ensureVisible(supportiveDropdown);
    await tester.pumpAndSettle();
    await tester.tap(supportiveDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Exercise time').last);

    final demandingDropdown = find.byKey(
      const ValueKey('demanding-factor-dropdown'),
    );
    await tester.ensureVisible(demandingDropdown);
    await tester.pumpAndSettle();
    await tester.tap(demandingDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Focused activities').last);
    await tester.ensureVisible(find.text('Compare with Cal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compare with Cal'));
    await tester.pumpAndSettle();

    expect(find.text('Compare your view with Cal'), findsOneWidget);
    expect(find.text('Cal: Focused activities'), findsOneWidget);
    expect(find.text('Why Cal saw today this way'), findsOneWidget);
    expect(
      find.text(
        'Your schedule includes around 1 hour of focused activities today. '
        'Cal saw this as one of the strongest signals '
        'pointing towards lower energy.',
      ),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Set today\'s intention'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Set today\'s intention'), findsOneWidget);

    final refreshButton = find.byKey(
      const ValueKey('show-other-intention-ideas'),
    );
    await tester.scrollUntilVisible(
      refreshButton,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -180));
    await tester.pumpAndSettle();
    expect(find.text('Show me other ideas'), findsOneWidget);
    expect(find.text('No change today'), findsOneWidget);

    await tester.tap(refreshButton);
    await tester.pumpAndSettle();

    expect(find.text('Show me other ideas'), findsOneWidget);
    expect(find.text('No change today'), findsOneWidget);
  });

  testWidgets('requires activity categories', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventService = EventUserDataService(database: database);
    final calendarSyncService = CalendarSyncService(database: database);
    final modelService = EnergyModelService(database: database);
    final predictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: modelService,
    );
    final selectedTabNotifier = ValueNotifier(1);
    final calendarSyncNotifier = ValueNotifier(0);
    addTearDown(() async {
      selectedTabNotifier.dispose();
      calendarSyncNotifier.dispose();
      await database.close();
    });
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final event = CalendarEvent(
      id: 'uncategorised',
      title: 'Uncategorised activity',
      startTime: DateTime(day.year, day.month, day.day, 12),
      endTime: DateTime(day.year, day.month, day.day, 13),
      source: CalendarEventSource.google,
      externalId: 'uncategorised',
    );
    await eventService.replaceCachedEventsForDay(day, [event]);
    await calendarSyncService.saveSuccessfulSync(
      day: day,
      source: CalendarEventSource.google,
      syncedAt: now,
      eventCount: 1,
    );
    await modelService.saveActiveModel(
      parameters: LogisticModelParameters(
        featureVersion: EnergyModelContract.featureVersion,
        targetVersion: EnergyModelContract.targetVersion,
        modelVersion: 'questionnaire-baseline-test',
        intercept: 0,
        coefficients: {
          for (final feature in EnergyModelContract.orderedFeatures) feature: 0,
        },
      ),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );
    await predictionService.loadOrCreateInitialPrediction(
      day: day,
      events: [event],
      capturedAt: now,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ForecastScreen(
          calendarEventCollectionService: CalendarEventCollectionService(
            syncedEventService: eventService,
            manualEventService: ManualCalendarEventService(database: database),
          ),
          calendarSyncService: calendarSyncService,
          dailyIntentionService: DailyIntentionService(database: database),
          forecastReflectionService: ForecastReflectionService(
            database: database,
          ),
          dailyPredictionService: predictionService,
          energyModelService: modelService,
          reflectionOptionService: const ForecastReflectionOptionService(),
          calendarSyncNotifier: calendarSyncNotifier,
          selectedTabNotifier: selectedTabNotifier,
          onOpenToday: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Categorise today\'s activities'), findsOneWidget);
    expect(find.textContaining('1 activity still needs'), findsOneWidget);
    expect(find.text('Curious what Cal noticed?'), findsNothing);

    await eventService.saveEventUserData(
      event.copyWith(category: CalendarEventCategory.notSure),
    );
    selectedTabNotifier.value = 0;
    await tester.pump();
    selectedTabNotifier.value = 1;
    await tester.pumpAndSettle();

    expect(find.text('Categorise today\'s activities'), findsNothing);
    expect(find.text('Curious what Cal noticed?'), findsOneWidget);
  });

  testWidgets('accepts manual activities', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventService = EventUserDataService(database: database);
    final manualEventService = ManualCalendarEventService(database: database);
    final collectionService = CalendarEventCollectionService(
      syncedEventService: eventService,
      manualEventService: manualEventService,
    );
    final calendarSyncService = CalendarSyncService(database: database);
    final modelService = EnergyModelService(database: database);
    final predictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: modelService,
    );
    final selectedTabNotifier = ValueNotifier(1);
    final calendarSyncNotifier = ValueNotifier(0);
    addTearDown(() async {
      selectedTabNotifier.dispose();
      calendarSyncNotifier.dispose();
      await database.close();
    });
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final event = await manualEventService.createEvent(
      ManualCalendarEventInput(
        title: 'Study',
        startTime: DateTime(day.year, day.month, day.day, 10),
        endTime: DateTime(day.year, day.month, day.day, 11),
        category: CalendarEventCategory.focus,
      ),
    );
    await modelService.saveActiveModel(
      parameters: LogisticModelParameters(
        featureVersion: EnergyModelContract.featureVersion,
        targetVersion: EnergyModelContract.targetVersion,
        modelVersion: 'questionnaire-baseline-test',
        intercept: 0,
        coefficients: {
          for (final feature in EnergyModelContract.orderedFeatures) feature: 0,
        },
      ),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );
    await predictionService.loadOrCreateInitialPrediction(
      day: day,
      events: [event],
      capturedAt: now,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ForecastScreen(
          calendarEventCollectionService: collectionService,
          calendarSyncService: calendarSyncService,
          dailyIntentionService: DailyIntentionService(database: database),
          forecastReflectionService: ForecastReflectionService(
            database: database,
          ),
          dailyPredictionService: predictionService,
          energyModelService: modelService,
          reflectionOptionService: const ForecastReflectionOptionService(),
          calendarSyncNotifier: calendarSyncNotifier,
          selectedTabNotifier: selectedTabNotifier,
          onOpenToday: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add or sync today\'s activities'), findsNothing);
    expect(find.text('Curious what Cal noticed?'), findsOneWidget);
  });

  testWidgets('reloads background prediction', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventService = EventUserDataService(database: database);
    final manualEventService = ManualCalendarEventService(database: database);
    final collectionService = CalendarEventCollectionService(
      syncedEventService: eventService,
      manualEventService: manualEventService,
    );
    final calendarSyncService = CalendarSyncService(database: database);
    final modelService = EnergyModelService(database: database);
    final predictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: modelService,
    );
    final selectedTabNotifier = ValueNotifier(0);
    final calendarSyncNotifier = ValueNotifier(0);
    addTearDown(() async {
      selectedTabNotifier.dispose();
      calendarSyncNotifier.dispose();
      await database.close();
    });

    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final event = CalendarEvent(
      id: 'late-prediction-event',
      title: 'Study',
      startTime: DateTime(day.year, day.month, day.day, 10),
      endTime: DateTime(day.year, day.month, day.day, 11),
      category: CalendarEventCategory.focus,
      source: CalendarEventSource.google,
      externalId: 'late-prediction-event',
    );
    await eventService.replaceCachedEventsForDay(day, [event]);
    await calendarSyncService.saveSuccessfulSync(
      day: day,
      source: CalendarEventSource.google,
      syncedAt: now,
      eventCount: 1,
    );
    await modelService.saveActiveModel(
      parameters: LogisticModelParameters(
        featureVersion: EnergyModelContract.featureVersion,
        targetVersion: EnergyModelContract.targetVersion,
        modelVersion: 'questionnaire-baseline-test',
        intercept: 0,
        coefficients: {
          for (final feature in EnergyModelContract.orderedFeatures) feature: 0,
        },
      ),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ForecastScreen(
          calendarEventCollectionService: collectionService,
          calendarSyncService: calendarSyncService,
          dailyIntentionService: DailyIntentionService(database: database),
          forecastReflectionService: ForecastReflectionService(
            database: database,
          ),
          dailyPredictionService: predictionService,
          energyModelService: modelService,
          reflectionOptionService: const ForecastReflectionOptionService(),
          calendarSyncNotifier: calendarSyncNotifier,
          selectedTabNotifier: selectedTabNotifier,
          onOpenToday: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reveal today\'s forecast'), findsOneWidget);

    await predictionService.loadOrCreateInitialPrediction(
      day: day,
      events: [event],
      capturedAt: now,
    );
    selectedTabNotifier.value = 1;
    await tester.pumpAndSettle();

    expect(find.text('Reveal today\'s forecast'), findsNothing);
    expect(find.text('Curious what Cal noticed?'), findsOneWidget);
  });

  testWidgets('keeps ready forecast', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final eventService = EventUserDataService(database: database);
    final manualEventService = ManualCalendarEventService(database: database);
    final collectionService = _QueuedCalendarEventCollectionService(
      syncedEventService: eventService,
      manualEventService: manualEventService,
    );
    final calendarSyncService = CalendarSyncService(database: database);
    final modelService = EnergyModelService(database: database);
    final predictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: modelService,
    );
    final selectedTabNotifier = ValueNotifier(0);
    final calendarSyncNotifier = ValueNotifier(0);
    addTearDown(() async {
      selectedTabNotifier.dispose();
      calendarSyncNotifier.dispose();
      await database.close();
    });

    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final event = CalendarEvent(
      id: 'ready-event',
      title: 'Study',
      startTime: DateTime(day.year, day.month, day.day, 10),
      endTime: DateTime(day.year, day.month, day.day, 11),
      category: CalendarEventCategory.focus,
      source: CalendarEventSource.google,
      externalId: 'ready-event',
    );
    await eventService.replaceCachedEventsForDay(day, [event]);
    await calendarSyncService.saveSuccessfulSync(
      day: day,
      source: CalendarEventSource.google,
      syncedAt: now,
      eventCount: 1,
    );
    await modelService.saveActiveModel(
      parameters: LogisticModelParameters(
        featureVersion: EnergyModelContract.featureVersion,
        targetVersion: EnergyModelContract.targetVersion,
        modelVersion: 'questionnaire-baseline-test',
        intercept: 0,
        coefficients: {
          for (final feature in EnergyModelContract.orderedFeatures) feature: 0,
        },
      ),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ForecastScreen(
          calendarEventCollectionService: collectionService,
          calendarSyncService: calendarSyncService,
          dailyIntentionService: DailyIntentionService(database: database),
          forecastReflectionService: ForecastReflectionService(
            database: database,
          ),
          dailyPredictionService: predictionService,
          energyModelService: modelService,
          reflectionOptionService: const ForecastReflectionOptionService(),
          calendarSyncNotifier: calendarSyncNotifier,
          selectedTabNotifier: selectedTabNotifier,
          onOpenToday: () {},
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(collectionService.requestCount, 1);

    await predictionService.loadOrCreateInitialPrediction(
      day: day,
      events: [event],
      capturedAt: now,
    );
    selectedTabNotifier.value = 1;
    await tester.pump();
    await tester.pump();
    expect(collectionService.requestCount, 2);

    collectionService.completeRequest(1, [event]);
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(find.text('Curious what Cal noticed?'), findsOneWidget);

    collectionService.completeRequest(0, const []);
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('Curious what Cal noticed?'), findsOneWidget);
    expect(find.text('Reveal today\'s forecast'), findsNothing);
  });
}

class _QueuedCalendarEventCollectionService
    extends CalendarEventCollectionService {
  _QueuedCalendarEventCollectionService({
    required super.syncedEventService,
    required super.manualEventService,
  });

  final List<Completer<List<CalendarEvent>>> _requests = [];

  int get requestCount => _requests.length;

  @override
  Future<List<CalendarEvent>> loadEventsForDay(DateTime day) {
    final request = Completer<List<CalendarEvent>>();
    _requests.add(request);
    return request.future;
  }

  void completeRequest(int index, List<CalendarEvent> events) {
    _requests[index].complete(events);
  }
}
