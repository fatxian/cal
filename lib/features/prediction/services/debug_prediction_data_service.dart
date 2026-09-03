import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../../calendar/models/calendar_event.dart';
import '../../calendar/models/calendar_event_category.dart';
import '../../check_in/models/daily_reflection.dart';
import '../../check_in/services/daily_reflection_service.dart';
import '../models/model_update_result.dart';
import 'daily_prediction_service.dart';
import 'energy_model_service.dart';
import 'personalised_model_update_service.dart';
import 'prediction_dataset_service.dart';

class DebugPredictionDataService {
  const DebugPredictionDataService({
    required this.database,
    required this.dailyPredictionService,
    required this.dailyReflectionService,
    required this.datasetService,
    required this.modelUpdateService,
    required this.energyModelService,
  });

  static const String seedMarker = 'debug-model-seed-v1';
  static const int requiredSampleCount = 7;

  final AppDatabase database;
  final DailyPredictionService dailyPredictionService;
  final DailyReflectionService dailyReflectionService;
  final PredictionDatasetService datasetService;
  final PersonalisedModelUpdateService modelUpdateService;
  final EnergyModelService energyModelService;

  Future<DebugPredictionSeedResult> generateReadyDataset() async {
    if (await energyModelService.loadActiveModel() == null) {
      throw StateError(
        'Complete the onboarding questionnaire before generating test data.',
      );
    }

    final existingSamples = await datasetService.loadCompletedSamples();
    var sampleCount = existingSamples.length;
    var hasLowEnergy = existingSamples.any(
      (sample) => sample.lowEnergyLabel == 1,
    );
    var hasHigherEnergy = existingSamples.any(
      (sample) => sample.lowEnergyLabel == 0,
    );
    final occupiedDates = await _loadOccupiedDates();
    var candidateDay = _dateOnly(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    var generatedCount = 0;

    while (sampleCount < requiredSampleCount ||
        !hasLowEnergy ||
        !hasHigherEnergy) {
      final date = dateKey(candidateDay);
      if (!occupiedDates.contains(date)) {
        final shouldBeLowEnergy = !hasLowEnergy
            ? true
            : !hasHigherEnergy
            ? false
            : generatedCount.isEven;
        final events = _eventsForDay(
          candidateDay,
          lowEnergy: shouldBeLowEnergy,
          variant: generatedCount,
        );
        final capturedAt = DateTime(
          candidateDay.year,
          candidateDay.month,
          candidateDay.day,
          8,
        );

        await dailyPredictionService.loadOrCreateInitialPrediction(
          day: candidateDay,
          events: events,
          capturedAt: capturedAt,
        );
        await dailyReflectionService.saveReflectionForDay(
          candidateDay,
          DailyReflection(energyScore: shouldBeLowEnergy ? 2 : 4),
        );

        occupiedDates.add(date);
        generatedCount++;
        sampleCount++;
        hasLowEnergy = hasLowEnergy || shouldBeLowEnergy;
        hasHigherEnergy = hasHigherEnergy || !shouldBeLowEnergy;
      }

      candidateDay = candidateDay.subtract(const Duration(days: 1));
    }

    final updateResult = await modelUpdateService.updateModelIfReady();
    return DebugPredictionSeedResult(
      generatedSampleCount: generatedCount,
      totalSampleCount: updateResult.sampleCount,
      modelUpdateResult: updateResult,
    );
  }

  Future<DebugPredictionClearResult> clearGeneratedData() async {
    final allSnapshots = await database
        .select(database.dailyFeatureSnapshotItems)
        .get();
    final snapshots = allSnapshots
        .where((row) => row.calendarSnapshotKey.contains(seedMarker))
        .toList(growable: false);
    if (snapshots.isEmpty) {
      return DebugPredictionClearResult(
        removedSampleCount: 0,
        remainingSampleCount: await datasetService.countCompletedSamples(),
      );
    }

    final snapshotIds = snapshots.map((row) => row.id).toList(growable: false);
    final dates = snapshots.map((row) => row.date).toList(growable: false);
    final predictions = await (database.select(
      database.dailyPredictionItems,
    )..where((table) => table.featureSnapshotId.isIn(snapshotIds))).get();
    final predictionIds = predictions
        .map((row) => row.id)
        .toList(growable: false);

    await database.transaction(() async {
      if (predictionIds.isNotEmpty) {
        await (database.delete(
          database.forecastReflectionItems,
        )..where((table) => table.predictionId.isIn(predictionIds))).go();
      }
      await (database.delete(
        database.dailyIntentionItems,
      )..where((table) => table.date.isIn(dates))).go();
      await (database.delete(
        database.dailyReflectionItems,
      )..where((table) => table.date.isIn(dates))).go();
      await (database.delete(
        database.dailyPredictionItems,
      )..where((table) => table.featureSnapshotId.isIn(snapshotIds))).go();
      await (database.delete(
        database.dailyFeatureSnapshotItems,
      )..where((table) => table.id.isIn(snapshotIds))).go();
    });

    final activatedBaseline = await energyModelService
        .activateLatestQuestionnaireBaseline();
    if (!activatedBaseline) {
      throw StateError('No questionnaire baseline is available to restore.');
    }

    final updateResult = await modelUpdateService.updateModelIfReady();
    return DebugPredictionClearResult(
      removedSampleCount: snapshots.length,
      remainingSampleCount: updateResult.sampleCount,
    );
  }

  Future<Set<String>> _loadOccupiedDates() async {
    final snapshots = await database
        .select(database.dailyFeatureSnapshotItems)
        .get();
    final predictions = await database
        .select(database.dailyPredictionItems)
        .get();
    final reflections = await database
        .select(database.dailyReflectionItems)
        .get();
    final intentions = await database
        .select(database.dailyIntentionItems)
        .get();
    final forecastReflections = await database
        .select(database.forecastReflectionItems)
        .get();
    final cachedEvents = await database
        .select(database.cachedCalendarEventItems)
        .get();

    return {
      ...snapshots.map((row) => row.date),
      ...predictions.map((row) => row.date),
      ...reflections.map((row) => row.date),
      ...intentions.map((row) => row.date),
      ...forecastReflections.map((row) => row.date),
      ...cachedEvents.map((row) => row.date),
    };
  }

  List<CalendarEvent> _eventsForDay(
    DateTime day, {
    required bool lowEnergy,
    required int variant,
  }) {
    final specs = lowEnergy
        ? _lowEnergyEventSpecs[variant % _lowEnergyEventSpecs.length]
        : _higherEnergyEventSpecs[variant % _higherEnergyEventSpecs.length];

    return [
      for (var index = 0; index < specs.length; index++)
        CalendarEvent(
          id: '$seedMarker-${dateKey(day)}-$variant-$index',
          externalId: '$seedMarker-${dateKey(day)}-$variant-$index',
          source: CalendarEventSource.manual,
          title: '$seedMarker ${specs[index].title}',
          startTime: DateTime(
            day.year,
            day.month,
            day.day,
            specs[index].startHour,
            specs[index].startMinute,
          ),
          endTime: DateTime(
            day.year,
            day.month,
            day.day,
            specs[index].endHour,
            specs[index].endMinute,
          ),
          category: specs[index].category,
        ),
    ];
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}

class DebugPredictionSeedResult {
  const DebugPredictionSeedResult({
    required this.generatedSampleCount,
    required this.totalSampleCount,
    required this.modelUpdateResult,
  });

  final int generatedSampleCount;
  final int totalSampleCount;
  final ModelUpdateResult modelUpdateResult;
}

class DebugPredictionClearResult {
  const DebugPredictionClearResult({
    required this.removedSampleCount,
    required this.remainingSampleCount,
  });

  final int removedSampleCount;
  final int remainingSampleCount;
}

class _DebugEventSpec {
  const _DebugEventSpec(
    this.title,
    this.startHour,
    this.startMinute,
    this.endHour,
    this.endMinute,
    this.category,
  );

  final String title;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final CalendarEventCategory category;
}

const _lowEnergyEventSpecs = [
  [
    _DebugEventSpec('Focus block', 9, 0, 12, 0, CalendarEventCategory.focus),
    _DebugEventSpec(
      'Admin block',
      12,
      10,
      14,
      0,
      CalendarEventCategory.lifeAdmin,
    ),
    _DebugEventSpec('Study block', 14, 10, 17, 0, CalendarEventCategory.focus),
  ],
  [
    _DebugEventSpec('Focus block', 8, 30, 11, 30, CalendarEventCategory.focus),
    _DebugEventSpec(
      'Social block',
      11,
      35,
      13,
      0,
      CalendarEventCategory.social,
    ),
    _DebugEventSpec(
      'Admin block',
      13,
      10,
      16,
      0,
      CalendarEventCategory.lifeAdmin,
    ),
  ],
  [
    _DebugEventSpec('Study block', 10, 0, 14, 0, CalendarEventCategory.focus),
    _DebugEventSpec('Focus block', 15, 0, 19, 0, CalendarEventCategory.focus),
  ],
];

const _higherEnergyEventSpecs = [
  [
    _DebugEventSpec('Exercise', 9, 0, 10, 0, CalendarEventCategory.exercise),
    _DebugEventSpec('Social time', 15, 0, 16, 0, CalendarEventCategory.social),
  ],
  [
    _DebugEventSpec('Focus time', 10, 0, 11, 0, CalendarEventCategory.focus),
    _DebugEventSpec('Exercise', 14, 0, 15, 0, CalendarEventCategory.exercise),
  ],
  [
    _DebugEventSpec(
      'Life admin',
      9,
      30,
      10,
      30,
      CalendarEventCategory.lifeAdmin,
    ),
    _DebugEventSpec('Social time', 17, 0, 18, 0, CalendarEventCategory.social),
  ],
];
