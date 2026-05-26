import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';
import 'package:walima_llc/features/support/support_bot/domain/model/support_bot_done_event.dart';

class SupportBotSocketService {
  SupportBotSocketService._internal();

  static final SupportBotSocketService instance =
      SupportBotSocketService._internal();

  io.Socket? _socket;
  String? _connectedToken;

  final StreamController<Map<String, dynamic>> _connectionController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _queuedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<SupportBotDoneEvent> _doneController =
      StreamController<SupportBotDoneEvent>.broadcast();
  final StreamController<Map<String, dynamic>> _errorController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _escalatedController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get connectionStates =>
      _connectionController.stream;
  Stream<Map<String, dynamic>> get queued => _queuedController.stream;
  Stream<SupportBotDoneEvent> get done => _doneController.stream;
  Stream<Map<String, dynamic>> get errors => _errorController.stream;
  Stream<Map<String, dynamic>> get escalated => _escalatedController.stream;

  bool get isConnected => _socket?.connected == true;

  Future<void> connect({String? token}) async {
    final authToken = token ?? await PrefsHelper.getAccessToken();
    if (authToken.isEmpty) return;

    if (_socket != null && _socket!.connected && _connectedToken == authToken) {
      return;
    }

    disconnect(reason: 'reconnect requested');

    final uri = '${AppUrls.domain.replaceAll(RegExp(r'/$'), '')}/support-bot';
    _connectedToken = authToken;
    _log('connecting to $uri');

    _socket = io.io(
      uri,
      <String, dynamic>{
        'path': '/socket.io',
        'transports': ['websocket', 'polling'],
        'autoConnect': true,
        'auth': {'token': authToken},
        'reconnection': true,
        'reconnectionAttempts': 10,
        'reconnectionDelay': 1000,
        'reconnectionDelayMax': 5000,
        'forceNew': true,
      },
    );

    _socket?.on('connect', (_) {
      _log('event: connect');
      _connectionController.add({'event': 'connect'});
    });

    _socket?.on('disconnect', (data) {
      _log('event: disconnect payload=$data');
      _connectionController.add({'event': 'disconnect'});
    });

    _socket?.on('connect_error', (data) {
      _log('event: connect_error payload=$data');
      _connectionController.add({'event': 'connect_error', 'data': data});
    });

    _socket?.on('support-bot:connected', (data) {
      _log('event: support-bot:connected payload=$data');
      _connectionController
          .add({'event': 'support-bot:connected', 'data': data});
    });

    _socket?.on('support-bot:queued', (data) {
      _log('event: support-bot:queued payload=$data');
      final payload = _mapFromDynamic(data);
      if (payload != null) _queuedController.add(payload);
    });

    _socket?.on('support-bot:done', (data) {
      _log('event: support-bot:done payload=$data');
      final payload = _mapFromDynamic(data);
      if (payload == null) return;
      _doneController.add(SupportBotDoneEvent.fromJson(payload));
    });

    _socket?.on('support-bot:error', (data) {
      _log('event: support-bot:error payload=$data');
      final payload = _mapFromDynamic(data);
      if (payload != null) _errorController.add(payload);
    });

    _socket?.on('support-bot:escalated', (data) {
      _log('event: support-bot:escalated payload=$data');
      final payload = _mapFromDynamic(data);
      if (payload != null) _escalatedController.add(payload);
    });
  }

  void joinConversation(String conversationId) {
    if (conversationId.isEmpty) return;
    emit('support-bot:join', {'conversationId': conversationId});
  }

  void send({
    required String conversationId,
    required String content,
  }) {
    emit(
      'support-bot:send',
      {'conversationId': conversationId, 'content': content},
    );
  }

  void emit(String event, dynamic data) {
    _log('emit: $event payload=$data');
    _socket?.emit(event, data);
  }

  void disconnect({String? reason}) {
    if (_socket == null) return;
    _log('disconnect reason=$reason');
    try {
      _socket?.dispose();
      _socket?.disconnect();
    } catch (_) {}
    _socket = null;
    _connectedToken = null;
  }

  Map<String, dynamic>? _mapFromDynamic(dynamic data) {
    try {
      if (data is String) {
        final decoded = json.decode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } else if (data is Map<String, dynamic>) {
        return data;
      } else if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
    } catch (_) {}
    return null;
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[SupportBotSocket] $message');
    }
  }
}
