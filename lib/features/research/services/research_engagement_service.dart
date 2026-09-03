import '../../../core/database/app_database.dart';

abstract final class ResearchEngagementEventType {
  static const forecastViewed = 'forecast_viewed';
  static const weeklyInsightsViewed = 'weekly_insights_viewed';
}

class ResearchEngagementService {
  ResearchEngagementService({required this.database, DateTime Function()? now})
    : now = now ?? DateTime.now;

  final AppDatabase database;
  final DateTime Function() now;

  Future<void> recordForecastViewed() {
    return _record(ResearchEngagementEventType.forecastViewed);
  }

  Future<void> recordWeeklyInsightsViewed() {
    return _record(ResearchEngagementEventType.weeklyInsightsViewed);
  }

  Future<void> _record(String eventType) {
    return database
        .into(database.researchInteractionItems)
        .insert(
          ResearchInteractionItemsCompanion.insert(
            eventType: eventType,
            occurredAt: now(),
          ),
        );
  }
}
