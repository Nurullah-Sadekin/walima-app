import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/core/firebase/firebase_options.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/utils/foreground_alert_service.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

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

    final token = await messaging.getToken();
    await _persistToken(token);

    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) async {
        await _persistToken(token);
        final accessToken = await PrefsHelper.getAccessToken();
        if (accessToken.trim().isNotEmpty) {
          await registerDeviceToken();
        }
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

  Future<void> requestPermissionOnce() async {
    if (kIsWeb || !Platform.isAndroid) return;

    final alreadyAsked = await PrefsHelper.getNotificationPermissionAsked();
    if (alreadyAsked) return;

    await _ensureFirebaseInitialized();
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    await PrefsHelper.setNotificationPermissionAsked(true);
    debugPrint(
      '[FirebaseMessagingService] notification permission status: '
      '${settings.authorizationStatus.name}',
    );
  }

  Future<void> registerDeviceToken() async {
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      await _ensureFirebaseInitialized();
      final messaging = FirebaseMessaging.instance;
      final token = (await messaging.getToken())?.trim() ?? (await PrefsHelper.getFcmToken()).trim();
      if (token.isEmpty) {
        debugPrint(
          '[FirebaseMessagingService] skipping device token registration: no FCM token',
        );
        return;
      }

      await _persistToken(token);
      final payload = await _buildDeviceTokenPayload(token);
      final response = await DioClient().patch(
        AppUrls.registerDeviceToken,
        data: payload,
        isTokenRequired: true,
      );

      debugPrint(
        '[FirebaseMessagingService] register device token response: '
        '${jsonEncode(response.data)} '
        'status=${response.statusCode} '
        'success=${response.isSuccess}',
      );
    } catch (error) {
      debugPrint(
        '[FirebaseMessagingService] register device token unexpected error: $error',
      );
    }
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

  Future<Map<String, dynamic>> _buildDeviceTokenPayload(String token) async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    final deviceId = await _resolveDeviceId();
    final manufacturer = androidInfo.manufacturer.trim();
    final model = androidInfo.model.trim();
    final deviceName = [manufacturer, model].where((value) => value.isNotEmpty).join(' ');

    return {
      'token': token,
      'platform': 'android',
      'deviceId': deviceId,
      'deviceName': deviceName.isEmpty ? 'Android Device' : deviceName,
      'appVersion': packageInfo.version,
      'osVersion': 'Android ${androidInfo.version.release}',
    };
  }

  Future<String> _resolveDeviceId() async {
    final savedDeviceId = await PrefsHelper.getDeviceId();
    if (savedDeviceId.trim().isNotEmpty) {
      return savedDeviceId;
    }

    final generatedDeviceId = const Uuid().v4();
    await PrefsHelper.setDeviceId(generatedDeviceId);
    return generatedDeviceId;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final remoteNotification = message.notification;
    final title = remoteNotification?.title ?? message.data['title']?.toString() ?? '';
    final body = remoteNotification?.body ?? message.data['body']?.toString() ?? '';

    if (title.trim().isEmpty && body.trim().isEmpty) return;

    await ForegroundAlertService.instance.notifyRemoteNotification(
      title: title,
      body: body,
    );
  }
}
