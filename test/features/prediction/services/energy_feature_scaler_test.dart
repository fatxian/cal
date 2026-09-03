import 'package:calendar_app/features/prediction/models/daily_calendar_features.dart';
import 'package:calendar_app/features/prediction/models/energy_model_feature.dart';
import 'package:calendar_app/features/prediction/services/energy_feature_scaler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnergyModelContract', () {
    test('keeps feature order', () {
      expect(
        EnergyModelContract.orderedFeatures.map((feature) => feature.key),
        [
          'busy_minutes',
          'back_to_back_event_count',
          'longest_gap_between_activities_minutes',
          'max_consecutive_block_minutes',
          'focus_minutes',
          'social_minutes',
          'life_admin_minutes',
          'exercise_minutes',
        ],
      );
    });

    test('maps energy labels', () {
      expect(EnergyModelContract.targetVersion, 'binary_low_energy_v1');
      expect(EnergyModelContract.lowEnergyLabelFromEnergyScore(1), 1);
      expect(EnergyModelContract.lowEnergyLabelFromEnergyScore(2), 1);
      expect(EnergyModelContract.lowEnergyLabelFromEnergyScore(3), 0);
      expect(EnergyModelContract.lowEnergyLabelFromEnergyScore(4), 0);
      expect(EnergyModelContract.lowEnergyLabelFromEnergyScore(5), 0);
    });

    test('rejects invalid scores', () {
      expect(
        () => EnergyModelContract.lowEnergyLabelFromEnergyScore(0),
        throwsRangeError,
      );
      expect(
        () => EnergyModelContract.lowEnergyLabelFromEnergyScore(6),
        throwsRangeError,
      );
    });
  });

  group('EnergyFeatureScaler', () {
    const scaler = EnergyFeatureScaler();

    test('scales calendar features', () {
      final vector = scaler.scale(
        _features(
          busyMinutes: 240,
          backToBackEventCount: 2,
          longestGapBetweenActivitiesMinutes: 90,
          maxConsecutiveBlockMinutes: 120,
          focusMinutes: 60,
          socialMinutes: 120,
          lifeAdminMinutes: 180,
          exerciseMinutes: 240,
        ),
      );

      expect(vector.featureVersion, 'calendar_energy_v2');
      expect(vector.orderedValues, [0.5, 0.5, 0.5, 0.5, 0.25, 0.5, 0.75, 1.0]);
    });

    test('caps scaled values', () {
      final vector = scaler.scale(
        _features(
          busyMinutes: 600,
          backToBackEventCount: 8,
          longestGapBetweenActivitiesMinutes: 300,
          maxConsecutiveBlockMinutes: 360,
          focusMinutes: 300,
          socialMinutes: 300,
          lifeAdminMinutes: 300,
          exerciseMinutes: 300,
        ),
      );

      expect(vector.orderedValues, everyElement(1.0));
    });
  });
}

DailyCalendarFeatures _features({
  required int busyMinutes,
  required int backToBackEventCount,
  required int longestGapBetweenActivitiesMinutes,
  required int maxConsecutiveBlockMinutes,
  required int focusMinutes,
  required int socialMinutes,
  required int lifeAdminMinutes,
  required int exerciseMinutes,
}) {
  return DailyCalendarFeatures(
    totalEventCount: 0,
    allDayEventCount: 0,
    totalScheduledMinutes: busyMinutes,
    busyMinutes: busyMinutes,
    focusMinutes: focusMinutes,
    socialMinutes: socialMinutes,
    lifeAdminMinutes: lifeAdminMinutes,
    exerciseMinutes: exerciseMinutes,
    restMinutes: 0,
    backToBackEventCount: backToBackEventCount,
    freeMinutes: 0,
    longestGapBetweenActivitiesMinutes: longestGapBetweenActivitiesMinutes,
    maxConsecutiveBlockMinutes: maxConsecutiveBlockMinutes,
    freeSlots: const [],
  );
}
