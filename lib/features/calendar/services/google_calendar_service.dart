import 'dart:async';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as google_calendar;

import '../models/calendar_event.dart';
import 'google_calendar_event_mapper.dart';

class GoogleCalendarService {
  GoogleCalendarService({
    required this.googleWebClientId,
    GoogleCalendarEventMapper? eventMapper,
  }) : eventMapper = eventMapper ?? GoogleCalendarEventMapper(),
       _platformInitializer = null;

  @visibleForTesting
  GoogleCalendarService.forTesting({
    required Future<void> Function() platformInitializer,
    GoogleCalendarEventMapper? eventMapper,
  }) : googleWebClientId = '',
       eventMapper = eventMapper ?? GoogleCalendarEventMapper(),
       _platformInitializer = platformInitializer;

  static const List<String> calendarScopes = [
    google_calendar.CalendarApi.calendarEventsReadonlyScope,
  ];

  final String googleWebClientId;
  final GoogleCalendarEventMapper eventMapper;
  final Future<void> Function()? _platformInitializer;

  Future<void>? _initializeFuture;
  StreamSubscription<GoogleSignInAuthenticationEvent>?
  _authenticationSubscription;
  GoogleSignInAccount? _currentUser;
  // keep Profile in sync when Today detects that Google needs reconnecting
  final ValueNotifier<bool> _requiresReconnection = ValueNotifier(false);

  Stream<GoogleSignInAuthenticationEvent> get authenticationEvents {
    return GoogleSignIn.instance.authenticationEvents;
  }

  bool get requiresReconnection => _requiresReconnection.value;

  ValueListenable<bool> get reconnectionState => _requiresReconnection;

  Future<void> initialize() {
    return _initializeFuture ??= _initializeAttempt();
  }

  Future<void> _initializeAttempt() async {
    try {
      await _initialize();
    } catch (_) {
      // a failed Future must not permanently block later connection attempts
      _initializeFuture = null;
      rethrow;
    }
  }

  Future<List<CalendarEvent>> connectAndLoadEventsForDay(DateTime day) async {
    try {
      return await _connectAndLoadEventsForDay(day);
    } catch (error) {
      if (!_isInvalidGrantError(error)) {
        rethrow;
      }

      await _resetExpiredSession();
      return _connectAndLoadEventsForDay(day, forceInteractiveSignIn: true);
    }
  }

  Future<List<CalendarEvent>> reconnectAndLoadEventsForDay(DateTime day) async {
    await initialize();
    await _resetExpiredSession();

    return _connectAndLoadEventsForDay(day, forceInteractiveSignIn: true);
  }

  // Today only refreshes an existing connection/ Profile handles sign-in
  Future<List<CalendarEvent>> loadConnectedEventsForDay(DateTime day) async {
    try {
      return await _connectAndLoadEventsForDay(
        day,
        allowInteractiveSignIn: false,
      );
    } catch (error) {
      if (_requiresReconnectionForError(error)) {
        await _resetExpiredSession();
      }
      rethrow;
    }
  }

  Future<List<CalendarEvent>> _connectAndLoadEventsForDay(
    DateTime day, {
    bool forceInteractiveSignIn = false,
    bool allowInteractiveSignIn = true,
  }) async {
    await initialize();

    final account = await _getSignedInUser(
      forceInteractiveSignIn: forceInteractiveSignIn,
      allowInteractiveSignIn: allowInteractiveSignIn,
    );
    var authorization = await _getCalendarAuthorization(account);

    try {
      final events = await _loadEventsForDay(day, authorization);
      _requiresReconnection.value = false;
      return events;
    } catch (error) {
      if (!_isInvalidTokenError(error)) {
        rethrow;
      }

      // clear an expired access token before requesting a replacement
      await account.authorizationClient.clearAuthorizationToken(
        accessToken: authorization.accessToken,
      );
      authorization = await account.authorizationClient.authorizeScopes(
        calendarScopes,
      );

      final events = await _loadEventsForDay(day, authorization);
      _requiresReconnection.value = false;
      return events;
    }
  }

  Future<GoogleSignInClientAuthorization> _getCalendarAuthorization(
    GoogleSignInAccount account,
  ) async {
    return await account.authorizationClient.authorizationForScopes(
          calendarScopes,
        ) ??
        await account.authorizationClient.authorizeScopes(calendarScopes);
  }

  Future<List<CalendarEvent>> _loadEventsForDay(
    DateTime day,
    GoogleSignInClientAuthorization authorization,
  ) async {
    final client = authorization.authClient(scopes: calendarScopes);

    try {
      final calendarApi = google_calendar.CalendarApi(client);
      final response = await calendarApi.events.list(
        'primary',
        timeMin: DateTime(day.year, day.month, day.day),
        timeMax: DateTime(
          day.year,
          day.month,
          day.day,
        ).add(const Duration(days: 1)),
        singleEvents: true,
        orderBy: 'startTime',
      );

      return (response.items ?? [])
          .where((event) => event.status != 'cancelled')
          .map(eventMapper.fromGoogleEvent)
          .toList();
    } finally {
      client.close();
    }
  }

  bool _isInvalidTokenError(Object error) {
    final message = error.toString().toLowerCase();

    return message.contains('invalid_token') ||
        message.contains('access was denied');
  }

  bool _isInvalidGrantError(Object error) {
    final message = error.toString().toLowerCase();

    return message.contains('invalid_grant') ||
        message.contains('token has been expired or revoked');
  }

  bool _requiresReconnectionForError(Object error) {
    final message = error.toString().toLowerCase();

    return _isInvalidGrantError(error) ||
        message.contains('not connected') ||
        message.contains('authentication') ||
        message.contains('authorization') ||
        message.contains('access was denied') ||
        message.contains('oauth');
  }

  // clear app state after an authorisation failure without revoking access
  Future<void> _resetExpiredSession() async {
    _currentUser = null;
    _requiresReconnection.value = true;
  }

  Future<void> disconnect() async {
    await GoogleSignIn.instance.disconnect();
    _currentUser = null;
    _requiresReconnection.value = false;
  }

  void dispose() {
    final authenticationSubscription = _authenticationSubscription;
    if (authenticationSubscription != null) {
      unawaited(authenticationSubscription.cancel());
    }
    _requiresReconnection.dispose();
  }

  Future<void> _initialize() async {
    final platformInitializer = _platformInitializer;
    if (platformInitializer != null) {
      await platformInitializer();
      return;
    }

    await GoogleSignIn.instance.initialize(
      serverClientId: googleWebClientId.isEmpty ? null : googleWebClientId,
    );

    // listen for global sign-in changes so every tab shares the same account
    await _authenticationSubscription?.cancel();
    _authenticationSubscription = GoogleSignIn.instance.authenticationEvents
        .listen((event) {
          switch (event) {
            case GoogleSignInAuthenticationEventSignIn():
              _currentUser = event.user;
            case GoogleSignInAuthenticationEventSignOut():
              _currentUser = null;
          }
        });

    _currentUser = await _attemptLightweightAuthentication();
  }

  Future<GoogleSignInAccount> _getSignedInUser({
    bool forceInteractiveSignIn = false,
    bool allowInteractiveSignIn = true,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android &&
        googleWebClientId.isEmpty) {
      throw StateError(
        'Android Google Sign-In needs a Web client ID. Run with '
        '--dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
      );
    }

    final existingUser = forceInteractiveSignIn
        ? null
        : _currentUser ?? await _attemptLightweightAuthentication();

    if (existingUser != null) {
      _currentUser = existingUser;
      return existingUser;
    }

    if (!allowInteractiveSignIn) {
      throw StateError('Google Calendar is not connected.');
    }

    _currentUser = await GoogleSignIn.instance.authenticate().timeout(
      const Duration(seconds: 60),
    );
    return _currentUser!;
  }

  // restore an existing session without opening interactive sign-in UI
  Future<GoogleSignInAccount?> _attemptLightweightAuthentication() {
    final authentication = GoogleSignIn.instance
        .attemptLightweightAuthentication();

    if (authentication == null) {
      return Future.value();
    }

    return authentication.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return null;
      },
    );
  }
}
