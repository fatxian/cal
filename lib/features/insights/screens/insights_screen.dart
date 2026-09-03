import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/energy_mood.dart';
import '../../../shared/widgets/primary_tab_app_bar.dart';
import '../../prediction/widgets/model_learning_progress.dart';
import '../models/weekly_insight_summary.dart';
import '../services/weekly_insight_service.dart';
import '../utils/insight_cycle.dart';

part '../widgets/insights_overview.dart';
part '../widgets/insights_energy_history.dart';
part '../widgets/insights_intention_widgets.dart';
part '../widgets/insights_forecast_comparison.dart';
part '../widgets/insights_activity_energy.dart';
part '../widgets/insights_section_widgets.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({
    super.key,
    required this.weeklyInsightService,
    required this.selectedTabNotifier,
    this.onWeeklyViewed,
  });

  final WeeklyInsightService weeklyInsightService;
  final ValueListenable<int> selectedTabNotifier;
  final VoidCallback? onWeeklyViewed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryTabAppBar(title: 'Insights'),
      body: SafeArea(
        top: false,
        child: _InsightsContent(
          weeklyInsightService: weeklyInsightService,
          selectedTabNotifier: selectedTabNotifier,
          onWeeklyViewed: onWeeklyViewed,
        ),
      ),
    );
  }
}

class _InsightsContent extends StatefulWidget {
  const _InsightsContent({
    required this.weeklyInsightService,
    required this.selectedTabNotifier,
    this.onWeeklyViewed,
  });

  final WeeklyInsightService weeklyInsightService;
  final ValueListenable<int> selectedTabNotifier;
  final VoidCallback? onWeeklyViewed;

  @override
  State<_InsightsContent> createState() => _InsightsContentState();
}

class _InsightsContentState extends State<_InsightsContent>
    with SingleTickerProviderStateMixin {
  late DateTime selectedWeekStart;
  late Future<WeeklyInsightSummary> summaryFuture;
  late final TabController insightTabController;
  DateTime? insightCycleAnchor;
  DateTime? currentCycleStart;

  @override
  void initState() {
    super.initState();
    insightTabController = TabController(length: 2, vsync: this)
      ..addListener(_handleInsightTabChanged);
    selectedWeekStart = _dateOnly(DateTime.now());
    summaryFuture = _loadInitialSummary();
    widget.selectedTabNotifier.addListener(_handleSelectedTabChanged);
  }

  @override
  void didUpdateWidget(covariant _InsightsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTabNotifier != widget.selectedTabNotifier) {
      oldWidget.selectedTabNotifier.removeListener(_handleSelectedTabChanged);
      widget.selectedTabNotifier.addListener(_handleSelectedTabChanged);
    }
  }

  @override
  void dispose() {
    widget.selectedTabNotifier.removeListener(_handleSelectedTabChanged);
    insightTabController
      ..removeListener(_handleInsightTabChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: TabBar(
            controller: insightTabController,
            labelColor: AppColors.forestGreen,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: textTheme.titleMedium?.copyWith(fontSize: 17),
            unselectedLabelStyle: textTheme.titleMedium?.copyWith(fontSize: 17),
            indicatorColor: AppColors.forestGreen,
            indicatorWeight: 3,
            dividerColor: AppColors.border,
            tabs: const [
              Tab(text: 'Weekly'),
              Tab(text: 'All time'),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<WeeklyInsightSummary>(
            future: summaryFuture,
            builder: (context, snapshot) {
              final summary = snapshot.data;

              if (snapshot.hasError) {
                return _InsightsLoadError(onRetry: _retryLoadingSummary);
              }

              if (insightTabController.index == 1) {
                return ListView(
                  key: const PageStorageKey('all-time-insights'),
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
                  children: [
                    if (summary == null)
                      const Center(child: CircularProgressIndicator())
                    else
                      _AllTimeInsights(summary: summary),
                  ],
                );
              }

              return ListView(
                key: const PageStorageKey('weekly-insights'),
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
                children: [
                  _WeekSelector(
                    weekStart: selectedWeekStart,
                    onPrevious:
                        insightCycleAnchor != null &&
                            selectedWeekStart.isAfter(insightCycleAnchor!)
                        ? () => changeWeek(-1)
                        : null,
                    onNext:
                        currentCycleStart != null &&
                            selectedWeekStart.isBefore(currentCycleStart!)
                        ? () => changeWeek(1)
                        : null,
                  ),
                  const SizedBox(height: 18),
                  if (summary == null)
                    const Center(child: CircularProgressIndicator())
                  else
                    _WeeklyInsights(summary: summary),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleInsightTabChanged() {
    if (insightTabController.indexIsChanging || !mounted) return;
    if (insightTabController.index == 0 &&
        widget.selectedTabNotifier.value == 2) {
      widget.onWeeklyViewed?.call();
    }
    setState(() {});
  }

  void changeWeek(int offset) {
    setState(() {
      selectedWeekStart = selectedWeekStart.add(Duration(days: offset * 7));
      summaryFuture = _loadSummary();
    });
  }

  void _handleSelectedTabChanged() {
    if (widget.selectedTabNotifier.value != 2 || !mounted) return;
    if (insightTabController.index == 0) {
      widget.onWeeklyViewed?.call();
    }

    setState(() {
      summaryFuture = _loadSummary();
    });
  }

  Future<WeeklyInsightSummary> _loadSummary() {
    return widget.weeklyInsightService.loadSummaryForWeek(selectedWeekStart);
  }

  Future<WeeklyInsightSummary> _loadInitialSummary() async {
    final anchor = await widget.weeklyInsightService.loadInsightCycleAnchor();
    final currentStart = startOfInsightCycle(
      anchor: anchor,
      day: DateTime.now(),
    );
    insightCycleAnchor = anchor;
    currentCycleStart = currentStart;
    selectedWeekStart = currentStart;
    return _loadSummary();
  }

  void _retryLoadingSummary() {
    setState(() {
      summaryFuture = insightCycleAnchor == null
          ? _loadInitialSummary()
          : _loadSummary();
    });
  }

  DateTime _dateOnly(DateTime day) => DateTime(day.year, day.month, day.day);
}

class _InsightsLoadError extends StatelessWidget {
  const _InsightsLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Could not load Insights.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
