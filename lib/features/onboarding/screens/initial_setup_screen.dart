import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../navigation/main_navigation_screen.dart';
import '../../calendar/services/google_calendar_service.dart';
import '../../prediction/services/energy_model_service.dart';
import '../models/onboarding_questionnaire_answers.dart';
import '../services/initial_setup_service.dart';
import 'calendar_connection_screen.dart';
import 'onboarding_intro_screen.dart';
import 'onboarding_questionnaire_screen.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );

  late final AppDatabase database;
  late final EnergyModelService energyModelService;
  late final InitialSetupService initialSetupService;
  late final GoogleCalendarService googleCalendarService;

  InitialSetupStep? currentStep;
  String? errorMessage;
  bool hasOpenedMainApp = false;

  @override
  void initState() {
    super.initState();

    database = AppDatabase();
    energyModelService = EnergyModelService(database: database);
    initialSetupService = InitialSetupService(
      database: database,
      energyModelService: energyModelService,
    );
    googleCalendarService = GoogleCalendarService(
      googleWebClientId: googleWebClientId,
    );
    unawaited(loadInitialStep());
  }

  @override
  void dispose() {
    googleCalendarService.dispose();
    unawaited(database.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (currentStep) {
      InitialSetupStep.introduction => OnboardingIntroScreen(
        onStart: () {
          setState(() {
            currentStep = InitialSetupStep.questionnaire;
          });
        },
      ),
      InitialSetupStep.questionnaire => OnboardingQuestionnaireScreen(
        onCompleted: saveQuestionnaire,
      ),
      InitialSetupStep.calendarConnection => CalendarConnectionScreen(
        googleCalendarService: googleCalendarService,
        onConnected: () => finishSetup(skipped: false),
        onSkip: () => finishSetup(skipped: true),
      ),
      InitialSetupStep.complete || null => _LoadingSetupView(
        errorMessage: errorMessage,
        onRetry: loadInitialStep,
      ),
    };
  }

  Future<void> loadInitialStep() async {
    setState(() {
      errorMessage = null;
    });

    try {
      final step = await initialSetupService.loadCurrentStep();
      if (!mounted) return;

      if (step == InitialSetupStep.complete) {
        openMainApp();
        return;
      }

      setState(() {
        currentStep = step;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Could not load app setup. Please try again.';
      });
    }
  }

  Future<void> saveQuestionnaire(OnboardingQuestionnaireAnswers answers) async {
    await initialSetupService.saveQuestionnaireAnswers(answers);
    if (!mounted) return;

    setState(() {
      currentStep = InitialSetupStep.calendarConnection;
    });
  }

  Future<void> finishSetup({required bool skipped}) async {
    await initialSetupService.completeCalendarSetup(skipped: skipped);
    if (!mounted) return;

    openMainApp();
  }

  void openMainApp() {
    if (hasOpenedMainApp) return;
    hasOpenedMainApp = true;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }
}

class _LoadingSetupView extends StatelessWidget {
  const _LoadingSetupView({required this.errorMessage, required this.onRetry});

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: errorMessage == null
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: onRetry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
