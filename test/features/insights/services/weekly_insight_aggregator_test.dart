import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/core/database/app_database.dart';
import 'package:calendar_app/features/check_in/models/daily_reflection.dart';
import 'package:calendar_app/features/check_in/services/daily_reflection_service.dart';
import 'package:calendar_app/features/insights/models/weekly_insight_aggregate.dart';
import 'package:calendar_app/features/insights/models/weekly_insight_summary.dart';
import 'package:calendar_app/features/insights/services/weekly_insight_aggregator.dart';
import 'package:calendar_app/features/insights/services/weekly_insight_service.dart';
import 'package:calendar_app/features/forecast/models/daily_intention.dart';
import 'package:calendar_app/features/forecast/services/daily_intention_service.dart';
import 'package:calendar_app/features/forecast/services/forecast_reflection_service.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/models/logistic_model_parameters.dart';
import 'package:calendar_app/features/prediction/services/daily_prediction_record_service.dart';
import 'package:calendar_app/features/prediction/services/energy_model_service.dart';

void main() {
  test('finds weekly pattern', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final reflectionService = DailyReflectionService(database: database);
    final aggregator = WeeklyInsightAggregator(database: database);
    addTearDown(database.close);

    final days = [
      DateTime(2026, 7, 13),
      DateTime(2026, 7, 14),
      DateTime(2026, 7, 15),
      DateTime(2026, 7, 16),
    ];
    final focusMinutes = [20, 200, 40, 180];
    final energyScores = [5, 1, 4, 2];

    for (var index = 0; index < days.length; index++) {
      await reflectionService.saveReflectionForDay(
        days[index],
        DailyReflection(energyScore: energyScores[index]),
      );
      await _insertSnapshot(
        database,
        days[index],
        focusMinutes: focusMinutes[index],
      );
    }

    final aggregate = await aggregator.loadForWeek(DateTime(2026, 7, 13));

    expect(aggregate.calendarSampleCount, 4);
    expect(
      aggregate.strongestCalendarPattern?.feature,
      EnergyModelFeature.focusMinutes,
    );
    expect(
      aggregate.strongestCalendarPattern?.direction,
      WeeklyPatternDirection.lowerEnergy,
    );

    final summary = await WeeklyInsightService(
      database: database,
    ).loadSummaryForWeek(DateTime(2026, 7, 13));
    expect(
      summary.sections[0].body,
      'Across the 4 days you reflected on, more time in focused activities '
      'appeared '
      'alongside lower reported energy.',
    );
    expect(
      summary.sections[0].subtitle,
      'Based on your calendar and Daily Reflections',
    );
    expect(
      summary.sections[0].bodyParts
          .where((part) => part.isEmphasised)
          .map((part) => part.text),
      [
        '4 days you reflected on',
        'more time in focused activities',
        'lower reported energy',
      ],
    );
  });

  test('groups energy responses', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final aggregator = WeeklyInsightAggregator(database: database);
    addTearDown(database.close);

    await _insertEventResponse(
      database,
      eventKey: 'focus-1',
      category: 'focus',
      impactScore: 1,
    );
    await _insertEventResponse(
      database,
      eventKey: 'focus-2',
      category: 'focus',
      impactScore: 1,
    );
    await _insertEventResponse(
      database,
      eventKey: 'focus-3',
      category: 'focus',
      impactScore: 2,
    );
    await _insertEventResponse(
      database,
      eventKey: 'exercise-1',
      category: 'exercise',
      impactScore: 3,
    );
    await _insertEventResponse(
      database,
      eventKey: 'unsure-1',
      category: 'notSure',
      impactScore: 3,
    );

    final aggregate = await aggregator.loadForWeek(DateTime(2026, 7, 13));

    expect(aggregate.activitySummaries, hasLength(2));
    final focus = aggregate.activitySummaries.first;
    expect(focus.category, 'focus');
    expect(focus.totalCount, 3);
    expect(focus.decreasedCount, 2);
    expect(focus.unchangedCount, 1);
    expect(focus.increasedCount, 0);

    final summary = await WeeklyInsightService(
      database: database,
    ).loadSummaryForWeek(DateTime(2026, 7, 13));
    expect(summary.activityEnergySummaries, hasLength(2));
    expect(summary.activityEnergySummaries.first.category, 'focus');
    expect(summary.activityEnergySummaries.first.decreasedCount, 2);
    expect(summary.activityEnergySummaries.first.unchangedCount, 1);
    expect(summary.activityEnergySummaries.first.increasedCount, 0);
    expect(summary.activityEnergySummaries.last.category, 'exercise');
    expect(summary.activityEnergySummaries.last.increasedCount, 1);
  });

  test('includes manual responses', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final aggregator = WeeklyInsightAggregator(database: database);
    addTearDown(database.close);

    await _insertEventResponse(
      database,
      eventKey: 'google-focus',
      category: 'focus',
      impactScore: 1,
    );
    await _insertManualEventResponse(
      database,
      title: 'Manual focus session',
      category: 'focus',
      impactScore: 3,
    );
    await _insertManualEventResponse(
      database,
      title: 'Manual social event',
      category: 'social',
      impactScore: 2,
    );

    final aggregate = await aggregator.loadForWeek(DateTime(2026, 7, 13));

    expect(aggregate.activitySummaries, hasLength(2));
    final focus = aggregate.activitySummaries.firstWhere(
      (summary) => summary.category == 'focus',
    );
    expect(focus.totalCount, 2);
    expect(focus.decreasedCount, 1);
    expect(focus.unchangedCount, 0);
    expect(focus.increasedCount, 1);

    final social = aggregate.activitySummaries.firstWhere(
      (summary) => summary.category == 'social',
    );
    expect(social.totalCount, 1);
    expect(social.unchangedCount, 1);
  });

  test('shows model readiness', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final modelService = EnergyModelService(database: database);
    addTearDown(database.close);

    await modelService.saveActiveModel(
      parameters: const LogisticModelParameters(
        featureVersion: EnergyModelContract.featureVersion,
        targetVersion: EnergyModelContract.targetVersion,
        modelVersion: 'questionnaire-baseline-v2',
        intercept: 0,
        coefficients: {
          EnergyModelFeature.focusMinutes: 0.8,
          EnergyModelFeature.exerciseMinutes: -0.6,
        },
      ),
      modelSource: EnergyModelSource.questionnaireBaseline,
    );

    final summary = await WeeklyInsightService(
      database: database,
    ).loadSummaryForWeek(DateTime(2026, 7, 13));
    final modelSection = summary.sections.last;

    expect(modelSection.title, 'What Cal has learned over time');
    expect(modelSection.isLocked, isTrue);
    expect(
      modelSection.body,
      'Keep completing reflections to help Cal learn your patterns.',
    );
    expect(modelSection.modelLearningProgress?.completedSampleCount, 0);
    expect(modelSection.modelLearningProgress?.hasLowerEnergySample, isFalse);
    expect(modelSection.modelLearningProgress?.hasHigherEnergySample, isFalse);
    expect(modelSection.body, isNot(contains('focused activity time')));
    expect(modelSection.body, isNot(contains('exercise time')));
  });

  test('summarises weekly data', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final reflectionService = DailyReflectionService(database: database);
    final intentionService = DailyIntentionService(database: database);
    final forecastService = ForecastReflectionService(database: database);
    final predictionService = DailyPredictionRecordService(database: database);
    final modelService = EnergyModelService(database: database);
    final aggregator = WeeklyInsightAggregator(database: database);
    addTearDown(database.close);
    final firstDay = DateTime(2026, 7, 13);
    final secondDay = DateTime(2026, 7, 14);

    final firstPredictionId = await _createPrediction(
      database,
      predictionService,
      firstDay,
    );
    final secondPredictionId = await _createPrediction(
      database,
      predictionService,
      secondDay,
    );
    await predictionService.saveAgreementForDay(firstDay, 2);
    await predictionService.saveAgreementForDay(secondDay, 1);

    await forecastService.saveReflectionForDay(
      day: firstDay,
      predictionId: firstPredictionId,
      supportiveFactor: const ForecastFactor(
        type: ForecastFactorType.exercise,
        label: 'Exercise',
      ),
      demandingFactor: const ForecastFactor(
        type: ForecastFactorType.focusTime,
        label: 'Focused activities',
      ),
      modelSupportiveFactor: const ForecastFactor(
        type: ForecastFactorType.exercise,
        label: 'Exercise',
      ),
      modelDemandingFactor: const ForecastFactor(
        type: ForecastFactorType.scheduledTime,
        label: 'Scheduled time',
      ),
    );
    await forecastService.saveReflectionForDay(
      day: secondDay,
      predictionId: secondPredictionId,
      supportiveFactor: const ForecastFactor(
        type: ForecastFactorType.focusTime,
        label: 'Focused activities',
      ),
      demandingFactor: const ForecastFactor(
        type: ForecastFactorType.exercise,
        label: 'Exercise',
      ),
      modelSupportiveFactor: const ForecastFactor(
        type: ForecastFactorType.exercise,
        label: 'Exercise',
      ),
      modelDemandingFactor: const ForecastFactor(
        type: ForecastFactorType.focusTime,
        label: 'Focused activities',
      ),
    );

    for (final day in [firstDay, secondDay]) {
      await intentionService.saveIntentionForDay(
        day,
        const DailyIntention(
          factor: ForecastFactor(
            type: ForecastFactorType.focusTime,
            label: 'Focused activities',
          ),
          adjustment: DailyAdjustment(
            type: DailyAdjustmentType.quietPause,
            label: 'Take a quiet pause',
          ),
          calendarSnapshotKey: 'snapshot',
        ),
      );
    }
    await reflectionService.saveReflectionForDay(
      firstDay,
      const DailyReflection(
        energyScore: 2,
        intentionCompletionScore: 3,
        intentionHelpfulnessScore: 3,
      ),
    );
    await reflectionService.saveReflectionForDay(
      secondDay,
      const DailyReflection(
        energyScore: 3,
        intentionCompletionScore: 2,
        intentionHelpfulnessScore: 2,
      ),
    );
    await reflectionService.saveReflectionForDay(
      DateTime(2026, 7, 6),
      const DailyReflection(energyScore: 1),
    );
    await reflectionService.saveReflectionForDay(
      DateTime(2026, 7, 7),
      const DailyReflection(energyScore: 2),
    );
    await modelService.saveActiveModel(
      parameters: const LogisticModelParameters(
        featureVersion: EnergyModelContract.featureVersion,
        targetVersion: EnergyModelContract.targetVersion,
        modelVersion: 'personalised-logistic-v2',
        intercept: 0,
        coefficients: {
          EnergyModelFeature.focusMinutes: 0.8,
          EnergyModelFeature.exerciseMinutes: -0.6,
        },
      ),
      modelSource: EnergyModelSource.personalisedLogistic,
      savedAt: DateTime(2026, 7, 16, 20),
    );

    final aggregate = await aggregator.loadForWeek(DateTime(2026, 7, 13));

    expect(aggregate.forecastSummary.partlyOrFullyAgreedCount, 2);
    expect(
      aggregate.forecastSummary.mostFrequentUserDemandingFactor?.factorType,
      'exercise',
    );
    expect(aggregate.forecastSummary.mostFrequentUserDemandingFactor?.count, 1);
    expect(
      aggregate.forecastSummary.mostFrequentModelDemandingFactor?.factorType,
      'focusTime',
    );
    expect(
      aggregate.forecastSummary.mostFrequentUserSupportiveFactor?.factorType,
      'exercise',
    );
    expect(
      aggregate.forecastSummary.mostFrequentModelSupportiveFactor?.factorType,
      'exercise',
    );
    expect(
      aggregate.forecastSummary.mostFrequentModelSupportiveFactor?.count,
      2,
    );
    expect(
      aggregate.forecastSummary.mostFrequentSharedMatch?.factorType,
      'exercise',
    );
    expect(
      aggregate.forecastSummary.mostFrequentSharedMatch?.direction,
      WeeklyForecastFactorDirection.increase,
    );
    expect(
      aggregate.forecastSummary.mostFrequentDifference?.userFactorType,
      'exercise',
    );
    expect(
      aggregate.forecastSummary.mostFrequentDifference?.userDirection,
      WeeklyForecastFactorDirection.decrease,
    );
    expect(
      aggregate.forecastSummary.mostFrequentDifference?.modelFactorType,
      'exercise',
    );
    expect(
      aggregate.forecastSummary.mostFrequentDifference?.modelDirection,
      WeeklyForecastFactorDirection.increase,
    );
    expect(aggregate.intentionSummaries.first.adjustmentType, 'quietPause');
    expect(aggregate.intentionSummaries.first.setCount, 2);
    expect(aggregate.intentionSummaries.first.partlyOrFullyCompletedCount, 2);
    expect(aggregate.intentionSummaries.first.increasedCount, 1);
    expect(aggregate.intentionSummaries.first.unchangedCount, 1);
    expect(aggregate.previousReflectionCount, 2);
    expect(aggregate.previousEnergyTotal, 3);
    expect(aggregate.modelSummary?.completedSampleCount, 2);
    expect(
      aggregate.modelSummary?.strongestLowerEnergyFeature,
      EnergyModelFeature.focusMinutes,
    );
    expect(
      aggregate.modelSummary?.strongestHigherEnergyFeature,
      EnergyModelFeature.exerciseMinutes,
    );

    final summary = await WeeklyInsightService(
      database: database,
    ).loadSummaryForWeek(DateTime(2026, 7, 13));
    expect(summary.forecastComparison.comparedDayCount, 2);
    expect(summary.forecastComparison.similarDayCount, 2);
    expect(
      summary.forecastComparison.mostFrequentSharedFactor,
      'Exercise time',
    );
    expect(
      summary.forecastComparison.sharedFactorEffect,
      WeeklyForecastFactorEffect.increase,
    );
    expect(
      summary.forecastComparison.userLowerEnergySignal?.label,
      'Exercise time',
    );
    expect(summary.forecastComparison.userLowerEnergySignal?.dayCount, 1);
    expect(
      summary.forecastComparison.modelLowerEnergySignal?.label,
      'Focused activities',
    );
    expect(
      summary.forecastComparison.userHigherEnergySignal?.label,
      'Exercise time',
    );
    expect(
      summary.forecastComparison.modelHigherEnergySignal?.label,
      'Exercise time',
    );
    expect(summary.forecastComparison.modelHigherEnergySignal?.dayCount, 2);
    expect(
      summary.forecastComparison.biggestDifference?.userFactor,
      'Exercise time',
    );
    expect(
      summary.forecastComparison.biggestDifference?.userEffect,
      WeeklyForecastFactorEffect.decrease,
    );
    expect(
      summary.forecastComparison.biggestDifference?.modelFactor,
      'Exercise time',
    );
    expect(
      summary.forecastComparison.biggestDifference?.modelEffect,
      WeeklyForecastFactorEffect.increase,
    );
    expect(summary.intentionSummaries, hasLength(1));
    expect(summary.intentionSummaries.first.setCount, 2);
    expect(summary.intentionSummaries.first.completedCount, 2);
    expect(summary.intentionSummaries.first.increasedCount, 1);
    expect(summary.intentionSummaries.first.unchangedCount, 1);
    expect(summary.averageEnergy, 2.5);
    expect(summary.previousAverageEnergy, 1.5);
    expect(summary.sections[2].title, 'What Cal has learned over time');
    expect(
      summary.sections[2].personalisedModelInsight?.lowerEnergySignal?.label,
      'Focused activities',
    );
    expect(
      summary
          .sections[2]
          .personalisedModelInsight
          ?.lowerEnergySignal
          ?.description,
      'More time in focused activities tends to point towards lower energy.',
    );
    expect(
      summary.sections[2].personalisedModelInsight?.higherEnergySignal?.label,
      'Exercise time',
    );
    expect(
      summary
          .sections[2]
          .personalisedModelInsight
          ?.higherEnergySignal
          ?.description,
      'More exercise time tends to point towards higher energy.',
    );
  });
}

Future<int> _createPrediction(
  AppDatabase database,
  DailyPredictionRecordService predictionService,
  DateTime day,
) async {
  await _insertSnapshot(database, day, focusMinutes: 60);
  final snapshot = await (database.select(
    database.dailyFeatureSnapshotItems,
  )..where((table) => table.date.equals(_dateKey(day)))).getSingle();
  await predictionService.createInitialPredictionIfAbsent(
    day: day,
    featureSnapshotId: snapshot.id,
    predictedCategory: 'sufficient',
    predictedScore: 0.4,
    reasons: const [],
    predictionVersion: 'questionnaire-baseline-v2',
  );
  final prediction = await predictionService.loadInitialPredictionForDay(day);
  return prediction!.id;
}

Future<void> _insertSnapshot(
  AppDatabase database,
  DateTime day, {
  required int focusMinutes,
}) {
  final date = _dateKey(day);
  return database
      .into(database.dailyFeatureSnapshotItems)
      .insert(
        DailyFeatureSnapshotItemsCompanion.insert(
          date: date,
          capturedAt: day.add(const Duration(hours: 8)),
          analysisStartHour: 8,
          analysisEndHour: 22,
          predictionPhase: 'initial',
          calculationVersion: 2,
          calendarSnapshotKey: 'snapshot-$date',
          totalEventCount: 1,
          allDayEventCount: 0,
          totalScheduledMinutes: focusMinutes,
          busyMinutes: 120,
          focusMinutes: focusMinutes,
          socialMinutes: 0,
          lifeAdminMinutes: 0,
          exerciseMinutes: 0,
          restMinutes: 0,
          backToBackEventCount: 0,
          freeMinutes: 720,
          longestGapBetweenActivitiesMinutes: 0,
          maxConsecutiveBlockMinutes: 60,
          createdAt: Value(day),
          updatedAt: Value(day),
        ),
      );
}

Future<void> _insertEventResponse(
  AppDatabase database, {
  required String eventKey,
  required String category,
  required int impactScore,
}) {
  return database
      .into(database.eventUserDataItems)
      .insert(
        EventUserDataItemsCompanion.insert(
          eventKey: eventKey,
          source: 'google',
          date: '2026-07-14',
          category: Value(category),
          energyImpactScore: Value(impactScore),
        ),
      );
}

Future<void> _insertManualEventResponse(
  AppDatabase database, {
  required String title,
  required String category,
  required int impactScore,
}) {
  final startTime = DateTime(2026, 7, 14, 12);
  return database
      .into(database.manualCalendarEventItems)
      .insert(
        ManualCalendarEventItemsCompanion.insert(
          date: '2026-07-14',
          title: title,
          startTime: startTime,
          endTime: startTime.add(const Duration(hours: 1)),
          category: category,
          energyImpactScore: Value(impactScore),
        ),
      );
}

String _dateKey(DateTime day) {
  final year = day.year.toString().padLeft(4, '0');
  final month = day.month.toString().padLeft(2, '0');
  final date = day.day.toString().padLeft(2, '0');
  return '$year-$month-$date';
}
