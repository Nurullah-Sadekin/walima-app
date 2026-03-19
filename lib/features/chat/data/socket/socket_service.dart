import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_messages_response.dart';

class SocketService {
  SocketService._internal();

  static final SocketService instance = SocketService._internal();

  IO.Socket? _socket;
  final StreamController<Message> _messageController = StreamController<Message>.broadcast();
  final StreamController<Map<String, dynamic>> _presenceController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Message> get messages => _messageController.stream;
  Stream<Map<String, dynamic>> get presence => _presenceController.stream;

  bool get isConnected => _socket?.connected == true;

  Future<void> connect({String? token}) async {
    final authToken = token ?? await PrefsHelper.getAccessToken();
    if (authToken.isEmpty) return;

    if (_socket != null && _socket!.connected) return;

    final uri = AppUrls.domain.replaceAll(RegExp(r'/$'), '');

    _socket = IO.io(
      uri,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'extraHeaders': {'Authorization': 'Bearer $authToken'},
        'reconnection': true,
      },
    );

    _socket?.on('connect', (_) {
      // connected
    });

    _socket?.on('disconnect', (_) {
      // disconnected
    });

    // Listen to common server events - try a few likely names
    _socket?.on('message', _handleIncoming);
    _socket?.on('message:created', _handleIncoming);
    _socket?.on('chat:message', _handleIncoming);

    _socket?.on('users:get-online', (data) {
      try {
        final map = data is String ? json.decode(data) as Map<String, dynamic> : Map<String, dynamic>.from(data as Map);
        _presenceController.add(map);
      } catch (_) {}
    });
  }

  void _handleIncoming(dynamic data) {
    try {
      Map<String, dynamic> payload;
      if (data is String) {
        payload = json.decode(data) as Map<String, dynamic>;
      } else if (data is Map) {
        payload = Map<String, dynamic>.from(data as Map);
      } else {
        return;
      }

      final messageJson = payload['data'] ?? payload;
      if (messageJson is Map) {
        final msg = Message.fromJson(messageJson);
        _messageController.add(msg);
      }
    } catch (_) {}
  }

  void emit(String event, dynamic data) => _socket?.emit(event, data);

  void disconnect() {
    if (_socket == null) return;
    try {
      _socket?.off('message');
      _socket?.off('message:created');
      _socket?.off('chat:message');
      _socket?.off('users:get-online');
      _socket?.off('connect');
      _socket?.off('disconnect');
      _socket?.disconnect();
    } catch (_) {}
    _socket = null;
  }

  void dispose() {
    _messageController.close();
    _presenceController.close();
    disconnect();
  }
}
