import '../../prediction/models/daily_calendar_features.dart';
import '../../prediction/models/energy_model_feature.dart';
import '../models/daily_intention.dart';
import '../models/forecast_reflection_option.dart';
import 'future_availability_service.dart';

class ForecastAdjustmentCatalog {
  const ForecastAdjustmentCatalog({
    this.futureAvailabilityService = const FutureAvailabilityService(),
  });

  final FutureAvailabilityService futureAvailabilityService;

  DailyAdjustment outsideCalendarAdjustment(DateTime? breakStart) {
    if (breakStart == null) {
      return const DailyAdjustment(
        type: DailyAdjustmentType.keepTimeFree,
        label: 'Keep a little time free for yourself',
      );
    }

    return DailyAdjustment(
      type: DailyAdjustmentType.keepTimeFree,
      label: 'Keep ${_formatTime(breakStart)} free for yourself',
      startTime: breakStart,
      endTime: breakStart.add(const Duration(minutes: 10)),
    );
  }

  DailyAdjustment demandingAdjustment({
    required ForecastFactorType type,
    required DateTime? breakStart,
  }) {
    return switch (type) {
      ForecastFactorType.scheduledTime => const DailyAdjustment(
        type: DailyAdjustmentType.leaveBuffer,
        label: 'Shorten or move one lower-priority activity, if possible',
      ),
      ForecastFactorType.backToBackEvents => const DailyAdjustment(
        type: DailyAdjustmentType.leaveBuffer,
        label: 'Leave a short buffer between two activities',
      ),
      ForecastFactorType.longestGapBetweenActivities => const DailyAdjustment(
        type: DailyAdjustmentType.keepPlan,
        label:
            'Plan an easy way to restart after a long gap between activities',
      ),
      ForecastFactorType.longestScheduledBlock => const DailyAdjustment(
        type: DailyAdjustmentType.leaveBuffer,
        label: 'Split your longest scheduled block into two smaller parts',
      ),
      ForecastFactorType.focusTime => const DailyAdjustment(
        type: DailyAdjustmentType.keepPlan,
        label: 'Choose one main focus task and let the rest wait',
      ),
      ForecastFactorType.socialTime => const DailyAdjustment(
        type: DailyAdjustmentType.keepPlan,
        label: 'Keep one social activity a little shorter today',
      ),
      ForecastFactorType.lifeAdminTasks => const DailyAdjustment(
        type: DailyAdjustmentType.keepPlan,
        label: 'Choose one essential admin task and postpone another',
      ),
      ForecastFactorType.exercise => const DailyAdjustment(
        type: DailyAdjustmentType.keepPlan,
        label: 'Choose a shorter or gentler form of exercise today',
      ),
      _ =>
        breakStart == null
            ? const DailyAdjustment(
                type: DailyAdjustmentType.quietPause,
                label: 'Take a quiet 10-minute pause',
              )
            : DailyAdjustment(
                type: DailyAdjustmentType.quietPause,
                label:
                    'Take a quiet 10-minute pause at ${_formatTime(breakStart)}',
                startTime: breakStart,
                endTime: breakStart.add(const Duration(minutes: 10)),
              ),
    };
  }

  List<ForecastIntentionOption> generalOptions(
    List<FutureAvailabilitySlot> futureSlots,
  ) {
    final pauseSlot = futureAvailabilityService.firstSlotWithDuration(
      futureSlots,
      10,
    );
    const factor = ForecastFactor(
      type: ForecastFactorType.notSure,
      label: 'General wellbeing',
    );

    return [
      ForecastIntentionOption(
        sourceLabel: 'A general option',
        factor: factor,
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.quietPause,
          label: 'Take a quiet 10-minute pause',
          startTime: pauseSlot?.startTime,
          endTime: pauseSlot?.startTime.add(const Duration(minutes: 10)),
        ),
        isRefreshable: true,
      ),
      ForecastIntentionOption(
        sourceLabel: 'A general option',
        factor: factor,
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.shortWalk,
          label: 'Step outside for some fresh air',
          startTime: pauseSlot?.startTime,
          endTime: pauseSlot?.startTime.add(const Duration(minutes: 10)),
        ),
        isRefreshable: true,
      ),
      const ForecastIntentionOption(
        sourceLabel: 'A general option',
        factor: factor,
        adjustment: DailyAdjustment(
          type: DailyAdjustmentType.noticeEnergy,
          label: 'Do something you enjoy for 10 minutes',
        ),
        isRefreshable: true,
      ),
    ];
  }

  List<DailyAdjustment> supportiveAdjustments({
    required EnergyModelFeature feature,
    required DailyCalendarFeatures features,
    required List<FutureAvailabilitySlot> futureSlots,
    required List<FutureAvailabilitySlot> futureGapsBetweenActivities,
  }) {
    final fiveMinuteSlot = futureAvailabilityService.firstSlotWithDuration(
      futureSlots,
      5,
    );
    final tenMinuteSlot = futureAvailabilityService.firstSlotWithDuration(
      futureSlots,
      10,
    );
    final fifteenMinuteSlot = futureAvailabilityService.firstSlotWithDuration(
      futureSlots,
      15,
    );
    final twentyMinuteSlot = futureAvailabilityService.firstSlotWithDuration(
      futureSlots,
      20,
    );
    final futureGap = futureAvailabilityService.firstSlotWithDuration(
      futureGapsBetweenActivities,
      10,
    );

    return switch (feature) {
      EnergyModelFeature.busyMinutes => const [
        DailyAdjustment(
          type: DailyAdjustmentType.keepPlan,
          label:
              'Follow today’s schedule as planned, if it still feels manageable',
        ),
        DailyAdjustment(
          type: DailyAdjustmentType.keepPlan,
          label: 'Keep one manageable part of today’s schedule as planned',
        ),
      ],
      EnergyModelFeature.backToBackEventCount => const [
        DailyAdjustment(
          type: DailyAdjustmentType.keepPlan,
          label: 'Stay with today’s flow if it feels comfortable',
        ),
        DailyAdjustment(
          type: DailyAdjustmentType.keepPlan,
          label: 'Keep the transition between two activities simple',
        ),
      ],
      EnergyModelFeature.longestGapBetweenActivitiesMinutes => [
        const DailyAdjustment(
          type: DailyAdjustmentType.keepPlan,
          label: 'Keep a long gap between activities open',
        ),
        if (futureGap != null)
          DailyAdjustment(
            type: DailyAdjustmentType.quietPause,
            label: 'Have a quiet 10-minute pause between activities',
            startTime: futureGap.startTime,
            endTime: futureGap.startTime.add(const Duration(minutes: 10)),
          ),
        if (futureGap != null)
          DailyAdjustment(
            type: DailyAdjustmentType.screenBreak,
            label: 'Step away from your screen for 10 minutes',
            startTime: futureGap.startTime,
            endTime: futureGap.startTime.add(const Duration(minutes: 10)),
          ),
      ],
      EnergyModelFeature.maxConsecutiveBlockMinutes => const [
        DailyAdjustment(
          type: DailyAdjustmentType.keepPlan,
          label:
              'Let your longest scheduled block run as planned, if it feels manageable',
        ),
        DailyAdjustment(
          type: DailyAdjustmentType.focusSession,
          label: 'Protect part of your longest block from interruptions',
        ),
      ],
      EnergyModelFeature.focusMinutes => [
        if (features.focusMinutes > 0)
          const DailyAdjustment(
            type: DailyAdjustmentType.keepPlan,
            label: 'Let your planned focus time stay uninterrupted',
          ),
        if (twentyMinuteSlot != null)
          DailyAdjustment(
            type: DailyAdjustmentType.focusSession,
            label: 'Set aside 20 quiet minutes for one task',
            startTime: twentyMinuteSlot.startTime,
            endTime: twentyMinuteSlot.startTime.add(
              const Duration(minutes: 20),
            ),
          ),
        const DailyAdjustment(
          type: DailyAdjustmentType.focusSession,
          label: 'Put distractions aside for one focus session',
        ),
      ],
      EnergyModelFeature.socialMinutes => [
        if (features.socialMinutes > 0)
          const DailyAdjustment(
            type: DailyAdjustmentType.keepPlan,
            label: 'Make time for the social activity already in your schedule',
          ),
        const DailyAdjustment(
          type: DailyAdjustmentType.socialMoment,
          label: 'Message someone you enjoy talking to',
        ),
        const DailyAdjustment(
          type: DailyAdjustmentType.socialMoment,
          label: 'Have a short chat with someone you like',
        ),
      ],
      EnergyModelFeature.lifeAdminMinutes => [
        if (features.lifeAdminMinutes > 0)
          const DailyAdjustment(
            type: DailyAdjustmentType.keepPlan,
            label: 'Stick with one manageable admin task you have planned',
          ),
        const DailyAdjustment(
          type: DailyAdjustmentType.lifeAdminTask,
          label: 'Finish one small practical task',
        ),
        if (tenMinuteSlot != null)
          DailyAdjustment(
            type: DailyAdjustmentType.lifeAdminTask,
            label: 'Spend 10 minutes on one manageable admin task',
            startTime: tenMinuteSlot.startTime,
            endTime: tenMinuteSlot.startTime.add(const Duration(minutes: 10)),
          ),
      ],
      EnergyModelFeature.exerciseMinutes => [
        if (features.exerciseMinutes > 0)
          const DailyAdjustment(
            type: DailyAdjustmentType.keepPlan,
            label:
                'Follow through with your planned exercise, if it feels right',
          ),
        if (fifteenMinuteSlot != null)
          DailyAdjustment(
            type: DailyAdjustmentType.shortWalk,
            label: 'Take a short walk',
            startTime: fifteenMinuteSlot.startTime,
            endTime: fifteenMinuteSlot.startTime.add(
              const Duration(minutes: 15),
            ),
          ),
        if (fiveMinuteSlot != null)
          DailyAdjustment(
            type: DailyAdjustmentType.stretch,
            label: 'Stretch for five minutes',
            startTime: fiveMinuteSlot.startTime,
            endTime: fiveMinuteSlot.startTime.add(const Duration(minutes: 5)),
          ),
      ],
    };
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
