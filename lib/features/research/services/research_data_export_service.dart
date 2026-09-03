import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_key.dart';
import '../models/research_data_export.dart';
import 'research_engagement_service.dart';

class ResearchDataExportService {
  ResearchDataExportService({
    required this.database,
    String Function()? participantCodeGenerator,
  }) : participantCodeGenerator =
           participantCodeGenerator ?? _generateParticipantCode;

  static const String exportSchemaVersion = 'cal_research_export_v2';

  final AppDatabase database;
  final String Function() participantCodeGenerator;

  Future<ResearchDataExport> createExport() async {
    final setup = await database
        .select(database.initialSetupItems)
        .getSingleOrNull();
    if (setup == null) {
      throw StateError('Complete onboarding before exporting research data.');
    }

    final participantCode = await _loadOrCreateParticipantCode(setup);
    final snapshots = await database
        .select(database.dailyFeatureSnapshotItems)
        .get();
    final predictions = await database
        .select(database.dailyPredictionItems)
        .get();
    final forecastReflections = await database
        .select(database.forecastReflectionItems)
        .get();
    final dailyReflections = await database
        .select(database.dailyReflectionItems)
        .get();
    final intentions = await database
        .select(database.dailyIntentionItems)
        .get();
    final eventResponses = await database
        .select(database.eventUserDataItems)
        .get();
    final manualEventResponses = await database
        .select(database.manualCalendarEventItems)
        .get();
    final modelRows = await database.select(database.energyModelItems).get();
    final interactions = await database
        .select(database.researchInteractionItems)
        .get();

    final dates = <String>{
      ...snapshots.map((row) => row.date),
      ...predictions.map((row) => row.date),
      ...forecastReflections.map((row) => row.date),
      ...dailyReflections.map((row) => row.date),
      ...intentions.map((row) => row.date),
      ...eventResponses
          .where((row) => row.energyImpactScore != null)
          .map((row) => row.date),
      ...manualEventResponses
          .where((row) => row.energyImpactScore != null)
          .map((row) => row.date),
      ...interactions.map((row) => dateKey(row.occurredAt)),
    }.toList()..sort();

    final setupDay = _dateOnly(setup.questionnaireCompletedAt);
    final studyStart = dates.isEmpty
        ? setupDay
        : _earlierDate(setupDay, DateTime.parse(dates.first));
    final snapshotsByDate = {for (final row in snapshots) row.date: row};
    final predictionsByDate = {for (final row in predictions) row.date: row};
    final forecastReflectionsByDate = {
      for (final row in forecastReflections) row.date: row,
    };
    final dailyReflectionsByDate = {
      for (final row in dailyReflections) row.date: row,
    };
    final intentionsByDate = {for (final row in intentions) row.date: row};
    final activityResponsesByDate = _aggregateActivityResponses(
      eventResponses: eventResponses,
      manualEventResponses: manualEventResponses,
    );
    final engagementByDate = _aggregateEngagement(interactions);
    final engagementTotals = _engagementCounts(interactions);

    modelRows.sort((first, second) => first.id.compareTo(second.id));
    final payload = <String, Object?>{
      'export_schema_version': exportSchemaVersion,
      'participant_code': participantCode,
      'questionnaire': _questionnaireJson(setup),
      'engagement': engagementTotals,
      'daily_records': [
        for (final date in dates)
          _dailyRecordJson(
            date: date,
            studyStart: studyStart,
            snapshot: snapshotsByDate[date],
            prediction: predictionsByDate[date],
            forecastReflection: forecastReflectionsByDate[date],
            dailyReflection: dailyReflectionsByDate[date],
            intention: intentionsByDate[date],
            activityResponses: activityResponsesByDate[date] ?? const [],
            engagement: engagementByDate[date] ?? _emptyEngagementCounts(),
          ),
      ],
      'model_history': [
        for (var index = 0; index < modelRows.length; index++)
          _modelJson(
            row: modelRows[index],
            sequence: index + 1,
            studyStart: studyStart,
          ),
      ],
    };
    const encoder = JsonEncoder.withIndent('  ');

    return ResearchDataExport(
      participantCode: participantCode,
      fileName: 'cal_research_$participantCode.json',
      contents: encoder.convert(payload),
    );
  }

  Future<String> _loadOrCreateParticipantCode(InitialSetupItem setup) async {
    final existingCode = setup.researchParticipantCode;
    if (existingCode != null && existingCode.isNotEmpty) return existingCode;

    final code = participantCodeGenerator();
    await (database.update(
      database.initialSetupItems,
    )..where((table) => table.id.equals(setup.id))).write(
      InitialSetupItemsCompanion(
        researchParticipantCode: Value(code),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return code;
  }

  Map<String, Object?> _questionnaireJson(InitialSetupItem row) {
    return {
      'version': row.questionnaireVersion,
      'typical_energy_score': row.typicalEnergyScore,
      'total_scheduled_time_impact_score': row.busyImpactScore,
      'back_to_back_impact_score': row.backToBackImpactScore,
      'long_block_impact_score': row.longBlockImpactScore,
      'gap_between_activities_impact_score': row.freeGapImpactScore,
      'focus_impact_score': row.focusImpactScore,
      'social_impact_score': row.socialImpactScore,
      'life_admin_impact_score': row.lifeAdminImpactScore,
      'exercise_impact_score': row.exerciseImpactScore,
      'calendar_understanding_score': row.calendarUnderstandingScore,
      'schedule_prediction_confidence_score':
          row.schedulePredictionConfidenceScore,
    };
  }

  Map<String, Object?> _dailyRecordJson({
    required String date,
    required DateTime studyStart,
    required DailyFeatureSnapshotItem? snapshot,
    required DailyPredictionItem? prediction,
    required ForecastReflectionItem? forecastReflection,
    required DailyReflectionItem? dailyReflection,
    required DailyIntentionItem? intention,
    required List<Map<String, Object?>> activityResponses,
    required Map<String, int> engagement,
  }) {
    final day = DateTime.parse(date);
    final studyDay = day.difference(studyStart).inDays + 1;

    // export derived calendar measures and relative study timing without event
    // titles, external identifiers, or exact activity times
    return {
      'study_day': studyDay,
      'study_cycle': ((studyDay - 1) ~/ 7) + 1,
      'cycle_day': ((studyDay - 1) % 7) + 1,
      'engagement': engagement,
      'feature_snapshot': snapshot == null
          ? null
          : {
              'captured_minute_of_day':
                  snapshot.capturedAt.hour * 60 + snapshot.capturedAt.minute,
              'analysis_start_hour': snapshot.analysisStartHour,
              'analysis_end_hour': snapshot.analysisEndHour,
              'prediction_phase': snapshot.predictionPhase,
              'calculation_version': snapshot.calculationVersion,
              'features': {
                'total_event_count': snapshot.totalEventCount,
                'all_day_event_count': snapshot.allDayEventCount,
                'total_scheduled_minutes': snapshot.totalScheduledMinutes,
                'busy_minutes': snapshot.busyMinutes,
                'focus_minutes': snapshot.focusMinutes,
                'social_minutes': snapshot.socialMinutes,
                'life_admin_minutes': snapshot.lifeAdminMinutes,
                'exercise_minutes': snapshot.exerciseMinutes,
                'rest_minutes': snapshot.restMinutes,
                'back_to_back_event_count': snapshot.backToBackEventCount,
                'free_minutes': snapshot.freeMinutes,
                'longest_gap_between_activities_minutes':
                    snapshot.longestGapBetweenActivitiesMinutes,
                'max_consecutive_block_minutes':
                    snapshot.maxConsecutiveBlockMinutes,
              },
            },
      'prediction': prediction == null
          ? null
          : {
              'predicted_category': prediction.predictedCategory,
              'low_energy_likelihood': prediction.predictedScore,
              'prediction_version': prediction.predictionVersion,
              'agreement_score': prediction.agreementScore,
            },
      'forecast_reflection': forecastReflection == null
          ? null
          : {
              'expected_increase_factor_type':
                  forecastReflection.supportiveFactorType,
              'expected_decrease_factor_type':
                  forecastReflection.demandingFactorType,
              'cal_increase_factor_type':
                  forecastReflection.modelSupportiveFactorType,
              'cal_decrease_factor_type':
                  forecastReflection.modelDemandingFactorType,
            },
      'daily_reflection': dailyReflection == null
          ? null
          : {
              'energy_score': dailyReflection.energyScore,
              'low_energy_label': dailyReflection.energyScore <= 2 ? 1 : 0,
              'intention_completion_score':
                  dailyReflection.intentionCompletionScore,
              'intention_energy_change_score':
                  dailyReflection.intentionHelpfulnessScore,
            },
      'intention': intention == null
          ? null
          : {
              'factor_type': intention.factorType,
              'adjustment_type': intention.adjustmentType,
              'has_scheduled_time': intention.adjustmentStartTime != null,
              'scheduled_duration_minutes':
                  intention.adjustmentStartTime != null &&
                      intention.adjustmentEndTime != null
                  ? intention.adjustmentEndTime!
                        .difference(intention.adjustmentStartTime!)
                        .inMinutes
                  : null,
            },
      'activity_energy_responses': activityResponses,
    };
  }

  Map<String, Object?> _modelJson({
    required EnergyModelItem row,
    required int sequence,
    required DateTime studyStart,
  }) {
    final createdDay = _dateOnly(row.createdAt);
    return {
      'sequence': sequence,
      'study_day': createdDay.difference(studyStart).inDays + 1,
      'model_version': row.modelVersion,
      'model_source': row.modelSource,
      'feature_version': row.featureVersion,
      'target_version': row.targetVersion,
      'intercept': row.intercept,
      'coefficients': jsonDecode(row.coefficientsJson),
      'is_active': row.isActive,
    };
  }

  Map<String, List<Map<String, Object?>>> _aggregateActivityResponses({
    required List<EventUserDataItem> eventResponses,
    required List<ManualCalendarEventItem> manualEventResponses,
  }) {
    final aggregates = <String, Map<String, _ActivityResponseCounts>>{};

    void addResponse(String date, String? category, int? score) {
      if (category == null || score == null) return;
      final byCategory = aggregates.putIfAbsent(date, () => {});
      final counts = byCategory.putIfAbsent(
        category,
        _ActivityResponseCounts.new,
      );
      counts.add(score);
    }

    for (final row in eventResponses) {
      addResponse(row.date, row.category, row.energyImpactScore);
    }
    for (final row in manualEventResponses) {
      addResponse(row.date, row.category, row.energyImpactScore);
    }

    return {
      for (final entry in aggregates.entries)
        entry.key:
            (entry.value.entries.toList()
                  ..sort((first, second) => first.key.compareTo(second.key)))
                .map(
                  (category) => {
                    'category': category.key,
                    'reflection_count': category.value.total,
                    'decreased_count': category.value.decreased,
                    'unchanged_count': category.value.unchanged,
                    'increased_count': category.value.increased,
                  },
                )
                .toList(),
    };
  }

  Map<String, Map<String, int>> _aggregateEngagement(
    List<ResearchInteractionItem> interactions,
  ) {
    final aggregates = <String, List<ResearchInteractionItem>>{};
    for (final interaction in interactions) {
      aggregates
          .putIfAbsent(dateKey(interaction.occurredAt), () => [])
          .add(interaction);
    }

    return {
      for (final entry in aggregates.entries)
        entry.key: _engagementCounts(entry.value),
    };
  }

  Map<String, int> _engagementCounts(
    Iterable<ResearchInteractionItem> interactions,
  ) {
    var forecastViewed = 0;
    var weeklyInsightsViewed = 0;

    for (final interaction in interactions) {
      switch (interaction.eventType) {
        case ResearchEngagementEventType.forecastViewed:
          forecastViewed++;
        case ResearchEngagementEventType.weeklyInsightsViewed:
          weeklyInsightsViewed++;
      }
    }

    return {
      'forecast_viewed': forecastViewed,
      'weekly_insights_viewed': weeklyInsightsViewed,
    };
  }

  Map<String, int> _emptyEngagementCounts() => {
    'forecast_viewed': 0,
    'weekly_insights_viewed': 0,
  };

  DateTime _earlierDate(DateTime first, DateTime second) {
    return first.isBefore(second) ? first : second;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static String _generateParticipantCode() {
    final random = Random.secure();
    final code = List.generate(
      6,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join().toUpperCase();
    return 'CAL-$code';
  }
}

class _ActivityResponseCounts {
  int decreased = 0;
  int unchanged = 0;
  int increased = 0;

  int get total => decreased + unchanged + increased;

  void add(int score) {
    switch (score) {
      case 1:
        decreased++;
      case 2:
        unchanged++;
      case 3:
        increased++;
    }
  }
}
