import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/energy_mood_badge.dart';
import '../../../shared/widgets/primary_tab_app_bar.dart';
import '../../check_in/models/daily_reflection.dart';
import '../../check_in/screens/daily_reflection_screen.dart';
import '../../check_in/services/daily_reflection_service.dart';
import '../../forecast/models/daily_intention.dart';
import '../../forecast/services/daily_intention_service.dart';
import '../models/calendar_event.dart';
import '../models/calendar_event_category.dart';
import '../models/calendar_sync_status.dart';
import '../models/event_energy_impact.dart';
import '../models/manual_calendar_event_input.dart';
import '../services/calendar_event_collection_service.dart';
import '../services/calendar_event_write_queue.dart';
import '../services/calendar_sync_service.dart';
import '../services/google_calendar_service.dart';
import '../../prediction/models/daily_prediction.dart';
import '../../prediction/services/daily_prediction_service.dart';
import '../../prediction/services/personalised_model_update_service.dart';
import '../widgets/event_card.dart';
import '../widgets/forecast_reveal_card.dart';
import 'manual_event_editor_screen.dart';

part '../widgets/calendar_day_widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.googleCalendarService,
    required this.calendarEventCollectionService,
    required this.calendarSyncService,
    required this.dailyReflectionService,
    required this.dailyIntentionService,
    required this.dailyPredictionService,
    required this.personalisedModelUpdateService,
    required this.onCalendarSynced,
    required this.onOpenForecast,
  });

  final GoogleCalendarService googleCalendarService;
  final CalendarEventCollectionService calendarEventCollectionService;
  final CalendarSyncService calendarSyncService;
  final DailyReflectionService dailyReflectionService;
  final DailyIntentionService dailyIntentionService;
  final DailyPredictionService dailyPredictionService;
  final PersonalisedModelUpdateService personalisedModelUpdateService;
  // trigger recalculation in Forecast after today's events are synced
  final VoidCallback onCalendarSynced;
  final VoidCallback onOpenForecast;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int? dailyEnergyScore;
  DailyReflection? dailyReflection;
  List<CalendarEvent> events = [];
  bool isLoadingEvents = false;
  bool isRevealingPrediction = false;
  late DateTime selectedDay;
  DateTime? lastSyncedAt;
  CalendarSyncStatus? calendarSyncStatus;
  DailyPrediction? dailyPrediction;
  String? calendarSyncMessage;
  int selectedDayGeneration = 0;
  int calendarSyncGeneration = 0;
  final Map<String, CalendarEvent> persistedEventStates = {};
  final Map<String, int> eventUpdateGenerations = {};
  late final CalendarEventWriteQueue eventWriteQueue;

  @override
  void initState() {
    super.initState();

    selectedDay = dateOnly(DateTime.now());
    eventWriteQueue = CalendarEventWriteQueue(
      saveEvent: widget.calendarEventCollectionService.saveEventChanges,
    );
    // initialise calendar service in the background, not blocking the UI
    unawaited(_initializeGoogleCalendar());
    // load saved events first so Today won't be empty when reopen
    unawaited(
      loadSelectedDayData(day: selectedDay, generation: selectedDayGeneration),
    );
    // restore today's daily reflection if it was already saved
    unawaited(
      loadDailyReflectionForSelectedDay(
        day: selectedDay,
        generation: selectedDayGeneration,
      ),
    );
  }

  Future<void> _initializeGoogleCalendar() async {
    try {
      await widget.googleCalendarService.initialize();
    } catch (error) {
      debugPrint('Could not initialize Google Calendar: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryTabAppBar(
        title: isSelectedDayToday ? 'Today' : selectedDayTitle,
        subtitle: calendarStatusText,
        actions: [
          IconButton(
            tooltip: 'Add activity',
            onPressed: openManualEventEditor,
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        top: false,
        // pull down to refresh google calendar events
        child: RefreshIndicator(
          onRefresh: loadSelectedDayEvents,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
            children: [
              _WeekSelector(selectedDay: selectedDay, onDaySelected: selectDay),
              if (isSelectedDayToday) ...[
                const SizedBox(height: 28),
                ForecastRevealCard(
                  hasSuccessfulSync: hasCalendarInput,
                  hasPrediction: dailyPrediction != null,
                  isLoading: isRevealingPrediction,
                  uncategorizedEventCount: uncategorizedEventCount,
                  onTap: revealOrOpenForecast,
                ),
                const SizedBox(height: 18),
              ] else
                const SizedBox(height: 28),
              if (calendarSyncMessage != null) ...[
                _CalendarSyncMessageCard(message: calendarSyncMessage!),
                const SizedBox(height: 18),
              ],
              if (events.isEmpty)
                _EmptyCalendarCard(
                  hasSuccessfulSync: calendarSyncStatus != null,
                )
              else
                ...events.map((event) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: EventCard(
                      event: event,
                      onCategorySelected: (category) =>
                          saveEventCategory(event, category),
                      onEnergyImpactSelected: (impact) =>
                          saveEventEnergyImpact(event, impact),
                      onEditEvent: event.source == CalendarEventSource.manual
                          ? () => openManualEventEditor(event: event)
                          : null,
                      onDeleteEvent: event.source == CalendarEventSource.manual
                          ? () => confirmDeleteManualEvent(event)
                          : null,
                    ),
                  );
                }),
              if (!isSelectedDayInFuture) ...[
                if (events.isEmpty) const SizedBox(height: 18),
                _DailyReflectionCard(
                  energyScore: dailyEnergyScore,
                  onTap: openDailyReflection,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String get calendarStatusText {
    if (isLoadingEvents) {
      return 'Syncing calendar...';
    }

    if (lastSyncedAt != null) {
      return 'Last synced ${formatTime(lastSyncedAt!)}';
    }

    if (events.isNotEmpty) {
      if (calendarSyncStatus == null && hasManualEvents) {
        return 'Manual activities shown';
      }
      return 'Saved events shown';
    }

    return 'Pull down to sync calendar';
  }

  bool get isSelectedDayToday => isSameDay(selectedDay, DateTime.now());

  bool get isSelectedDayInFuture =>
      selectedDay.isAfter(dateOnly(DateTime.now()));

  int get uncategorizedEventCount =>
      events.where((event) => event.category == null).length;

  bool get hasManualEvents =>
      events.any((event) => event.source == CalendarEventSource.manual);

  bool get hasCalendarInput => calendarSyncStatus != null || hasManualEvents;

  Future<void> selectDay(DateTime day) async {
    final normalizedDay = dateOnly(day);
    if (isSameDay(selectedDay, normalizedDay)) return;
    final generation = ++selectedDayGeneration;
    calendarSyncGeneration++;

    setState(() {
      selectedDay = normalizedDay;
      events = [];
      isLoadingEvents = false;
      dailyReflection = null;
      dailyEnergyScore = null;
      lastSyncedAt = null;
      calendarSyncStatus = null;
      dailyPrediction = null;
      calendarSyncMessage = null;
    });

    await Future.wait([
      loadSelectedDayData(day: normalizedDay, generation: generation),
      loadDailyReflectionForSelectedDay(
        day: normalizedDay,
        generation: generation,
      ),
    ]);
  }

  Future<void> loadSelectedDayEvents() async {
    if (isLoadingEvents) return;
    final requestedDay = selectedDay;
    final dayGeneration = selectedDayGeneration;
    final syncGeneration = ++calendarSyncGeneration;
    final existingEvents = List<CalendarEvent>.from(events);
    setState(() {
      isLoadingEvents = true;
      calendarSyncMessage = null;
    });

    try {
      final loadedEvents = await widget.googleCalendarService
          .loadConnectedEventsForDay(requestedDay);
      final refreshedEvents = await widget.calendarEventCollectionService
          .prepareRefreshedEvents(
            refreshedSyncedEvents: loadedEvents,
            existingEvents: existingEvents,
          );
      final syncedAt = DateTime.now();

      if (_isCurrentDayRequest(requestedDay, dayGeneration)) {
        setState(() {
          events = refreshedEvents.allEvents;
        });
      }

      try {
        await widget.calendarEventCollectionService.replaceSyncedEventsForDay(
          requestedDay,
          refreshedEvents.syncedEvents,
        );
        await widget.calendarSyncService.saveSuccessfulSync(
          day: requestedDay,
          source: CalendarEventSource.google,
          syncedAt: syncedAt,
          eventCount: refreshedEvents.syncedEvents.length,
        );
        if (_isCurrentSyncRequest(
          requestedDay,
          dayGeneration,
          syncGeneration,
        )) {
          setState(() {
            lastSyncedAt = syncedAt;
            calendarSyncStatus = CalendarSyncStatus(
              day: requestedDay,
              source: CalendarEventSource.google,
              lastSuccessfulSyncAt: syncedAt,
              eventCount: refreshedEvents.syncedEvents.length,
            );
            calendarSyncMessage = null;
          });
        }
        // recalculate Forecast only after today's refreshed events are saved
        if (mounted && isSameDay(requestedDay, DateTime.now())) {
          widget.onCalendarSynced();
        }
      } catch (error) {
        if (!_isCurrentSyncRequest(
          requestedDay,
          dayGeneration,
          syncGeneration,
        )) {
          return;
        }
        debugPrint('Could not cache calendar events: $error');
        showCalendarMessage(
          'Calendar events loaded, but could not be saved on this device.',
        );
      }
    } catch (error) {
      if (!_isCurrentSyncRequest(requestedDay, dayGeneration, syncGeneration)) {
        return;
      }
      debugPrint('Google Calendar sync failed: $error');
      final message = calendarLoadErrorMessage(error);
      setState(() {
        calendarSyncMessage = message;
      });
      showCalendarMessage(message);
    } finally {
      if (mounted && syncGeneration == calendarSyncGeneration) {
        setState(() {
          isLoadingEvents = false;
        });
      }
    }
  }

  Future<void> loadSelectedDayData({
    required DateTime day,
    required int generation,
  }) async {
    try {
      final cachedEvents = await widget.calendarEventCollectionService
          .loadEventsForDay(day);
      final syncStatus = await widget.calendarSyncService
          .loadLatestSuccessfulSyncForDay(day);
      final savedPrediction = await widget.dailyPredictionService
          .loadInitialPredictionForDay(day);

      if (!_isCurrentDayRequest(day, generation)) return;
      setState(() {
        events = cachedEvents;
        lastSyncedAt = syncStatus?.lastSuccessfulSyncAt;
        calendarSyncStatus = syncStatus;
        dailyPrediction = savedPrediction;
      });
    } catch (error) {
      if (!_isCurrentDayRequest(day, generation)) return;
      debugPrint('Could not load saved calendar events: $error');
      showCalendarMessage('Could not load saved calendar events.');
    }
  }

  Future<void> revealOrOpenForecast() async {
    // require a current sync and complete categories before opening Forecast
    if (!hasCalendarInput) {
      showCalendarMessage(
        'Sync this day\'s calendar or add an activity before revealing your forecast.',
      );
      return;
    }

    if (uncategorizedEventCount > 0) {
      final activityText = uncategorizedEventCount == 1
          ? '1 activity needs'
          : '$uncategorizedEventCount activities need';
      showCalendarMessage(
        '$activityText a category. Choose a category or Not sure before '
        'revealing today\'s forecast.',
      );
      return;
    }

    if (dailyPrediction != null) {
      if (isSelectedDayToday) {
        widget.onOpenForecast();
      } else {
        showCalendarMessage('Forecast currently shows today\'s prediction.');
      }
      return;
    }

    if (isRevealingPrediction) return;
    setState(() {
      isRevealingPrediction = true;
    });

    try {
      final prediction = await widget.dailyPredictionService
          .loadOrCreateInitialPrediction(day: selectedDay, events: events);

      if (!mounted) return;
      setState(() {
        dailyPrediction = prediction;
      });
      if (isSelectedDayToday) {
        widget.onOpenForecast();
      } else {
        showCalendarMessage('Prediction saved for the selected day.');
      }
    } on EnergyModelUnavailableException catch (error) {
      if (!mounted) return;
      debugPrint('Daily prediction failed: $error');
      showCalendarMessage(
        'Cal is not ready yet. Review your initial questionnaire '
        'in Profile before revealing today\'s forecast.',
      );
    } catch (error) {
      if (!mounted) return;
      debugPrint('Daily prediction failed: $error');
      showCalendarMessage(
        'Could not reveal this day\'s forecast. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isRevealingPrediction = false;
        });
      }
    }
  }

  Future<void> saveEventCategory(
    CalendarEvent event,
    CalendarEventCategory category,
  ) {
    return updateEvent(event.copyWith(category: category));
  }

  Future<void> saveEventEnergyImpact(
    CalendarEvent event,
    EventEnergyImpact impact,
  ) {
    return updateEvent(event.copyWith(energyImpact: impact));
  }

  Future<void> updateEvent(CalendarEvent? updatedEvent) async {
    if (updatedEvent == null) return;

    final day = selectedDay;
    final dayGeneration = selectedDayGeneration;
    final eventKey = eventWriteQueue.identityKey(updatedEvent);
    final index = events.indexWhere((item) => item.id == updatedEvent.id);
    final previousEvent = index == -1 ? null : events[index];
    final updateGeneration = (eventUpdateGenerations[eventKey] ?? 0) + 1;
    eventUpdateGenerations[eventKey] = updateGeneration;
    if (previousEvent != null) {
      persistedEventStates.putIfAbsent(eventKey, () => previousEvent);
    }

    setState(() {
      if (index != -1) {
        events[index] = updatedEvent;
      }
    });

    try {
      await eventWriteQueue.save(updatedEvent);
      persistedEventStates[eventKey] = updatedEvent;
    } catch (error) {
      if (!_isCurrentDayRequest(day, dayGeneration) ||
          eventUpdateGenerations[eventKey] != updateGeneration) {
        return;
      }
      debugPrint('Could not save event changes: $error');
      final persistedEvent = persistedEventStates[eventKey];
      if (persistedEvent != null) {
        setState(() {
          final currentIndex = events.indexWhere(
            (item) => item.id == persistedEvent.id,
          );
          if (currentIndex != -1) {
            events[currentIndex] = persistedEvent;
          }
        });
      }
      showCalendarMessage('Could not save event changes. Please try again.');
    } finally {
      if (eventUpdateGenerations[eventKey] == updateGeneration) {
        persistedEventStates.remove(eventKey);
        eventUpdateGenerations.remove(eventKey);
      }
    }
  }

  Future<void> openManualEventEditor({CalendarEvent? event}) async {
    final input = await Navigator.of(context).push<ManualCalendarEventInput>(
      MaterialPageRoute(
        builder: (context) =>
            ManualEventEditorScreen(day: selectedDay, initialEvent: event),
      ),
    );
    if (input == null) return;

    try {
      if (event == null) {
        final createdEvent = await widget.calendarEventCollectionService
            .createManualEvent(input);
        if (!mounted) return;
        setState(() {
          events = widget.calendarEventCollectionService.sortEvents([
            ...events,
            createdEvent,
          ]);
        });
      } else {
        final updatedEvent = event.copyWith(
          title: input.title,
          startTime: input.startTime,
          endTime: input.endTime,
          category: input.category,
        );
        await widget.calendarEventCollectionService.saveEventChanges(
          updatedEvent,
        );
        if (!mounted) return;
        setState(() {
          events = widget.calendarEventCollectionService.sortEvents([
            for (final item in events)
              if (item.id == updatedEvent.id) updatedEvent else item,
          ]);
        });
      }
      notifyTodayEventsChanged();
    } catch (error) {
      if (!mounted) return;
      showCalendarMessage('Could not save this activity. Please try again.');
    }
  }

  Future<void> confirmDeleteManualEvent(CalendarEvent event) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete activity?'),
        content: Text('Remove “${event.title}” from Cal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;

    try {
      await widget.calendarEventCollectionService.deleteManualEvent(event);
      if (!mounted) return;
      setState(() {
        events = events.where((item) => item.id != event.id).toList();
      });
      notifyTodayEventsChanged();
    } catch (error) {
      if (!mounted) return;
      showCalendarMessage('Could not delete this activity. Please try again.');
    }
  }

  void notifyTodayEventsChanged() {
    if (isSelectedDayToday) {
      widget.onCalendarSynced();
    }
  }

  // Forecast may save an intention after Today was first opened
  Future<void> openDailyReflection() async {
    DailyIntention? intention;
    try {
      intention = await widget.dailyIntentionService.loadIntentionForDay(
        selectedDay,
      );
    } catch (error) {
      if (!mounted) return;
      debugPrint('Could not load the daily intention: $error');
      showCalendarMessage('Could not open Daily Reflection. Please try again.');
      return;
    }
    if (!mounted) return;
    final savedReflection = await Navigator.of(context).push<DailyReflection>(
      MaterialPageRoute(
        builder: (context) => DailyReflectionScreen(
          day: selectedDay,
          initialReflection: dailyReflection,
          intention: intention,
          events: events,
          onEventUpdated: updateEvent,
        ),
      ),
    );

    if (savedReflection == null) return;

    try {
      await widget.dailyReflectionService.saveReflectionForDay(
        selectedDay,
        savedReflection,
      );
    } catch (error) {
      if (!mounted) return;
      debugPrint('Could not save daily reflection: $error');
      showCalendarMessage('Could not save Daily Reflection. Please try again.');
      return;
    }

    if (!mounted) return;
    setState(() {
      dailyReflection = savedReflection;
      dailyEnergyScore = savedReflection.energyScore;
    });

    try {
      final updateResult = await widget.personalisedModelUpdateService
          .updateModelIfReady();
      debugPrint(
        'Personalised model update status: ${updateResult.status.name} '
        '(${updateResult.sampleCount} samples)',
      );
    } catch (error) {
      debugPrint('Personalised model update failed: $error');
    }
  }

  Future<void> loadDailyReflectionForSelectedDay({
    required DateTime day,
    required int generation,
  }) async {
    try {
      final savedReflection = await widget.dailyReflectionService
          .loadReflectionForDay(day);

      if (!_isCurrentDayRequest(day, generation) || savedReflection == null) {
        return;
      }
      setState(() {
        dailyReflection = savedReflection;
        dailyEnergyScore = savedReflection.energyScore;
      });
    } catch (error) {
      if (!_isCurrentDayRequest(day, generation)) return;
      debugPrint('Could not load daily reflection: $error');
      showCalendarMessage('Could not load Daily Reflection.');
    }
  }

  bool _isCurrentDayRequest(DateTime day, int generation) {
    return mounted &&
        generation == selectedDayGeneration &&
        isSameDay(day, selectedDay);
  }

  bool _isCurrentSyncRequest(
    DateTime day,
    int dayGeneration,
    int syncGeneration,
  ) {
    return syncGeneration == calendarSyncGeneration &&
        _isCurrentDayRequest(day, dayGeneration);
  }

  void showCalendarMessage(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
      );
  }

  String calendarLoadErrorMessage(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('invalid_grant') ||
        message.contains('token has been expired or revoked')) {
      return 'Google Calendar needs to be reconnected in Profile.';
    }

    if (message.contains('not connected') ||
        message.contains('sign in') ||
        message.contains('authentication') ||
        message.contains('authorization') ||
        message.contains('access was denied')) {
      return 'Connect Google Calendar in Profile to sync events.';
    }

    return 'Could not sync Google Calendar. Please try again.';
  }

  String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  DateTime dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String get selectedDayTitle {
    return '${monthLabel(selectedDay.month)} ${selectedDay.day}';
  }

  String monthLabel(int month) {
    return switch (month) {
      1 => 'Jan',
      2 => 'Feb',
      3 => 'Mar',
      4 => 'Apr',
      5 => 'May',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Aug',
      9 => 'Sep',
      10 => 'Oct',
      11 => 'Nov',
      12 => 'Dec',
      _ => '',
    };
  }
}
