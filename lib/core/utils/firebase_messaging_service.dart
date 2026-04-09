import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/core/firebase/firebase_options.dart';
import 'package:flutter_boilerplate/core/utils/foreground_alert_service.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kIsWeb || !Platform.isAndroid) return;

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  bool _initialized = false;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedSubscription;

  Future<void> initialize({
    Future<void> Function()? onNotificationSyncNeeded,
  }) async {
    if (_initialized) return;
    if (kIsWeb || !Platform.isAndroid) {
      debugPrint(
        '[FirebaseMessagingService] Skipping Firebase init on this platform.',
      );
      return;
    }

    await _ensureFirebaseInitialized();
    final messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    final token = await messaging.getToken();
    await _persistToken(token);

    _tokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) async {
        await _persistToken(token);
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[FirebaseMessagingService] token refresh error: $error');
      },
    );

    _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen(
      (message) async {
        await _showForegroundNotification(message);
        if (onNotificationSyncNeeded != null) {
          await onNotificationSyncNeeded();
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint(
          '[FirebaseMessagingService] foreground message error: $error',
        );
      },
    );

    _messageOpenedSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        if (onNotificationSyncNeeded != null) {
          await onNotificationSyncNeeded();
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint(
          '[FirebaseMessagingService] message-opened listener error: $error',
        );
      },
    );

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null && onNotificationSyncNeeded != null) {
      await onNotificationSyncNeeded();
    }

    _initialized = true;
    debugPrint('[FirebaseMessagingService] initialized');
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundMessageSubscription?.cancel();
    await _messageOpenedSubscription?.cancel();
    _initialized = false;
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isNotEmpty) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> _persistToken(String? token) async {
    final normalizedToken = token?.trim() ?? '';
    if (normalizedToken.isEmpty) return;
    await PrefsHelper.setFcmToken(normalizedToken);
    debugPrint('[FirebaseMessagingService] FCM token updated');
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final remoteNotification = message.notification;
    final title =
        remoteNotification?.title ?? message.data['title']?.toString() ?? '';
    final body =
        remoteNotification?.body ?? message.data['body']?.toString() ?? '';

    if (title.trim().isEmpty && body.trim().isEmpty) return;

    await ForegroundAlertService.instance.notifyRemoteNotification(
      title: title,
      body: body,
    );
  }
}
