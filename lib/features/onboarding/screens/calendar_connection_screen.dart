import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../calendar/services/google_calendar_service.dart';

class CalendarConnectionScreen extends StatefulWidget {
  const CalendarConnectionScreen({
    super.key,
    required this.googleCalendarService,
    required this.onConnected,
    required this.onSkip,
  });

  final GoogleCalendarService googleCalendarService;
  final Future<void> Function() onConnected;
  final Future<void> Function() onSkip;

  @override
  State<CalendarConnectionScreen> createState() =>
      _CalendarConnectionScreenState();
}

class _CalendarConnectionScreenState extends State<CalendarConnectionScreen> {
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect calendar')),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  color: AppColors.mintTag,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 46,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Bring your day into view',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 14),
              Text(
                'Connect Google Calendar so the app can read your schedule '
                'and prepare your daily energy reflection.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: isLoading ? null : connectCalendar,
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Connect Google Calendar'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: isLoading ? null : skipCalendar,
                child: const Text('Set up later'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> connectCalendar() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await widget.googleCalendarService.connectAndLoadEventsForDay(
        DateTime.now(),
      );
      await widget.onConnected();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = _connectionErrorMessage(error);
      });
    }
  }

  Future<void> skipCalendar() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await widget.onSkip();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Could not finish setup. Please try again.';
      });
    }
  }

  String _connectionErrorMessage(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('invalid_grant') ||
        message.contains('expired or revoked')) {
      return 'Google Calendar access expired. Please reconnect.';
    }

    return 'Could not connect Google Calendar. Please try again.';
  }
}
