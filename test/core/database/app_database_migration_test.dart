import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'package:calendar_app/core/database/app_database.dart';

void main() {
  test('migrates version 5', () async {
    final directory = await Directory.systemTemp.createTemp(
      'calendar_app_migration_test',
    );
    final databaseFile = File('${directory.path}/app.sqlite');

    try {
      await _createVersionFiveFixture(databaseFile);

      final database = AppDatabase.forTesting(NativeDatabase(databaseFile));
      await database.customSelect('SELECT 1').get();

      final columns = await database
          .customSelect('PRAGMA table_info(daily_feature_snapshot_items)')
          .get();
      final columnNames = columns
          .map((row) => row.read<String>('name'))
          .toSet();
      expect(columnNames, contains('longest_gap_between_activities_minutes'));
      expect(columnNames, isNot(contains('longest_free_gap_minutes')));

      final reflectionColumns = await database
          .customSelect('PRAGMA table_info(forecast_reflection_items)')
          .get();
      final reflectionColumnNames = reflectionColumns
          .map((row) => row.read<String>('name'))
          .toSet();
      expect(
        reflectionColumnNames,
        containsAll([
          'model_supportive_factor_type',
          'model_supportive_factor_label',
          'model_demanding_factor_type',
          'model_demanding_factor_label',
        ]),
      );
      final manualEventColumns = await database
          .customSelect('PRAGMA table_info(manual_calendar_event_items)')
          .get();
      expect(
        manualEventColumns.map((row) => row.read<String>('name')),
        containsAll(['title', 'start_time', 'end_time', 'category']),
      );
      final notificationColumns = await database
          .customSelect('PRAGMA table_info(notification_preference_items)')
          .get();
      expect(
        notificationColumns.map((row) => row.read<String>('name')),
        containsAll([
          'morning_enabled',
          'morning_hour',
          'morning_minute',
          'evening_enabled',
          'evening_hour',
          'evening_minute',
        ]),
      );
      final setupColumns = await database
          .customSelect('PRAGMA table_info(initial_setup_items)')
          .get();
      expect(
        setupColumns.map((row) => row.read<String>('name')),
        contains('research_participant_code'),
      );
      final interactionColumns = await database
          .customSelect('PRAGMA table_info(research_interaction_items)')
          .get();
      expect(
        interactionColumns.map((row) => row.read<String>('name')),
        containsAll(['event_type', 'occurred_at']),
      );

      expect(await _rowCount(database, 'daily_feature_snapshot_items'), 0);
      expect(await _rowCount(database, 'daily_prediction_items'), 0);
      expect(await _rowCount(database, 'forecast_reflection_items'), 0);

      final models = await database
          .customSelect(
            'SELECT model_source, model_version, feature_version, '
            'coefficients_json, is_active FROM energy_model_items',
          )
          .get();
      expect(models, hasLength(1));
      expect(
        models.single.read<String>('model_source'),
        'questionnaire_baseline',
      );
      expect(
        models.single.read<String>('model_version'),
        'questionnaire-baseline-v2',
      );
      expect(
        models.single.read<String>('feature_version'),
        'calendar_energy_v2',
      );
      expect(
        models.single.read<String>('coefficients_json'),
        contains('longest_gap_between_activities_minutes'),
      );
      expect(
        models.single.read<String>('coefficients_json'),
        isNot(contains('longest_free_gap_minutes')),
      );
      expect(models.single.read<int>('is_active'), 1);

      await database.close();
    } finally {
      await directory.delete(recursive: true);
    }
  });

  test('keeps version 6 data', () async {
    final directory = await Directory.systemTemp.createTemp(
      'calendar_app_v6_migration_test',
    );
    final databaseFile = File('${directory.path}/app.sqlite');

    try {
      await _createVersionSixFixture(databaseFile);

      final database = AppDatabase.forTesting(NativeDatabase(databaseFile));
      await database.customSelect('SELECT 1').get();

      final reflections = await database
          .select(database.forecastReflectionItems)
          .get();
      expect(reflections, hasLength(1));
      expect(reflections.single.supportiveFactorType, 'exercise');
      expect(reflections.single.demandingFactorType, 'focusTime');
      expect(reflections.single.modelSupportiveFactorType, isNull);
      expect(reflections.single.modelDemandingFactorType, isNull);

      await database.close();
    } finally {
      await directory.delete(recursive: true);
    }
  });
}

Future<void> _createVersionFiveFixture(File databaseFile) async {
  final currentDatabase = AppDatabase.forTesting(NativeDatabase(databaseFile));
  await currentDatabase.customSelect('SELECT 1').get();
  await currentDatabase.close();

  final database = sqlite.sqlite3.open(databaseFile.path);
  try {
    _removeVersionSevenForecastColumns(database);
    database.execute('DROP TABLE manual_calendar_event_items');
    database.execute('DROP TABLE notification_preference_items');
    database.execute('DROP TABLE research_interaction_items');
    database.execute(
      'ALTER TABLE initial_setup_items DROP COLUMN research_participant_code',
    );
    database.execute(
      'ALTER TABLE daily_feature_snapshot_items RENAME COLUMN '
      'longest_gap_between_activities_minutes TO longest_free_gap_minutes',
    );
    database.execute('PRAGMA user_version = 5');

    database.execute(
      'INSERT INTO daily_feature_snapshot_items ('
      'id, date, captured_at, analysis_start_hour, analysis_end_hour, '
      'prediction_phase, calculation_version, calendar_snapshot_key, '
      'total_event_count, all_day_event_count, total_scheduled_minutes, '
      'busy_minutes, focus_minutes, social_minutes, life_admin_minutes, '
      'exercise_minutes, rest_minutes, back_to_back_event_count, free_minutes, '
      'longest_free_gap_minutes, max_consecutive_block_minutes, created_at, '
      'updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '
      '?, ?, ?, ?, ?, ?, ?)',
      [
        1,
        '2026-07-19',
        0,
        8,
        22,
        'initial',
        1,
        'old-snapshot',
        2,
        0,
        120,
        120,
        120,
        0,
        0,
        0,
        0,
        0,
        720,
        480,
        120,
        0,
        0,
      ],
    );
    database.execute(
      'INSERT INTO daily_prediction_items ('
      'id, date, feature_snapshot_id, predicted_category, predicted_score, '
      'reasons_json, prediction_version, created_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [1, '2026-07-19', 1, 'demanding', 0.7, '[]', 'old-v1', 0],
    );
    database.execute(
      'INSERT INTO forecast_reflection_items ('
      'id, date, prediction_id, supportive_factor_type, '
      'supportive_factor_label, demanding_factor_type, '
      'demanding_factor_label, revealed_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        1,
        '2026-07-19',
        1,
        'longestFreeGap',
        'Longest free gap',
        'scheduledTime',
        'Scheduled time',
        0,
        0,
      ],
    );
    database.execute(
      'INSERT INTO energy_model_items ('
      'id, model_version, model_source, feature_version, target_version, '
      'intercept, coefficients_json, is_active, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        1,
        'questionnaire-baseline-v1',
        'questionnaire_baseline',
        'calendar_energy_v1',
        'binary_low_energy_v1',
        0.1,
        '{"busy_minutes":0.25,"longest_free_gap_minutes":-0.5}',
        0,
        0,
        0,
      ],
    );
    database.execute(
      'INSERT INTO energy_model_items ('
      'id, model_version, model_source, feature_version, target_version, '
      'intercept, coefficients_json, is_active, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        2,
        'personalised-logistic-v1',
        'personalised_logistic',
        'calendar_energy_v1',
        'binary_low_energy_v1',
        0.2,
        '{"busy_minutes":0.5,"longest_free_gap_minutes":-0.25}',
        1,
        0,
        0,
      ],
    );
  } finally {
    database.dispose();
  }
}

Future<void> _createVersionSixFixture(File databaseFile) async {
  final currentDatabase = AppDatabase.forTesting(NativeDatabase(databaseFile));
  await currentDatabase.customSelect('SELECT 1').get();
  await currentDatabase.close();

  final database = sqlite.sqlite3.open(databaseFile.path);
  try {
    _removeVersionSevenForecastColumns(database);
    database.execute('DROP TABLE manual_calendar_event_items');
    database.execute('DROP TABLE notification_preference_items');
    database.execute('DROP TABLE research_interaction_items');
    database.execute(
      'ALTER TABLE initial_setup_items DROP COLUMN research_participant_code',
    );
    database.execute('PRAGMA user_version = 6');
    database.execute(
      'INSERT INTO daily_feature_snapshot_items ('
      'id, date, captured_at, analysis_start_hour, analysis_end_hour, '
      'prediction_phase, calculation_version, calendar_snapshot_key, '
      'total_event_count, all_day_event_count, total_scheduled_minutes, '
      'busy_minutes, focus_minutes, social_minutes, life_admin_minutes, '
      'exercise_minutes, rest_minutes, back_to_back_event_count, free_minutes, '
      'longest_gap_between_activities_minutes, '
      'max_consecutive_block_minutes, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '
      '?, ?, ?)',
      [
        1,
        '2026-07-19',
        0,
        8,
        22,
        'initial',
        2,
        'snapshot',
        2,
        0,
        120,
        120,
        120,
        0,
        0,
        0,
        0,
        0,
        720,
        60,
        120,
        0,
        0,
      ],
    );
    database.execute(
      'INSERT INTO daily_prediction_items ('
      'id, date, feature_snapshot_id, predicted_category, predicted_score, '
      'reasons_json, prediction_version, created_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        1,
        '2026-07-19',
        1,
        'sufficient',
        0.4,
        '[]',
        'questionnaire-baseline-v2',
        0,
      ],
    );
    database.execute(
      'INSERT INTO forecast_reflection_items ('
      'id, date, prediction_id, supportive_factor_type, '
      'supportive_factor_label, demanding_factor_type, '
      'demanding_factor_label, revealed_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        1,
        '2026-07-19',
        1,
        'exercise',
        'Exercise',
        'focusTime',
        'Focused activities',
        0,
        0,
      ],
    );
  } finally {
    database.dispose();
  }
}

void _removeVersionSevenForecastColumns(sqlite.Database database) {
  database.execute(
    'ALTER TABLE forecast_reflection_items '
    'DROP COLUMN model_supportive_factor_type',
  );
  database.execute(
    'ALTER TABLE forecast_reflection_items '
    'DROP COLUMN model_supportive_factor_label',
  );
  database.execute(
    'ALTER TABLE forecast_reflection_items '
    'DROP COLUMN model_demanding_factor_type',
  );
  database.execute(
    'ALTER TABLE forecast_reflection_items '
    'DROP COLUMN model_demanding_factor_label',
  );
}

Future<int> _rowCount(AppDatabase database, String tableName) async {
  final row = await database
      .customSelect('SELECT COUNT(*) AS count FROM $tableName')
      .getSingle();
  return row.read<int>('count');
}
