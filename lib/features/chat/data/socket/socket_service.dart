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
  final StreamController<Message> _messageController =
      StreamController<Message>.broadcast();
  final StreamController<Message> _sentMessageController =
      StreamController<Message>.broadcast();
  final StreamController<Map<String, dynamic>> _messageStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _presenceController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _typingController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _connectionStateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  String? _connectedToken;

  Stream<Message> get messages => _messageController.stream;
  Stream<Message> get sentMessages => _sentMessageController.stream;
  Stream<Map<String, dynamic>> get messageStatuses =>
      _messageStatusController.stream;
  Stream<Map<String, dynamic>> get presence => _presenceController.stream;
  Stream<Map<String, dynamic>> get typing => _typingController.stream;
  Stream<Map<String, dynamic>> get connectionStates =>
      _connectionStateController.stream;
  Stream<Map<String, dynamic>> get notifications =>
      _notificationController.stream;

  bool get isConnected => _socket?.connected == true;

  Future<void> connect({String? token}) async {
    final authToken = token ?? await PrefsHelper.getAccessToken();
    if (authToken.isEmpty) return;

    if (_socket != null && _socket!.connected && _connectedToken == authToken) {
      return;
    }

    if (_socket != null) {
      disconnect();
    }

    final uri = AppUrls.domain.replaceAll(RegExp(r'/$'), '') + '/app';
    _connectedToken = authToken;

    _socket = IO.io(
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
      _connectionStateController.add({'event': 'connect'});
    });

    _socket?.on('disconnect', (_) {
      _connectionStateController.add({'event': 'disconnect'});
    });

    _socket?.on('connect_error', (data) {
      _connectionStateController.add({
        'event': 'connect_error',
        'data': _mapFromDynamic(data),
      });
    });

    _socket?.on('connection:success', (data) {
      _connectionStateController.add({
        'event': 'connection:success',
        'data': _mapFromDynamic(data),
      });
      subscribeToNotifications();
      requestOnlineConnections();
    });

    _socket?.on('connection:error', (data) {
      _connectionStateController.add({
        'event': 'connection:error',
        'data': _mapFromDynamic(data),
      });
    });

    _socket?.on('message:received', _handleIncomingMessage);
    _socket?.on('message:sent', _handleSentMessage);
    _socket?.on('message:status', (data) {
      final payload = _mapFromDynamic(data);
      if (payload != null) {
        _messageStatusController.add(payload);
      }
    });

    _socket?.on('typing:indicator', (data) {
      final payload = _mapFromDynamic(data);
      if (payload != null) {
        _typingController.add(payload);
      }
    });

    _socket?.on('users:online:update', (data) {
      final payload = _mapFromDynamic(data);
      if (payload != null) {
        _presenceController.add(payload);
      }
    });

    _socket?.on('notification:new', (data) {
      final payload = _mapFromDynamic(data);
      if (payload != null) {
        _notificationController.add(payload);
      }
    });

    _socket?.on('notification:received', (data) {
      final payload = _mapFromDynamic(data);
      if (payload != null) {
        _notificationController.add(payload);
      }
    });
  }

  void _handleIncomingMessage(dynamic data) {
    final msg = _messageFromDynamic(data);
    if (msg != null) {
      _messageController.add(msg);
    }
  }

  void _handleSentMessage(dynamic data) {
    final msg = _messageFromDynamic(data);
    if (msg != null) {
      _sentMessageController.add(msg);
    }
  }

  Message? _messageFromDynamic(dynamic data) {
    try {
      final payload = _mapFromDynamic(data);
      if (payload == null) return null;
      final messageJson = payload['data'] ?? payload['message'] ?? payload;
      if (messageJson is Map) {
        return Message.fromJson(messageJson);
      }
    } catch (_) {}
    return null;
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

  void emit(String event, dynamic data) => _socket?.emit(event, data);

  void sendMessage({
    required String receiverId,
    required String message,
    String messageType = 'text',
  }) {
    emit('message:send', {
      'receiverId': receiverId,
      'message': message,
      'messageType': messageType,
    });
  }

  void startTyping({
    required String receiverId,
    String? conversationId,
  }) {
    emit('typing:start', {
      'receiverId': receiverId,
      if (conversationId != null && conversationId.isNotEmpty)
        'conversationId': conversationId,
    });
  }

  void stopTyping({
    required String receiverId,
    String? conversationId,
  }) {
    emit('typing:stop', {
      'receiverId': receiverId,
      if (conversationId != null && conversationId.isNotEmpty)
        'conversationId': conversationId,
    });
  }

  void markMessageDelivered(String messageId) {
    emit('message:delivered', {'messageId': messageId});
  }

  void markMessageRead(String messageId) {
    emit('message:read', {'messageId': messageId});
  }

  void markConversationRead(String conversationId) {
    emit('conversation:read', {'conversationId': conversationId});
  }

  void requestOnlineUsers() {
    emit('users:get-online', null);
  }

  void requestOnlineConnections() {
    emit('users:get-online-connections', null);
  }

  void subscribeToNotifications() {
    emit('notification:subscribe', null);
  }

  void disconnect() {
    if (_socket == null) return;
    try {
      _socket?.off('message:received');
      _socket?.off('message:sent');
      _socket?.off('message:status');
      _socket?.off('typing:indicator');
      _socket?.off('users:online:update');
      _socket?.off('notification:new');
      _socket?.off('notification:received');
      _socket?.off('connection:success');
      _socket?.off('connection:error');
      _socket?.off('connect_error');
      _socket?.off('connect');
      _socket?.off('disconnect');
      _socket?.disconnect();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    _connectedToken = null;
  }

  void dispose() {
    _messageController.close();
    _sentMessageController.close();
    _messageStatusController.close();
    _presenceController.close();
    _typingController.close();
    _connectionStateController.close();
    _notificationController.close();
    disconnect();
  }
}
