import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/calendar/models/calendar_event.dart';
import 'package:calendar_app/features/calendar/models/calendar_event_category.dart';
import 'package:calendar_app/features/calendar/services/calendar_event_collection_service.dart';
import 'package:calendar_app/features/calendar/services/calendar_sync_service.dart';
import 'package:calendar_app/features/calendar/services/event_user_data_service.dart';
import 'package:calendar_app/features/calendar/services/manual_calendar_event_service.dart';
import 'package:calendar_app/features/forecast/controllers/forecast_controller.dart';
import 'package:calendar_app/features/forecast/services/daily_intention_service.dart';
import 'package:calendar_app/features/forecast/services/forecast_reflection_option_service.dart';
import 'package:calendar_app/features/forecast/services/forecast_reflection_service.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_calculator.dart';
import 'package:calendar_app/features/prediction/services/daily_feature_snapshot_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_service.dart';
import 'package:calendar_app/features/prediction/services/energy_model_service.dart';

void main() {
  late AppDatabase database;
  late EventUserDataService eventService;
  late ManualCalendarEventService manualEventService;
  late CalendarSyncService calendarSyncService;
  late EnergyModelService modelService;
  late DailyPredictionService predictionService;
  late DateTime now;
  late DateTime day;
  late CalendarEvent event;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    eventService = EventUserDataService(database: database);
    manualEventService = ManualCalendarEventService(database: database);
    calendarSyncService = CalendarSyncService(database: database);
    modelService = EnergyModelService(database: database);
    predictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: modelService,
    );
    now = DateTime(2026, 7, 20, 9);
    day = DateTime(2026, 7, 20);
    event = CalendarEvent(
      id: 'today-event',
      title: 'Study',
      startTime: DateTime(2026, 7, 20, 10),
      endTime: DateTime(2026, 7, 20, 11),
      category: CalendarEventCategory.focus,
      source: CalendarEventSource.google,
      externalId: 'today-event',
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
  });

  tearDown(() => database.close());

  ForecastController buildController({
    required CalendarEventCollectionService collectionService,
  }) {
    return ForecastController(
      calendarEventCollectionService: collectionService,
      calendarSyncService: calendarSyncService,
      dailyIntentionService: DailyIntentionService(database: database),
      forecastReflectionService: ForecastReflectionService(database: database),
      dailyPredictionService: predictionService,
      energyModelService: modelService,
      reflectionOptionService: const ForecastReflectionOptionService(),
      now: () => now,
    );
  }

  test('loads ready prediction', () async {
    final createdPrediction = await predictionService
        .loadOrCreateInitialPrediction(
          day: day,
          events: [event],
          capturedAt: now,
        );
    final controller = buildController(
      collectionService: CalendarEventCollectionService(
        syncedEventService: eventService,
        manualEventService: manualEventService,
      ),
    );
    addTearDown(controller.dispose);

    await controller.loadForecastData();

    expect(controller.canOpenForecast, isTrue);
    expect(controller.dailyPrediction?.id, createdPrediction.id);
    expect(
      controller.dailyPrediction?.featureSnapshotId,
      createdPrediction.featureSnapshotId,
    );
  });

  test('ignores stale forecast', () async {
    final collectionService = _QueuedCalendarEventCollectionService(
      syncedEventService: eventService,
      manualEventService: manualEventService,
    );
    final controller = buildController(collectionService: collectionService);
    addTearDown(controller.dispose);

    final staleLoad = controller.loadForecastData();
    await _waitForRequests(collectionService, 1);

    final createdPrediction = await predictionService
        .loadOrCreateInitialPrediction(
          day: day,
          events: [event],
          capturedAt: now,
        );

    final syncRefresh = controller.recalculateFactorOptions();
    final tabEntry = controller.prepareForTabEntry();
    await _waitForRequests(collectionService, 3);

    collectionService.completeRequest(1, [event]);
    collectionService.completeRequest(2, [event]);
    await Future.wait([syncRefresh, tabEntry]);

    expect(controller.canOpenForecast, isTrue);
    expect(controller.dailyPrediction?.id, createdPrediction.id);

    collectionService.completeRequest(0, const []);
    await staleLoad;

    expect(controller.canOpenForecast, isTrue);
    expect(controller.dailyPrediction?.id, createdPrediction.id);
    expect(controller.currentEvents.map((item) => item.id), ['today-event']);
  });
}

Future<void> _waitForRequests(
  _QueuedCalendarEventCollectionService service,
  int expectedCount,
) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    if (service.requestCount >= expectedCount) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('Expected $expectedCount event requests, got ${service.requestCount}.');
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
