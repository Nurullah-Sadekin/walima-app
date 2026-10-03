import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:walima_llc/features/chat/data/model/response/conversation_messages_response.dart'
    as chat_message;

class ForegroundAlertService {
  ForegroundAlertService._internal();

  static final ForegroundAlertService instance =
      ForegroundAlertService._internal();

  static const String _channelId = 'chat_foreground_channel';
  static const String _channelName = 'Chat Foreground Alerts';
  static const String _channelDescription =
      'Shows chat notifications while app is in foreground';

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _initialized = false;
  bool _isAppInForeground = true;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notifications.initialize(settings);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
          ),
        );

    _initialized = true;
  }

  void setAppForeground(bool value) {
    _isAppInForeground = value;
  }

  Future<void> notifyIncomingMessage(chat_message.Message msg) async {
    if (!_initialized) return;
    if (!_isAppInForeground) return;

    final senderName = _resolveSenderName(msg);
    final messageBody = (msg.content ?? '').trim();
    if (messageBody.isEmpty) return;

    await _playIncomingSound();
    await _showLocalNotification(
      title: senderName,
      body: messageBody,
    );
  }

  Future<void> notifyRemoteNotification({
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;
    if (!_isAppInForeground) return;
    if (title.trim().isEmpty && body.trim().isEmpty) return;

    await _showLocalNotification(
      title: title.trim().isEmpty ? 'Walima' : title,
      body: body.trim(),
    );
  }

  String _resolveSenderName(chat_message.Message msg) {
    final fromSender = [
      msg.sender?.firstName,
      msg.sender?.lastName,
    ].whereType<String>().where((x) => x.trim().isNotEmpty).join(' ');
    if (fromSender.isNotEmpty) return fromSender;

    final username = msg.sender?.username?.trim();
    if (username != null && username.isNotEmpty) return username;

    return 'New Message';
  }

  Future<void> _playIncomingSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/chat_sound.mp3'));
    } catch (e) {
      debugPrint('[ForegroundAlertService] sound error: $e');
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: false,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = Random().nextInt(1 << 31);
    try {
      await _notifications.show(id, title, body, details);
    } catch (e) {
      debugPrint('[ForegroundAlertService] notification error: $e');
    }
  }
}
