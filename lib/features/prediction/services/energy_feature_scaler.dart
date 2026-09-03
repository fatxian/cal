import '../models/daily_calendar_features.dart';
import '../models/logistic_feature_vector.dart';

class EnergyFeatureScaler {
  const EnergyFeatureScaler();

  static const int busyMinutesReference = 480;
  static const int backToBackEventCountReference = 4;
  static const int longestGapBetweenActivitiesMinutesReference = 180;
  static const int maxConsecutiveBlockMinutesReference = 240;
  static const int categoryMinutesReference = 240;

  LogisticFeatureVector scale(DailyCalendarFeatures features) {
    return LogisticFeatureVector(
      busyMinutes: _scale(features.busyMinutes, busyMinutesReference),
      backToBackEventCount: _scale(
        features.backToBackEventCount,
        backToBackEventCountReference,
      ),
      longestGapBetweenActivitiesMinutes: _scale(
        features.longestGapBetweenActivitiesMinutes,
        longestGapBetweenActivitiesMinutesReference,
      ),
      maxConsecutiveBlockMinutes: _scale(
        features.maxConsecutiveBlockMinutes,
        maxConsecutiveBlockMinutesReference,
      ),
      focusMinutes: _scale(features.focusMinutes, categoryMinutesReference),
      socialMinutes: _scale(features.socialMinutes, categoryMinutesReference),
      lifeAdminMinutes: _scale(
        features.lifeAdminMinutes,
        categoryMinutesReference,
      ),
      exerciseMinutes: _scale(
        features.exerciseMinutes,
        categoryMinutesReference,
      ),
    );
  }

  double _scale(int value, int reference) {
    return (value / reference).clamp(0.0, 1.0);
  }
}
