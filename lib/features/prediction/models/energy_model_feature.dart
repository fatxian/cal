enum EnergyModelFeature {
  busyMinutes('busy_minutes'),
  backToBackEventCount('back_to_back_event_count'),
  longestGapBetweenActivitiesMinutes('longest_gap_between_activities_minutes'),
  maxConsecutiveBlockMinutes('max_consecutive_block_minutes'),
  focusMinutes('focus_minutes'),
  socialMinutes('social_minutes'),
  lifeAdminMinutes('life_admin_minutes'),
  exerciseMinutes('exercise_minutes');

  const EnergyModelFeature(this.key);

  final String key;

  String get displayLabel => switch (this) {
    EnergyModelFeature.busyMinutes => 'Total scheduled time',
    EnergyModelFeature.backToBackEventCount => 'Back-to-back activities',
    EnergyModelFeature.longestGapBetweenActivitiesMinutes =>
      'Long gaps between activities',
    EnergyModelFeature.maxConsecutiveBlockMinutes =>
      'Longest stretch without a break',
    EnergyModelFeature.focusMinutes => 'Focused activities',
    EnergyModelFeature.socialMinutes => 'Social activities',
    EnergyModelFeature.lifeAdminMinutes => 'Life admin tasks',
    EnergyModelFeature.exerciseMinutes => 'Exercise time',
  };
}

abstract final class EnergyModelContract {
  static const String featureVersion = 'calendar_energy_v2';
  static const String targetVersion = 'binary_low_energy_v1';
  static const int lowEnergyMaximumScore = 2;

  static const List<EnergyModelFeature> orderedFeatures = [
    EnergyModelFeature.busyMinutes,
    EnergyModelFeature.backToBackEventCount,
    EnergyModelFeature.longestGapBetweenActivitiesMinutes,
    EnergyModelFeature.maxConsecutiveBlockMinutes,
    EnergyModelFeature.focusMinutes,
    EnergyModelFeature.socialMinutes,
    EnergyModelFeature.lifeAdminMinutes,
    EnergyModelFeature.exerciseMinutes,
  ];

  static int lowEnergyLabelFromEnergyScore(int energyScore) {
    if (energyScore < 1 || energyScore > 5) {
      throw RangeError.range(energyScore, 1, 5, 'energyScore');
    }

    return energyScore <= lowEnergyMaximumScore ? 1 : 0;
  }
}
