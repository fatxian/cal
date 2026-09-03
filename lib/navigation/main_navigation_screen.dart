import 'dart:async';

import 'package:flutter/material.dart';

import '../core/database/app_database.dart';
import '../core/notifications/daily_notification_preference_service.dart';
import '../core/notifications/daily_notification_service.dart';
import '../core/utils/day_rollover_tracker.dart';
import '../features/calendar/screens/calendar_screen.dart';
import '../features/calendar/services/calendar_event_collection_service.dart';
import '../features/calendar/services/calendar_sync_service.dart';
import '../features/calendar/services/event_user_data_service.dart';
import '../features/calendar/services/google_calendar_service.dart';
import '../features/calendar/services/manual_calendar_event_service.dart';
import '../features/check_in/services/daily_reflection_service.dart';
import '../features/insights/screens/insights_screen.dart';
import '../features/insights/services/weekly_insight_service.dart';
import '../features/forecast/services/daily_intention_service.dart';
import '../features/forecast/services/forecast_reflection_service.dart';
import '../features/forecast/services/forecast_reflection_option_service.dart';
import '../features/forecast/screens/forecast_screen.dart';
import '../features/onboarding/services/initial_setup_service.dart';
import '../features/prediction/services/daily_feature_calculator.dart';
import '../features/prediction/services/daily_feature_snapshot_service.dart';
import '../features/prediction/services/daily_prediction_record_service.dart';
import '../features/prediction/services/daily_prediction_service.dart';
import '../features/prediction/services/debug_prediction_data_service.dart';
import '../features/prediction/services/energy_model_service.dart';
import '../features/prediction/services/personalised_model_update_service.dart';
import '../features/prediction/services/prediction_dataset_service.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/research/services/research_data_export_service.dart';
import '../features/research/services/research_engagement_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with WidgetsBindingObserver {
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );

  int selectedIndex = 0;

  // keep one service graph so account and database state are shared by tabs
  late final AppDatabase database;
  late final EventUserDataService eventUserDataService;
  late final ManualCalendarEventService manualCalendarEventService;
  late final CalendarEventCollectionService calendarEventCollectionService;
  late final CalendarSyncService calendarSyncService;
  late final DailyReflectionService dailyReflectionService;
  late final DailyIntentionService dailyIntentionService;
  late final ForecastReflectionService forecastReflectionService;
  late final DailyPredictionService dailyPredictionService;
  late final EnergyModelService energyModelService;
  late final PredictionDatasetService predictionDatasetService;
  late final PersonalisedModelUpdateService personalisedModelUpdateService;
  late final DebugPredictionDataService debugPredictionDataService;
  late final ForecastReflectionOptionService forecastReflectionOptionService;
  late final WeeklyInsightService weeklyInsightService;
  late final InitialSetupService initialSetupService;
  late final GoogleCalendarService googleCalendarService;
  late final DailyNotificationPreferenceService notificationPreferenceService;
  late final DailyNotificationService dailyNotificationService;
  late final ResearchDataExportService researchDataExportService;
  late final ResearchEngagementService researchEngagementService;
  // notify Forecast after Today saves refreshed calendar events
  late final ValueNotifier<int> calendarSyncNotifier;
  late final ValueNotifier<int> selectedTabNotifier;

  late List<Widget> screens;
  late final DayRolloverTracker dayRolloverTracker;
  Timer? dayRolloverTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    dayRolloverTracker = DayRolloverTracker(DateTime.now());

    database = AppDatabase();
    eventUserDataService = EventUserDataService(database: database);
    manualCalendarEventService = ManualCalendarEventService(database: database);
    calendarEventCollectionService = CalendarEventCollectionService(
      syncedEventService: eventUserDataService,
      manualEventService: manualCalendarEventService,
    );
    calendarSyncService = CalendarSyncService(database: database);
    dailyReflectionService = DailyReflectionService(database: database);
    dailyIntentionService = DailyIntentionService(database: database);
    forecastReflectionService = ForecastReflectionService(database: database);
    energyModelService = EnergyModelService(database: database);
    predictionDatasetService = PredictionDatasetService(database: database);
    personalisedModelUpdateService = PersonalisedModelUpdateService(
      datasetService: predictionDatasetService,
      energyModelService: energyModelService,
    );
    forecastReflectionOptionService = const ForecastReflectionOptionService();
    weeklyInsightService = WeeklyInsightService(database: database);
    initialSetupService = InitialSetupService(
      database: database,
      energyModelService: energyModelService,
    );
    dailyPredictionService = DailyPredictionService(
      featureCalculator: const DailyFeatureCalculator(),
      featureSnapshotService: DailyFeatureSnapshotService(database: database),
      predictionRecordService: DailyPredictionRecordService(database: database),
      energyModelService: energyModelService,
    );
    debugPredictionDataService = DebugPredictionDataService(
      database: database,
      dailyPredictionService: dailyPredictionService,
      dailyReflectionService: dailyReflectionService,
      datasetService: predictionDatasetService,
      modelUpdateService: personalisedModelUpdateService,
      energyModelService: energyModelService,
    );
    googleCalendarService = GoogleCalendarService(
      googleWebClientId: googleWebClientId,
    );
    notificationPreferenceService = DailyNotificationPreferenceService(
      database: database,
    );
    dailyNotificationService = DailyNotificationService();
    researchDataExportService = ResearchDataExportService(database: database);
    researchEngagementService = ResearchEngagementService(database: database);
    calendarSyncNotifier = ValueNotifier(0);
    selectedTabNotifier = ValueNotifier(0);
    screens = _buildScreens();
    _scheduleDayRolloverCheck();
    unawaited(_initializeNotifications());
  }

  List<Widget> _buildScreens() {
    final dayKey = dayRolloverTracker.currentDay.toIso8601String();

    return [
      CalendarScreen(
        key: ValueKey('calendar-$dayKey'),
        googleCalendarService: googleCalendarService,
        calendarEventCollectionService: calendarEventCollectionService,
        calendarSyncService: calendarSyncService,
        dailyReflectionService: dailyReflectionService,
        dailyIntentionService: dailyIntentionService,
        personalisedModelUpdateService: personalisedModelUpdateService,
        onCalendarSynced: () {
          calendarSyncNotifier.value++;
        },
        dailyPredictionService: dailyPredictionService,
        onOpenForecast: () {
          onDestinationSelected(1);
        },
      ),
      ForecastScreen(
        key: ValueKey('forecast-$dayKey'),
        calendarEventCollectionService: calendarEventCollectionService,
        calendarSyncService: calendarSyncService,
        dailyIntentionService: dailyIntentionService,
        forecastReflectionService: forecastReflectionService,
        dailyPredictionService: dailyPredictionService,
        energyModelService: energyModelService,
        reflectionOptionService: forecastReflectionOptionService,
        calendarSyncNotifier: calendarSyncNotifier,
        selectedTabNotifier: selectedTabNotifier,
        onOpenToday: () {
          onDestinationSelected(0);
        },
        onViewed: () {
          unawaited(researchEngagementService.recordForecastViewed());
        },
      ),
      InsightsScreen(
        key: ValueKey('insights-$dayKey'),
        weeklyInsightService: weeklyInsightService,
        selectedTabNotifier: selectedTabNotifier,
        onWeeklyViewed: () {
          unawaited(researchEngagementService.recordWeeklyInsightsViewed());
        },
      ),
      ProfileScreen(
        key: ValueKey('profile-$dayKey'),
        googleCalendarService: googleCalendarService,
        initialSetupService: initialSetupService,
        debugPredictionDataService: debugPredictionDataService,
        notificationPreferenceService: notificationPreferenceService,
        notificationService: dailyNotificationService,
        researchDataExportService: researchDataExportService,
        selectedTabNotifier: selectedTabNotifier,
      ),
    ];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAfterDayRollover();
      _scheduleDayRolloverCheck();
    }
  }

  void _scheduleDayRolloverCheck() {
    dayRolloverTimer?.cancel();
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    dayRolloverTimer = Timer(nextDay.difference(now), () {
      _refreshAfterDayRollover();
      _scheduleDayRolloverCheck();
    });
  }

  void _refreshAfterDayRollover() {
    if (!dayRolloverTracker.update(DateTime.now()) || !mounted) return;

    calendarSyncNotifier.value++;
    setState(() {
      screens = _buildScreens();
    });
  }

  Future<void> _initializeNotifications() async {
    try {
      final preferences = await notificationPreferenceService.load();
      await dailyNotificationService.initializeAndSchedule(
        preferences: preferences,
        onNotificationTap: (payload) {
          if (!mounted) return;
          onDestinationSelected(
            payload == DailyNotificationService.morningPayload ? 1 : 0,
          );
        },
      );
    } catch (error) {
      debugPrint('Could not schedule daily notifications: $error');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    dayRolloverTimer?.cancel();
    calendarSyncNotifier.dispose();
    selectedTabNotifier.dispose();
    googleCalendarService.dispose();
    database.close();
    super.dispose();
  }

  void onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    selectedTabNotifier.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: 'Forecast',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
