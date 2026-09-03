import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// save the user's category and perceived energy impact for an event
class EventUserDataItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventKey => text().unique()();
  TextColumn get source => text()();
  TextColumn get externalId => text().nullable()();
  TextColumn get date => text()();
  TextColumn get category => text().nullable()();
  IntColumn get energyImpactScore => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// save the events that were loaded last time so Today won't be empty after reopen
class CachedCalendarEventItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventKey => text().unique()();
  TextColumn get source => text()();
  TextColumn get externalId => text().nullable()();
  TextColumn get date => text()();
  TextColumn get title => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get category => text().nullable()();
  IntColumn get energyImpactScore => integer().nullable()();
  BoolColumn get isAllDay => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// save activities created directly in Cal, separately from synced calendars
class ManualCalendarEventItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get title => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get category => text()();
  IntColumn get energyImpactScore => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// save the user's daily energy level
class DailyReflectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()();
  IntColumn get energyScore => integer()();
  IntColumn get intentionCompletionScore => integer().nullable()();
  IntColumn get intentionHelpfulnessScore => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// save the user's planned adjustment for the day
class DailyIntentionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()();
  TextColumn get selectedFactor => text()();
  TextColumn get factorType =>
      text().withDefault(const Constant('unspecified'))();
  TextColumn get selectedAdjustment => text()();
  TextColumn get adjustmentType =>
      text().withDefault(const Constant('unspecified'))();
  DateTimeColumn get adjustmentStartTime => dateTime().nullable()();
  DateTimeColumn get adjustmentEndTime => dateTime().nullable()();
  TextColumn get calendarSnapshotKey =>
      text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// store daily calendar statistics
class DailyFeatureSnapshotItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()();
  DateTimeColumn get capturedAt => dateTime()();
  IntColumn get analysisStartHour => integer()();
  IntColumn get analysisEndHour => integer()();
  TextColumn get predictionPhase => text()();
  IntColumn get calculationVersion => integer()();
  TextColumn get calendarSnapshotKey => text()();
  IntColumn get totalEventCount => integer()();
  IntColumn get allDayEventCount => integer()();
  IntColumn get totalScheduledMinutes => integer()();
  IntColumn get busyMinutes => integer()();
  IntColumn get focusMinutes => integer()();
  IntColumn get socialMinutes => integer()();
  IntColumn get lifeAdminMinutes => integer()();
  IntColumn get exerciseMinutes => integer()();
  IntColumn get restMinutes => integer()();
  IntColumn get backToBackEventCount => integer()();
  IntColumn get freeMinutes => integer()();
  IntColumn get longestGapBetweenActivitiesMinutes => integer()();
  IntColumn get maxConsecutiveBlockMinutes => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// store computed predictions based on snapshots
class DailyPredictionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()();
  IntColumn get featureSnapshotId =>
      integer().unique().references(DailyFeatureSnapshotItems, #id)();
  TextColumn get predictedCategory => text()();
  RealColumn get predictedScore => real().nullable()();
  TextColumn get reasonsJson => text().withDefault(const Constant('[]'))();
  TextColumn get predictionVersion => text()();
  IntColumn get agreementScore => integer().nullable()();
  DateTimeColumn get feedbackUpdatedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// save the user's expectations before the model explanation is revealed
class ForecastReflectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()();
  IntColumn get predictionId =>
      integer().unique().references(DailyPredictionItems, #id)();
  TextColumn get supportiveFactorType => text()();
  TextColumn get supportiveFactorLabel => text()();
  TextColumn get demandingFactorType => text()();
  TextColumn get demandingFactorLabel => text()();
  TextColumn get modelSupportiveFactorType => text().nullable()();
  TextColumn get modelSupportiveFactorLabel => text().nullable()();
  TextColumn get modelDemandingFactorType => text().nullable()();
  TextColumn get modelDemandingFactorLabel => text().nullable()();
  DateTimeColumn get revealedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// track when each calendar source was last synced and number of events imported
class CalendarSyncItems extends Table {
  TextColumn get date => text()();
  TextColumn get source => text()();
  DateTimeColumn get lastSuccessfulSyncAt => dateTime()();
  IntColumn get eventCount => integer()();

  @override
  Set<Column> get primaryKey => {date, source};
}

class InitialSetupItems extends Table {
  IntColumn get id => integer()();
  TextColumn get researchParticipantCode => text().nullable()();
  TextColumn get questionnaireVersion => text()();
  IntColumn get typicalEnergyScore => integer()();
  IntColumn get busyImpactScore => integer()();
  IntColumn get backToBackImpactScore => integer()();
  IntColumn get longBlockImpactScore => integer()();
  IntColumn get freeGapImpactScore => integer()();
  IntColumn get focusImpactScore => integer()();
  IntColumn get socialImpactScore => integer()();
  IntColumn get lifeAdminImpactScore => integer()();
  IntColumn get exerciseImpactScore => integer()();
  IntColumn get calendarUnderstandingScore => integer()();
  IntColumn get schedulePredictionConfidenceScore => integer()();
  DateTimeColumn get questionnaireCompletedAt => dateTime()();
  DateTimeColumn get calendarSetupCompletedAt => dateTime().nullable()();
  BoolColumn get calendarSetupSkipped =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class EnergyModelItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get modelVersion => text()();
  TextColumn get modelSource => text()();
  TextColumn get featureVersion => text()();
  TextColumn get targetVersion => text()();
  RealColumn get intercept => real()();
  TextColumn get coefficientsJson => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class NotificationPreferenceItems extends Table {
  IntColumn get id => integer()();
  BoolColumn get morningEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get morningHour => integer().withDefault(const Constant(9))();
  IntColumn get morningMinute => integer().withDefault(const Constant(0))();
  BoolColumn get eveningEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get eveningHour => integer().withDefault(const Constant(20))();
  IntColumn get eveningMinute => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// store only the anonymous interactions needed for research engagement counts
class ResearchInteractionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventType => text()();
  DateTimeColumn get occurredAt => dateTime()();
}

@DriftDatabase(
  tables: [
    EventUserDataItems,
    CachedCalendarEventItems,
    ManualCalendarEventItems,
    DailyReflectionItems,
    DailyIntentionItems,
    DailyFeatureSnapshotItems,
    DailyPredictionItems,
    ForecastReflectionItems,
    CalendarSyncItems,
    InitialSetupItems,
    EnergyModelItems,
    NotificationPreferenceItems,
    ResearchInteractionItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(initialSetupItems);
        }
        if (from < 3) {
          await migrator.createTable(energyModelItems);
        }
        if (from < 4) {
          await migrator.createTable(forecastReflectionItems);
        }
        if (from < 5) {
          await customStatement(
            'ALTER TABLE event_user_data_items '
            'RENAME COLUMN mental_energy_score TO energy_impact_score',
          );
          await customStatement(
            'ALTER TABLE cached_calendar_event_items '
            'RENAME COLUMN mental_energy_score TO energy_impact_score',
          );
          // old values measured remaining energy, so they can't be reused as
          // decreased/unchanged/increased activity-impact responses.
          await customStatement(
            'UPDATE event_user_data_items SET energy_impact_score = NULL',
          );
          await customStatement(
            'UPDATE cached_calendar_event_items SET energy_impact_score = NULL',
          );
        }
        if (from < 6) {
          await customStatement(
            'ALTER TABLE daily_feature_snapshot_items RENAME COLUMN '
            'longest_free_gap_minutes TO '
            'longest_gap_between_activities_minutes',
          );

          await customStatement('DELETE FROM forecast_reflection_items');
          await customStatement('DELETE FROM daily_prediction_items');
          await customStatement('DELETE FROM daily_feature_snapshot_items');
          await customStatement(
            "DELETE FROM energy_model_items "
            "WHERE model_source = 'personalised_logistic'",
          );
          await customStatement(
            "UPDATE energy_model_items SET "
            "feature_version = 'calendar_energy_v2', "
            "model_version = 'questionnaire-baseline-v2', "
            "coefficients_json = replace(coefficients_json, "
            "'longest_free_gap_minutes', "
            "'longest_gap_between_activities_minutes') "
            "WHERE model_source = 'questionnaire_baseline'",
          );
          await customStatement('UPDATE energy_model_items SET is_active = 0');
          await customStatement(
            'UPDATE energy_model_items SET is_active = 1 '
            'WHERE id = (SELECT id FROM energy_model_items '
            "WHERE model_source = 'questionnaire_baseline' "
            'ORDER BY id DESC LIMIT 1)',
          );
        }
        if (from < 7) {
          await migrator.addColumn(
            forecastReflectionItems,
            forecastReflectionItems.modelSupportiveFactorType,
          );
          await migrator.addColumn(
            forecastReflectionItems,
            forecastReflectionItems.modelSupportiveFactorLabel,
          );
          await migrator.addColumn(
            forecastReflectionItems,
            forecastReflectionItems.modelDemandingFactorType,
          );
          await migrator.addColumn(
            forecastReflectionItems,
            forecastReflectionItems.modelDemandingFactorLabel,
          );
        }
        if (from < 8) {
          await migrator.createTable(manualCalendarEventItems);
        }
        if (from < 9) {
          await migrator.createTable(notificationPreferenceItems);
        }
        if (from < 10) {
          await migrator.addColumn(
            initialSetupItems,
            initialSetupItems.researchParticipantCode,
          );
        }
        if (from < 11) {
          await migrator.createTable(researchInteractionItems);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'calendar_app.sqlite'));

    return NativeDatabase(file);
  });
}
