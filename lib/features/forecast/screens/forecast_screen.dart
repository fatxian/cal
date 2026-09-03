import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/primary_tab_app_bar.dart';
import '../../calendar/services/calendar_event_collection_service.dart';
import '../../calendar/services/calendar_sync_service.dart';
import '../../prediction/models/daily_prediction.dart';
import '../../prediction/services/daily_prediction_service.dart';
import '../../prediction/services/energy_model_service.dart';
import '../models/forecast_reflection_option.dart';
import '../controllers/forecast_controller.dart';
import '../services/daily_intention_service.dart';
import '../services/forecast_reflection_option_service.dart';
import '../services/forecast_reflection_service.dart';
import '../widgets/forecast_factor_dropdown.dart';
import '../widgets/forecast_intention_section.dart';
import '../widgets/low_energy_likelihood_gauge.dart';

part '../widgets/forecast_access_widgets.dart';
part '../widgets/forecast_prediction_card.dart';
part '../widgets/forecast_expectation_widgets.dart';
part '../widgets/forecast_comparison_widgets.dart';
part '../widgets/forecast_response_widgets.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({
    super.key,
    required this.calendarEventCollectionService,
    required this.calendarSyncService,
    required this.dailyIntentionService,
    required this.forecastReflectionService,
    required this.dailyPredictionService,
    required this.energyModelService,
    required this.reflectionOptionService,
    required this.calendarSyncNotifier,
    required this.selectedTabNotifier,
    required this.onOpenToday,
    this.onViewed,
  });

  final CalendarEventCollectionService calendarEventCollectionService;
  final CalendarSyncService calendarSyncService;
  final DailyIntentionService dailyIntentionService;
  final ForecastReflectionService forecastReflectionService;
  final DailyPredictionService dailyPredictionService;
  final EnergyModelService energyModelService;
  final ForecastReflectionOptionService reflectionOptionService;
  final ValueListenable<int> calendarSyncNotifier;
  final ValueListenable<int> selectedTabNotifier;
  final VoidCallback onOpenToday;
  final VoidCallback? onViewed;

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late final ForecastController controller;

  @override
  void initState() {
    super.initState();
    controller = ForecastController(
      calendarEventCollectionService: widget.calendarEventCollectionService,
      calendarSyncService: widget.calendarSyncService,
      dailyIntentionService: widget.dailyIntentionService,
      forecastReflectionService: widget.forecastReflectionService,
      dailyPredictionService: widget.dailyPredictionService,
      energyModelService: widget.energyModelService,
      reflectionOptionService: widget.reflectionOptionService,
    )..addListener(handleControllerChanged);
    widget.calendarSyncNotifier.addListener(handleCalendarSyncChanged);
    widget.selectedTabNotifier.addListener(handleSelectedTabChanged);
    unawaited(controller.loadForecastData());
  }

  @override
  void dispose() {
    widget.calendarSyncNotifier.removeListener(handleCalendarSyncChanged);
    widget.selectedTabNotifier.removeListener(handleSelectedTabChanged);
    controller
      ..removeListener(handleControllerChanged)
      ..dispose();
    super.dispose();
  }

  void handleControllerChanged() {
    if (mounted) setState(() {});
  }

  void handleSelectedTabChanged() {
    if (widget.selectedTabNotifier.value != 1 || !mounted) return;
    widget.onViewed?.call();
    unawaited(controller.prepareForTabEntry());
  }

  void handleCalendarSyncChanged() {
    unawaited(refreshFactorOptions());
  }

  @override
  Widget build(BuildContext context) {
    final supportiveFactor = controller.displayedModelSupportiveFactor;
    final demandingFactor = controller.displayedModelDemandingFactor;

    return Scaffold(
      appBar: const PrimaryTabAppBar(title: 'Cal’s Forecast'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          children: [
            if (controller.dailyPrediction == null ||
                !controller.canOpenForecast)
              const _ForecastWaitingPreview()
            else
              _PredictionOverview(prediction: controller.dailyPrediction!),
            const SizedBox(height: 24),
            if (controller.isLoadingFactors)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (controller.predictionErrorMessage != null)
              _ForecastLoadErrorCard(
                message: controller.predictionErrorMessage!,
                onRetry: controller.retryPredictionLoad,
              )
            else if (!controller.canOpenForecast)
              _ForecastAccessCard(
                hasCalendarInput: controller.hasCalendarInput,
                uncategorizedEventCount: controller.uncategorizedEventCount,
                onOpenToday: widget.onOpenToday,
              )
            else
              _PredictionCard(
                prediction: controller.dailyPrediction,
                isLoading: controller.isLoadingPrediction,
                errorMessage: controller.predictionErrorMessage,
                selectedResponse: controller.selectedPredictionResponse,
                isSavingResponse: controller.isSavingPredictionResponse,
                isLoadingFactors: controller.isLoadingFactors,
                factorOptions: controller.factorOptions,
                selectedSupportiveFactor: controller.selectedSupportiveFactor,
                selectedDemandingFactor: controller.selectedDemandingFactor,
                supportiveModelFactors: [
                  if (supportiveFactor != null) supportiveFactor.label,
                ],
                demandingModelFactors: [
                  if (demandingFactor != null) demandingFactor.label,
                ],
                modelExplanation: controller.strongestModelExplanation,
                isReflectionRevealed:
                    controller.forecastReflection != null &&
                    !controller.isEditingForecastReflection,
                hasStartedReflection: controller.hasStartedForecastReflection,
                isSavingReflection: controller.isSavingForecastReflection,
                onRetry: controller.retryPredictionLoad,
                onOpenToday: widget.onOpenToday,
                onResponseSelected: savePredictionAgreement,
                onSupportiveFactorSelected: controller.selectSupportiveFactor,
                onDemandingFactorSelected: controller.selectDemandingFactor,
                onReveal: revealForecastComparison,
                onStartReflection: controller.startForecastReflection,
                onEditReflection: controller.editForecastReflection,
                comparisonMessage: controller.comparisonMessage,
              ),
            if (controller.dailyPrediction != null &&
                controller.canOpenForecast &&
                controller.forecastReflection != null &&
                !controller.isEditingForecastReflection) ...[
              const SizedBox(height: 30),
              ForecastIntentionSection(
                intentionOptions: controller.intentionOptions,
                isLoading: controller.isLoadingFactors,
                selectedIntentionOption: controller.selectedIntentionOption,
                dailyIntention: controller.dailyIntention,
                hasCalendarChanged: controller.hasCalendarChanged,
                isEditingIntention: controller.isEditingIntention,
                onIntentionSelected: selectIntention,
                onReview: controller.reviewIntention,
                onKeepCurrent: keepCurrentIntention,
                onEdit: controller.editIntention,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> refreshFactorOptions() async {
    final succeeded = await controller.recalculateFactorOptions();
    if (!succeeded && mounted && widget.selectedTabNotifier.value == 1) {
      showMessage('Could not refresh today\'s calendar data.');
    }
  }

  void savePredictionAgreement(int response) {
    unawaited(
      runAction(
        controller.savePredictionAgreement(response),
        failureMessage: 'Could not save your response.',
      ),
    );
  }

  void revealForecastComparison() {
    unawaited(
      runAction(
        controller.revealForecastComparison(),
        failureMessage: 'Could not save your reflection.',
      ),
    );
  }

  void selectIntention(ForecastIntentionOption option) {
    unawaited(
      runAction(
        controller.selectIntention(option),
        failureMessage: 'Could not save today\'s intention.',
      ),
    );
  }

  void keepCurrentIntention() {
    unawaited(
      runAction(
        controller.keepCurrentIntention(),
        failureMessage: 'Could not update today\'s intention.',
      ),
    );
  }

  Future<void> runAction(
    Future<ForecastActionResult> action, {
    required String failureMessage,
  }) async {
    final result = await action;
    if (result == ForecastActionResult.failed && mounted) {
      showMessage(failureMessage);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
