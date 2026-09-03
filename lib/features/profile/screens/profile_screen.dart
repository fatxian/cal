import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/notifications/daily_notification_preference_service.dart';
import '../../../core/notifications/daily_notification_preferences.dart';
import '../../../core/notifications/daily_notification_service.dart';
import '../../../shared/widgets/cupertino_time_picker_sheet.dart';
import '../../../shared/widgets/primary_tab_app_bar.dart';
import '../../calendar/services/google_calendar_service.dart';
import '../../onboarding/screens/onboarding_questionnaire_screen.dart';
import '../../onboarding/services/initial_setup_service.dart';
import '../../prediction/services/debug_prediction_data_service.dart';
import '../../research/services/research_data_export_service.dart';
import '../controllers/profile_notification_controller.dart';
import '../services/research_data_share_service.dart';
import '../widgets/profile_cards.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.googleCalendarService,
    required this.initialSetupService,
    required this.debugPredictionDataService,
    required this.notificationPreferenceService,
    required this.notificationService,
    required this.researchDataExportService,
    required this.selectedTabNotifier,
  });

  final GoogleCalendarService googleCalendarService;
  final InitialSetupService initialSetupService;
  final DebugPredictionDataService debugPredictionDataService;
  final DailyNotificationPreferenceService notificationPreferenceService;
  final DailyNotificationService notificationService;
  final ResearchDataExportService researchDataExportService;
  final ValueListenable<int> selectedTabNotifier;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StreamSubscription<GoogleSignInAuthenticationEvent>?
  authenticationSubscription;
  GoogleSignInAccount? currentUser;
  bool isLoading = false;
  bool needsReconnect = false;
  bool isUpdatingDebugData = false;
  bool isExportingResearchData = false;
  String statusMessage = 'Not connected to Google Calendar yet.';
  String? errorMessage;
  late final ProfileNotificationController notificationController;
  late final ResearchDataShareService researchDataShareService;

  @override
  void initState() {
    super.initState();

    notificationController = ProfileNotificationController(
      preferenceService: widget.notificationPreferenceService,
      notificationService: widget.notificationService,
    )..addListener(handleNotificationSettingsChanged);
    researchDataShareService = ResearchDataShareService(
      exportService: widget.researchDataExportService,
    );

    unawaited(initializeGoogleCalendar());
    authenticationSubscription = widget
        .googleCalendarService
        .authenticationEvents
        .listen(handleAuthenticationEvent);
    authenticationSubscription?.onError(handleAuthenticationError);
    widget.googleCalendarService.reconnectionState.addListener(
      handleReconnectionStateChanged,
    );
    widget.selectedTabNotifier.addListener(handleSelectedTabChanged);
    unawaited(notificationController.load());
  }

  Future<void> initializeGoogleCalendar() async {
    try {
      await widget.googleCalendarService.initialize();
    } catch (error) {
      debugPrint('Could not initialize Google Calendar: $error');
    }
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTabNotifier != widget.selectedTabNotifier) {
      oldWidget.selectedTabNotifier.removeListener(handleSelectedTabChanged);
      widget.selectedTabNotifier.addListener(handleSelectedTabChanged);
    }
  }

  @override
  void dispose() {
    final subscription = authenticationSubscription;
    if (subscription != null) {
      unawaited(subscription.cancel());
    }
    widget.googleCalendarService.reconnectionState.removeListener(
      handleReconnectionStateChanged,
    );
    widget.selectedTabNotifier.removeListener(handleSelectedTabChanged);
    notificationController
      ..removeListener(handleNotificationSettingsChanged)
      ..dispose();
    super.dispose();
  }

  void handleNotificationSettingsChanged() {
    if (mounted) setState(() {});
  }

  void handleSelectedTabChanged() {
    if (widget.selectedTabNotifier.value == 3 && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldReconnect =
        needsReconnect || widget.googleCalendarService.requiresReconnection;

    return Scaffold(
      appBar: const PrimaryTabAppBar(title: 'Profile'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
          children: [
            OnboardingSetupCard(onTap: openEnergySetup),
            const SizedBox(height: 18),
            NotificationSettingsCard(
              preferences: notificationController.preferences,
              isLoading: notificationController.isLoading,
              isUpdating: notificationController.isUpdating,
              onMorningEnabledChanged: (enabled) {
                unawaited(
                  saveNotificationPreferences(
                    notificationController.preferences.copyWith(
                      morningEnabled: enabled,
                    ),
                  ),
                );
              },
              onEveningEnabledChanged: (enabled) {
                unawaited(
                  saveNotificationPreferences(
                    notificationController.preferences.copyWith(
                      eveningEnabled: enabled,
                    ),
                  ),
                );
              },
              onMorningTimeTap: () {
                unawaited(selectNotificationTime(isMorning: true));
              },
              onEveningTimeTap: () {
                unawaited(selectNotificationTime(isMorning: false));
              },
            ),
            const SizedBox(height: 18),
            ResearchDataExportCard(
              isExporting: isExportingResearchData,
              onExport: exportResearchData,
            ),
            if (kDebugMode) ...[
              const SizedBox(height: 18),
              DebugPredictionDataCard(
                isLoading: isUpdatingDebugData,
                onGenerate: generateDebugPredictionData,
                onClear: clearDebugPredictionData,
              ),
            ],
            const SizedBox(height: 18),
            GoogleCalendarConnectionCard(
              isLoading: isLoading,
              isConnected: currentUser != null,
              shouldReconnect: shouldReconnect,
              statusMessage: statusMessage,
              errorMessage: errorMessage,
              onConnect: () =>
                  connectAndLoadTodayEvents(forceReconnect: shouldReconnect),
              onSignOut: signOut,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openEnergySetup() async {
    final savedAnswers = await widget.initialSetupService
        .loadQuestionnaireAnswers();
    if (!mounted) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => OnboardingQuestionnaireScreen(
          initialAnswers: savedAnswers,
          onCompleted: (answers) async {
            await widget.initialSetupService.saveQuestionnaireAnswers(answers);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
      ),
    );

    if (!mounted) return;
    setState(() {});
  }

  Future<void> selectNotificationTime({required bool isMorning}) async {
    final preferences = notificationController.preferences;
    final initialTime = TimeOfDay(
      hour: isMorning ? preferences.morningHour : preferences.eveningHour,
      minute: isMorning ? preferences.morningMinute : preferences.eveningMinute,
    );
    final selectedTime = await showCupertinoTimePickerSheet(
      context: context,
      title: isMorning
          ? 'Morning forecast reminder'
          : 'Evening reflection reminder',
      initialTime: initialTime,
    );
    if (selectedTime == null || !mounted) return;

    final updatedPreferences = isMorning
        ? preferences.copyWith(
            morningHour: selectedTime.hour,
            morningMinute: selectedTime.minute,
          )
        : preferences.copyWith(
            eveningHour: selectedTime.hour,
            eveningMinute: selectedTime.minute,
          );
    await saveNotificationPreferences(updatedPreferences);
  }

  Future<void> saveNotificationPreferences(
    DailyNotificationPreferences preferences,
  ) async {
    final result = await notificationController.save(preferences);
    if (!mounted) return;

    final message = switch (result) {
      NotificationPreferenceUpdateResult.permissionDenied =>
        'Notifications are disabled in your device settings.',
      NotificationPreferenceUpdateResult.failed =>
        'Could not update notification settings.',
      NotificationPreferenceUpdateResult.saved => null,
    };
    if (message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> exportResearchData(BuildContext shareAnchorContext) async {
    if (isExportingResearchData) return;

    final renderBox = shareAnchorContext.findRenderObject() as RenderBox?;
    final shareOrigin = renderBox == null
        ? Rect.fromLTWH(0, 0, MediaQuery.sizeOf(context).width, 1)
        : renderBox.localToGlobal(Offset.zero) & renderBox.size;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Export research data?'),
        content: const Text(
          'This creates a de-identified JSON file containing your '
          'questionnaire, forecasts, reflections, intentions, activity '
          'responses, and model history. It does not include your name, '
          'email, calendar titles, event IDs, or exact calendar dates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Export'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      isExportingResearchData = true;
    });

    try {
      await researchDataShareService.createAndShare(shareOrigin: shareOrigin);
    } catch (error, stackTrace) {
      debugPrint('Could not prepare research data export: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        final message = switch (error) {
          StateError() => 'Complete onboarding before exporting research data.',
          ResearchDataShareException(stage: ResearchDataShareStage.sharing) =>
            'The data file was created, but the share sheet could not open. '
                'Fully restart Cal and try again.',
          _ =>
            'Could not prepare the research data file. Fully restart Cal '
                'and try again.',
        };
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() {
          isExportingResearchData = false;
        });
      }
    }
  }

  Future<void> generateDebugPredictionData() async {
    if (isUpdatingDebugData) return;

    setState(() {
      isUpdatingDebugData = true;
    });

    try {
      await widget.debugPredictionDataService.generateReadyDataset();
    } catch (error) {
      debugPrint('Could not generate test data: $error');
    } finally {
      if (mounted) {
        setState(() {
          isUpdatingDebugData = false;
        });
      }
    }
  }

  Future<void> clearDebugPredictionData() async {
    if (isUpdatingDebugData) return;

    setState(() {
      isUpdatingDebugData = true;
    });

    try {
      await widget.debugPredictionDataService.clearGeneratedData();
    } catch (error) {
      debugPrint('Could not clear test data: $error');
    } finally {
      if (mounted) {
        setState(() {
          isUpdatingDebugData = false;
        });
      }
    }
  }

  Future<void> connectAndLoadTodayEvents({bool forceReconnect = false}) async {
    final hadCurrentUser = currentUser != null;
    setState(() {
      isLoading = true;
      errorMessage = null;
      statusMessage = 'Connecting to Google Calendar...';
    });

    try {
      if (forceReconnect) {
        await widget.googleCalendarService.reconnectAndLoadEventsForDay(
          DateTime.now(),
        );
      } else {
        await widget.googleCalendarService.connectAndLoadEventsForDay(
          DateTime.now(),
        );
      }

      if (!mounted) return;
      setState(() {
        needsReconnect = false;
        statusMessage = 'Connected to Google Calendar.';
      });
    } on GoogleSignInException catch (error) {
      debugPrint('Google Sign-In failed: $error');
      setState(() {
        needsReconnect =
            forceReconnect ||
            hadCurrentUser ||
            _isExpiredAuthorizationError(error);
        if (needsReconnect) {
          currentUser = null;
        }
        errorMessage = _googleConnectionErrorMessage(error);
      });
    } catch (error) {
      debugPrint('Google Calendar connection failed: $error');
      setState(() {
        needsReconnect =
            forceReconnect ||
            hadCurrentUser ||
            _isExpiredAuthorizationError(error);
        if (needsReconnect) {
          currentUser = null;
        }
        errorMessage = _googleConnectionErrorMessage(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> signOut() async {
    await widget.googleCalendarService.disconnect();

    if (!mounted) return;
    setState(() {
      currentUser = null;
      needsReconnect = false;
      statusMessage = 'Signed out.';
      errorMessage = null;
    });
  }

  void handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    if (!mounted) return;

    setState(() {
      switch (event) {
        case GoogleSignInAuthenticationEventSignIn():
          currentUser = event.user;
          needsReconnect = false;
          statusMessage = 'Signed in. Calendar events not loaded yet.';
        case GoogleSignInAuthenticationEventSignOut():
          currentUser = null;
          statusMessage = 'Signed out.';
      }
    });
  }

  void handleAuthenticationError(Object error) {
    if (!mounted) return;

    debugPrint('Google authentication failed: $error');
    setState(() {
      currentUser = null;
      needsReconnect = _isExpiredAuthorizationError(error);
      errorMessage = _googleConnectionErrorMessage(error);
    });
  }

  void handleReconnectionStateChanged() {
    if (!mounted) return;

    setState(() {});
  }

  bool _isExpiredAuthorizationError(Object error) {
    final message = error.toString().toLowerCase();

    return message.contains('invalid_grant') ||
        message.contains('token has been expired or revoked');
  }

  String _googleConnectionErrorMessage(Object error) {
    if (_isExpiredAuthorizationError(error)) {
      return 'Google Calendar access expired. Reconnect to sign in again.';
    }

    if (error is TimeoutException) {
      return 'Google sign-in timed out. Please try reconnecting.';
    }

    return 'Could not connect Google Calendar. Please try again.';
  }
}
