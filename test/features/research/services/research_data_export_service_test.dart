import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/research/services/research_data_export_service.dart';
import 'package:calendar_app/features/research/services/research_engagement_service.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('exports research data', () async {
    await _insertQuestionnaire(database);
    final snapshotId = await _insertSnapshot(database);
    final predictionId = await _insertPrediction(database, snapshotId);
    await _insertForecastReflection(database, predictionId);
    await _insertDailyReflection(database);
    await _insertIntention(database);
    await _insertActivityResponses(database);
    await _insertModel(database);
    await _insertEngagement(database);

    final service = ResearchDataExportService(
      database: database,
      participantCodeGenerator: () => 'CAL-TEST000001',
    );
    final firstExport = await service.createExport();
    final secondExport = await service.createExport();
    final json = jsonDecode(firstExport.contents) as Map<String, dynamic>;
    final dailyRecord =
        (json['daily_records'] as List<dynamic>).single as Map<String, dynamic>;

    expect(firstExport.participantCode, 'CAL-TEST000001');
    expect(secondExport.participantCode, firstExport.participantCode);
    expect(firstExport.fileName, 'cal_research_CAL-TEST000001.json');
    expect(json['export_schema_version'], 'cal_research_export_v2');
    expect(json['engagement'], {
      'forecast_viewed': 2,
      'weekly_insights_viewed': 1,
    });
    expect(dailyRecord['engagement'], {
      'forecast_viewed': 2,
      'weekly_insights_viewed': 1,
    });
    expect(dailyRecord['study_day'], 2);
    expect(dailyRecord['cycle_day'], 2);
    expect(
      (dailyRecord['feature_snapshot']
          as Map<String, dynamic>)['captured_minute_of_day'],
      570,
    );
    expect(
      ((dailyRecord['feature_snapshot'] as Map<String, dynamic>)['features']
          as Map<String, dynamic>)['focus_minutes'],
      60,
    );
    expect(
      (dailyRecord['daily_reflection']
          as Map<String, dynamic>)['low_energy_label'],
      1,
    );
    expect(
      dailyRecord['activity_energy_responses'],
      containsAll([
        {
          'category': 'exercise',
          'reflection_count': 1,
          'decreased_count': 0,
          'unchanged_count': 0,
          'increased_count': 1,
        },
        {
          'category': 'focus',
          'reflection_count': 1,
          'decreased_count': 1,
          'unchanged_count': 0,
          'increased_count': 0,
        },
      ]),
    );

    expect(firstExport.contents, isNot(contains('2026-07-21')));
    expect(firstExport.contents, isNot(contains('Private event title')));
    expect(firstExport.contents, isNot(contains('private-google-event-id')));
    expect(firstExport.contents, isNot(contains('Private adjustment text')));
    expect(firstExport.contents, isNot(contains('Private factor label')));
  });
}

Future<void> _insertQuestionnaire(AppDatabase database) {
  return database
      .into(database.initialSetupItems)
      .insert(
        InitialSetupItemsCompanion.insert(
          id: const Value(1),
          questionnaireVersion: 'energy_onboarding_v1',
          typicalEnergyScore: 3,
          busyImpactScore: 5,
          backToBackImpactScore: 4,
          longBlockImpactScore: 4,
          freeGapImpactScore: 2,
          focusImpactScore: 5,
          socialImpactScore: 3,
          lifeAdminImpactScore: 4,
          exerciseImpactScore: 1,
          calendarUnderstandingScore: 3,
          schedulePredictionConfidenceScore: 2,
          questionnaireCompletedAt: DateTime(2026, 7, 20, 18),
        ),
      );
}

Future<int> _insertSnapshot(AppDatabase database) async {
  return database
      .into(database.dailyFeatureSnapshotItems)
      .insert(
        DailyFeatureSnapshotItemsCompanion.insert(
          date: '2026-07-21',
          capturedAt: DateTime(2026, 7, 21, 9, 30),
          analysisStartHour: 8,
          analysisEndHour: 22,
          predictionPhase: 'initial',
          calculationVersion: 2,
          calendarSnapshotKey: 'private-calendar-snapshot',
          totalEventCount: 2,
          allDayEventCount: 0,
          totalScheduledMinutes: 120,
          busyMinutes: 120,
          focusMinutes: 60,
          socialMinutes: 0,
          lifeAdminMinutes: 0,
          exerciseMinutes: 60,
          restMinutes: 0,
          backToBackEventCount: 1,
          freeMinutes: 720,
          longestGapBetweenActivitiesMinutes: 60,
          maxConsecutiveBlockMinutes: 120,
        ),
      );
}

Future<int> _insertPrediction(AppDatabase database, int snapshotId) {
  return database
      .into(database.dailyPredictionItems)
      .insert(
        DailyPredictionItemsCompanion.insert(
          date: '2026-07-21',
          featureSnapshotId: snapshotId,
          predictedCategory: 'lower_energy',
          predictedScore: const Value(0.72),
          predictionVersion: 'questionnaire-baseline-v2',
          agreementScore: const Value(2),
        ),
      );
}

Future<void> _insertForecastReflection(AppDatabase database, int predictionId) {
  return database
      .into(database.forecastReflectionItems)
      .insert(
        ForecastReflectionItemsCompanion.insert(
          date: '2026-07-21',
          predictionId: predictionId,
          supportiveFactorType: 'exercise',
          supportiveFactorLabel: 'Private factor label',
          demandingFactorType: 'focusTime',
          demandingFactorLabel: 'Private demanding label',
          modelSupportiveFactorType: const Value('longestGapBetweenActivities'),
          modelSupportiveFactorLabel: const Value('Private model label'),
          modelDemandingFactorType: const Value('scheduledTime'),
          modelDemandingFactorLabel: const Value('Private model label'),
          revealedAt: DateTime(2026, 7, 21, 9, 35),
        ),
      );
}

Future<void> _insertDailyReflection(AppDatabase database) {
  return database
      .into(database.dailyReflectionItems)
      .insert(
        DailyReflectionItemsCompanion.insert(
          date: '2026-07-21',
          energyScore: 2,
          intentionCompletionScore: const Value(3),
          intentionHelpfulnessScore: const Value(3),
        ),
      );
}

Future<void> _insertIntention(AppDatabase database) {
  return database
      .into(database.dailyIntentionItems)
      .insert(
        DailyIntentionItemsCompanion.insert(
          date: '2026-07-21',
          selectedFactor: 'Private factor label',
          factorType: const Value('focusTime'),
          selectedAdjustment: 'Private adjustment text',
          adjustmentType: const Value('quietPause'),
          adjustmentStartTime: Value(DateTime(2026, 7, 21, 15)),
          adjustmentEndTime: Value(DateTime(2026, 7, 21, 15, 10)),
          calendarSnapshotKey: const Value('private-calendar-snapshot'),
        ),
      );
}

Future<void> _insertActivityResponses(AppDatabase database) async {
  await database
      .into(database.eventUserDataItems)
      .insert(
        EventUserDataItemsCompanion.insert(
          eventKey: 'private-event-key',
          source: 'google',
          externalId: const Value('private-google-event-id'),
          date: '2026-07-21',
          category: const Value('focus'),
          energyImpactScore: const Value(1),
        ),
      );
  await database
      .into(database.manualCalendarEventItems)
      .insert(
        ManualCalendarEventItemsCompanion.insert(
          date: '2026-07-21',
          title: 'Private event title',
          startTime: DateTime(2026, 7, 21, 15),
          endTime: DateTime(2026, 7, 21, 16),
          category: 'exercise',
          energyImpactScore: const Value(3),
        ),
      );
}

Future<void> _insertModel(AppDatabase database) {
  return database
      .into(database.energyModelItems)
      .insert(
        EnergyModelItemsCompanion.insert(
          modelVersion: 'questionnaire-baseline-v2',
          modelSource: 'questionnaire_baseline',
          featureVersion: 'calendar_energy_v2',
          targetVersion: 'binary_low_energy_v1',
          intercept: 0.1,
          coefficientsJson: '{"busy_minutes":0.3,"focus_minutes":0.5}',
          createdAt: Value(DateTime(2026, 7, 20, 18)),
          updatedAt: Value(DateTime(2026, 7, 20, 18)),
        ),
      );
}

Future<void> _insertEngagement(AppDatabase database) async {
  final service = ResearchEngagementService(
    database: database,
    now: () => DateTime(2026, 7, 21, 10),
  );
  await service.recordForecastViewed();
  await service.recordForecastViewed();
  await service.recordWeeklyInsightsViewed();
}
