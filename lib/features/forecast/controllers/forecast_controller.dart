import 'package:flutter/foundation.dart';

import '../../calendar/models/calendar_event.dart';
import '../../calendar/services/calendar_event_collection_service.dart';
import '../../calendar/services/calendar_sync_service.dart';
import '../../calendar/utils/calendar_snapshot.dart';
import '../../prediction/models/daily_prediction.dart';
import '../../prediction/services/daily_prediction_service.dart';
import '../../prediction/services/energy_model_service.dart';
import '../models/daily_intention.dart';
import '../models/forecast_model_view.dart';
import '../models/forecast_reflection.dart';
import '../models/forecast_reflection_option.dart';
import '../services/daily_intention_service.dart';
import '../services/forecast_reflection_option_service.dart';
import '../services/forecast_reflection_service.dart';

enum ForecastActionResult { completed, ignored, failed }

class ForecastController extends ChangeNotifier {
  ForecastController({
    required this.calendarEventCollectionService,
    required this.calendarSyncService,
    required this.dailyIntentionService,
    required this.forecastReflectionService,
    required this.dailyPredictionService,
    required this.energyModelService,
    required this.reflectionOptionService,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final CalendarEventCollectionService calendarEventCollectionService;
  final CalendarSyncService calendarSyncService;
  final DailyIntentionService dailyIntentionService;
  final ForecastReflectionService forecastReflectionService;
  final DailyPredictionService dailyPredictionService;
  final EnergyModelService energyModelService;
  final ForecastReflectionOptionService reflectionOptionService;
  final DateTime Function() _now;

  List<CalendarEvent> currentEvents = [];
  List<ForecastFactorOption> factorOptions = [];
  List<ForecastIntentionOption> intentionOptions = [];
  ForecastFactorOption? selectedSupportiveFactor;
  ForecastFactorOption? selectedDemandingFactor;
  ForecastIntentionOption? selectedIntentionOption;
  ForecastModelView modelView = const ForecastModelView.empty();
  ForecastReflection? forecastReflection;
  DailyIntention? dailyIntention;
  String calendarSnapshotKey = '';
  bool isEditingIntention = false;
  bool isEditingForecastReflection = false;
  bool hasStartedForecastReflection = false;
  bool isLoadingFactors = true;
  bool isLoadingPrediction = false;
  bool isSavingPredictionResponse = false;
  bool isSavingForecastReflection = false;
  bool hasCalendarInput = false;
  int uncategorizedEventCount = 0;
  DailyPrediction? dailyPrediction;
  DateTime? loadedDay;
  String? predictionErrorMessage;
  int? selectedPredictionResponse;

  int _forecastDataGeneration = 0;
  bool _isDisposed = false;

  bool get canOpenForecast => hasCalendarInput && uncategorizedEventCount == 0;

  ForecastFactor? get currentModelSupportiveFactor =>
      modelView.supportiveSignals.isEmpty
      ? null
      : reflectionOptionService.factorForAttribution(
          modelView.supportiveSignals.first,
        );

  ForecastFactor? get currentModelDemandingFactor =>
      modelView.demandingSignals.isEmpty
      ? null
      : reflectionOptionService.factorForAttribution(
          modelView.demandingSignals.first,
        );

  ForecastFactor? get displayedModelSupportiveFactor =>
      forecastReflection?.modelSupportiveFactor ?? currentModelSupportiveFactor;

  ForecastFactor? get displayedModelDemandingFactor =>
      forecastReflection?.modelDemandingFactor ?? currentModelDemandingFactor;

  String? get strongestModelExplanation {
    final predictsLowerEnergy = (dailyPrediction?.predictedScore ?? 0.5) >= 0.5;
    final primarySignals = predictsLowerEnergy
        ? modelView.demandingSignals
        : modelView.supportiveSignals;
    final fallbackSignals = predictsLowerEnergy
        ? modelView.supportiveSignals
        : modelView.demandingSignals;
    final signals = [...primarySignals, ...fallbackSignals];

    return signals.isEmpty ? null : signals.first.sentence;
  }

  String? get comparisonMessage {
    final reflection = forecastReflection;
    if (reflection == null) return null;

    return reflectionOptionService.comparisonMessageForSavedFactors(
      supportiveFactor: reflection.supportiveFactor.type,
      demandingFactor: reflection.demandingFactor.type,
      modelSupportiveFactor: displayedModelSupportiveFactor?.type,
      modelDemandingFactor: displayedModelDemandingFactor?.type,
    );
  }

  bool get hasCalendarChanged {
    final savedSnapshotKey = dailyIntention?.calendarSnapshotKey;
    return savedSnapshotKey != null &&
        savedSnapshotKey.isNotEmpty &&
        calendarSnapshotKey.isNotEmpty &&
        savedSnapshotKey != calendarSnapshotKey;
  }

  Future<void> prepareForTabEntry() async {
    final today = _now();
    if (loadedDay == null || !_isSameCalendarDay(loadedDay!, today)) {
      dailyPrediction = null;
      forecastReflection = null;
      dailyIntention = null;
      selectedSupportiveFactor = null;
      selectedDemandingFactor = null;
      selectedIntentionOption = null;
      hasStartedForecastReflection = false;
    }
    isLoadingFactors = true;
    _notifyListeners();
    await loadForecastData();
  }

  Future<void> retryPredictionLoad() async {
    if (isLoadingPrediction) return;
    isLoadingPrediction = true;
    predictionErrorMessage = null;
    _notifyListeners();

    try {
      await loadForecastData();
    } finally {
      isLoadingPrediction = false;
      _notifyListeners();
    }
  }

  Future<ForecastActionResult> savePredictionAgreement(int response) async {
    if (isSavingPredictionResponse) return ForecastActionResult.ignored;

    final previousResponse = selectedPredictionResponse;
    selectedPredictionResponse = response;
    isSavingPredictionResponse = true;
    _notifyListeners();

    try {
      await dailyPredictionService.saveAgreementForDay(_now(), response);
      return ForecastActionResult.completed;
    } catch (error) {
      debugPrint('Could not save the forecast agreement: $error');
      selectedPredictionResponse = previousResponse;
      _notifyListeners();
      return ForecastActionResult.failed;
    } finally {
      isSavingPredictionResponse = false;
      _notifyListeners();
    }
  }

  Future<void> loadForecastData() async {
    final today = _now();
    final generation = ++_forecastDataGeneration;

    try {
      final modelParameters = await energyModelService.loadActiveModel();
      final snapshot = await dailyPredictionService
          .loadInitialFeatureSnapshotForDay(today);
      final prediction = await dailyPredictionService
          .loadInitialPredictionForDay(today);
      final events = await calendarEventCollectionService.loadEventsForDay(
        today,
      );
      final hasSuccessfulSync =
          await calendarSyncService.loadLatestSuccessfulSyncForDay(today) !=
          null;
      final savedIntention = await dailyIntentionService.loadIntentionForDay(
        today,
      );
      final savedReflection = await forecastReflectionService
          .loadReflectionForDay(today);

      if (!_isCurrentForecastRequest(today, generation)) return;
      final options = reflectionOptionService.buildForecastFactorOptions(
        day: today,
        events: events,
      );
      final loadedModelView = snapshot == null
          ? const ForecastModelView.empty()
          : reflectionOptionService.buildModelView(
              features: snapshot.features,
              modelParameters: modelParameters,
            );
      final snapshotKey = createCalendarSnapshotKey(events);
      final supportiveFactor = _findForecastFactor(
        options,
        savedReflection?.supportiveFactor,
      );
      final demandingFactor = _findForecastFactor(
        options,
        savedReflection?.demandingFactor,
      );
      final loadedIntentionOptions =
          supportiveFactor == null || demandingFactor == null
          ? <ForecastIntentionOption>[]
          : reflectionOptionService.buildIntentionOptions(
              day: today,
              events: events,
              supportiveFactor: supportiveFactor,
              demandingFactor: demandingFactor,
              modelView: loadedModelView,
            );

      loadedDay = DateTime(today.year, today.month, today.day);
      currentEvents = events;
      factorOptions = options;
      modelView = loadedModelView;
      dailyPrediction = prediction;
      selectedPredictionResponse = prediction?.agreementScore;
      predictionErrorMessage = null;
      forecastReflection = savedReflection;
      selectedSupportiveFactor = supportiveFactor;
      selectedDemandingFactor = demandingFactor;
      intentionOptions = loadedIntentionOptions;
      dailyIntention = savedIntention;
      selectedIntentionOption = _findIntentionOption(
        loadedIntentionOptions,
        savedIntention,
      );
      calendarSnapshotKey = snapshotKey;
      isEditingForecastReflection = false;
      isEditingIntention = false;
      hasStartedForecastReflection = savedReflection != null;
      hasCalendarInput =
          hasSuccessfulSync ||
          events.any((event) => event.source == CalendarEventSource.manual);
      uncategorizedEventCount = events
          .where((event) => event.category == null)
          .length;
      isLoadingFactors = false;
      _notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('Could not load Forecast data: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!_isCurrentForecastRequest(today, generation)) return;
      isLoadingFactors = false;
      predictionErrorMessage = 'Could not load today\'s forecast.';
      _notifyListeners();
    }
  }

  Future<bool> recalculateFactorOptions() async {
    final today = _now();
    final generation = ++_forecastDataGeneration;

    try {
      final events = await calendarEventCollectionService.loadEventsForDay(
        today,
      );
      final hasSuccessfulSync =
          await calendarSyncService.loadLatestSuccessfulSyncForDay(today) !=
          null;

      if (!_isCurrentForecastRequest(today, generation)) return true;
      final options = reflectionOptionService.buildForecastFactorOptions(
        day: today,
        events: events,
      );
      final snapshotKey = createCalendarSnapshotKey(events);
      final supportiveFactor = _findForecastFactor(
        options,
        forecastReflection?.supportiveFactor ??
            selectedSupportiveFactor?.toFactor(),
      );
      final demandingFactor = _findForecastFactor(
        options,
        forecastReflection?.demandingFactor ??
            selectedDemandingFactor?.toFactor(),
      );
      final updatedIntentionOptions =
          supportiveFactor == null || demandingFactor == null
          ? <ForecastIntentionOption>[]
          : reflectionOptionService.buildIntentionOptions(
              day: today,
              events: events,
              supportiveFactor: supportiveFactor,
              demandingFactor: demandingFactor,
              modelView: modelView,
            );
      final savedSnapshotKey = dailyIntention?.calendarSnapshotKey;
      final calendarChanged =
          savedSnapshotKey != null &&
          savedSnapshotKey.isNotEmpty &&
          savedSnapshotKey != snapshotKey;

      currentEvents = events;
      factorOptions = options;
      selectedSupportiveFactor = supportiveFactor;
      selectedDemandingFactor = demandingFactor;
      intentionOptions = updatedIntentionOptions;
      selectedIntentionOption = _findIntentionOption(
        updatedIntentionOptions,
        dailyIntention,
      );
      calendarSnapshotKey = snapshotKey;
      hasCalendarInput =
          hasSuccessfulSync ||
          events.any((event) => event.source == CalendarEventSource.manual);
      uncategorizedEventCount = events
          .where((event) => event.category == null)
          .length;
      isLoadingFactors = false;
      if (calendarChanged) isEditingIntention = false;
      _notifyListeners();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Could not refresh Forecast options: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!_isCurrentForecastRequest(today, generation)) return true;
      isLoadingFactors = false;
      _notifyListeners();
      return false;
    }
  }

  void selectSupportiveFactor(ForecastFactorOption factor) {
    selectedSupportiveFactor = factor;
    _notifyListeners();
  }

  void startForecastReflection() {
    hasStartedForecastReflection = true;
    _notifyListeners();
  }

  void selectDemandingFactor(ForecastFactorOption factor) {
    selectedDemandingFactor = factor;
    _notifyListeners();
  }

  Future<ForecastActionResult> revealForecastComparison() async {
    final prediction = dailyPrediction;
    final supportiveFactor = selectedSupportiveFactor;
    final demandingFactor = selectedDemandingFactor;
    if (prediction == null ||
        supportiveFactor == null ||
        demandingFactor == null ||
        isSavingForecastReflection) {
      return ForecastActionResult.ignored;
    }

    isSavingForecastReflection = true;
    _notifyListeners();

    final revealedAt = _now();
    final modelSupportiveFactor = currentModelSupportiveFactor;
    final modelDemandingFactor = currentModelDemandingFactor;
    try {
      await forecastReflectionService.saveReflectionForDay(
        day: _now(),
        predictionId: prediction.id,
        supportiveFactor: supportiveFactor.toFactor(),
        demandingFactor: demandingFactor.toFactor(),
        modelSupportiveFactor: modelSupportiveFactor,
        modelDemandingFactor: modelDemandingFactor,
        revealedAt: revealedAt,
      );
      if (_isDisposed) return ForecastActionResult.ignored;

      forecastReflection = ForecastReflection(
        predictionId: prediction.id,
        supportiveFactor: supportiveFactor.toFactor(),
        demandingFactor: demandingFactor.toFactor(),
        modelSupportiveFactor: modelSupportiveFactor,
        modelDemandingFactor: modelDemandingFactor,
        revealedAt: revealedAt,
      );
      isEditingForecastReflection = false;
      intentionOptions = reflectionOptionService.buildIntentionOptions(
        day: _now(),
        events: currentEvents,
        supportiveFactor: supportiveFactor,
        demandingFactor: demandingFactor,
        modelView: modelView,
      );
      _notifyListeners();
      return ForecastActionResult.completed;
    } catch (error) {
      debugPrint('Could not save the forecast reflection: $error');
      return ForecastActionResult.failed;
    } finally {
      isSavingForecastReflection = false;
      _notifyListeners();
    }
  }

  void editForecastReflection() {
    isEditingForecastReflection = true;
    hasStartedForecastReflection = true;
    _notifyListeners();
  }

  Future<ForecastActionResult> selectIntention(
    ForecastIntentionOption option,
  ) async {
    final previousOption = selectedIntentionOption;
    final previousIntention = dailyIntention;
    final wasEditing = isEditingIntention;
    final intention = DailyIntention(
      factor: option.factor,
      adjustment: option.adjustment,
      calendarSnapshotKey: calendarSnapshotKey,
    );
    selectedIntentionOption = option;
    dailyIntention = intention;
    isEditingIntention = false;
    _notifyListeners();

    try {
      await dailyIntentionService.saveIntentionForDay(_now(), intention);
      return ForecastActionResult.completed;
    } catch (error) {
      debugPrint('Could not save the daily intention: $error');
      selectedIntentionOption = previousOption;
      dailyIntention = previousIntention;
      isEditingIntention = wasEditing;
      _notifyListeners();
      return ForecastActionResult.failed;
    }
  }

  void reviewIntention() {
    final intention = dailyIntention;
    if (intention == null) return;
    selectedIntentionOption = _findIntentionOption(intentionOptions, intention);
    isEditingIntention = true;
    _notifyListeners();
  }

  Future<ForecastActionResult> keepCurrentIntention() async {
    final intention = dailyIntention;
    if (intention == null) return ForecastActionResult.ignored;

    final wasEditing = isEditingIntention;
    final updatedIntention = DailyIntention(
      factor: intention.factor,
      adjustment: intention.adjustment,
      calendarSnapshotKey: calendarSnapshotKey,
    );
    dailyIntention = updatedIntention;
    isEditingIntention = false;
    _notifyListeners();

    try {
      await dailyIntentionService.saveIntentionForDay(_now(), updatedIntention);
      return ForecastActionResult.completed;
    } catch (error) {
      debugPrint('Could not update the daily intention: $error');
      dailyIntention = intention;
      isEditingIntention = wasEditing;
      _notifyListeners();
      return ForecastActionResult.failed;
    }
  }

  void editIntention() {
    final intention = dailyIntention;
    if (intention == null) return;
    selectedIntentionOption = _findIntentionOption(intentionOptions, intention);
    isEditingIntention = true;
    _notifyListeners();
  }

  ForecastFactorOption? _findForecastFactor(
    List<ForecastFactorOption> options,
    ForecastFactor? factor,
  ) {
    if (factor == null) return null;
    for (final option in options) {
      if (option.type == factor.type) return option;
    }
    return ForecastFactorOption(type: factor.type, label: factor.label);
  }

  ForecastIntentionOption? _findIntentionOption(
    List<ForecastIntentionOption> options,
    DailyIntention? intention,
  ) {
    if (intention == null) return null;
    for (final option in options) {
      if (option.factor.type == intention.factor.type &&
          _adjustmentsMatch(option.adjustment, intention.adjustment)) {
        return option;
      }
    }
    return null;
  }

  bool _adjustmentsMatch(DailyAdjustment first, DailyAdjustment second) {
    return first.type == second.type &&
        first.label == second.label &&
        _sameTime(first.startTime, second.startTime) &&
        _sameTime(first.endTime, second.endTime);
  }

  bool _sameTime(DateTime? first, DateTime? second) =>
      first?.millisecondsSinceEpoch == second?.millisecondsSinceEpoch;

  bool _isSameCalendarDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  bool _isCurrentForecastRequest(DateTime day, int generation) =>
      !_isDisposed &&
      generation == _forecastDataGeneration &&
      _isSameCalendarDay(day, _now());

  void _notifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
