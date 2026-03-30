import 'dart:async';

import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/connectable_user_response.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_list.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_messages_response.dart';
import 'package:flutter_boilerplate/features/chat/data/repository/chat_repository.dart';
import 'package:flutter_boilerplate/features/chat/data/socket/socket_service.dart';

class ChatProvider extends BaseChangeNotifier {
  ChatScreenState screenStates = ChatScreenState.complete;
  ChatScreenState loaderState = ChatScreenState.complete;
  List<Users>? connectableUsers;
  List<Conversations>? conversations;
  String? _currentUserId;
  int selectedTabIndex = 0;
  bool _socketInitialized = false;
  StreamSubscription<Message>? _incomingMessageSub;
  StreamSubscription<Message>? _sentMessageSub;
  StreamSubscription<Map<String, dynamic>>? _messageStatusSub;
  StreamSubscription<Map<String, dynamic>>? _presenceSub;
  StreamSubscription<Map<String, dynamic>>? _typingSub;

  String? currentConversationId;
  List<Message> messages = [];
  bool messagesLoading = false;
  bool hasMoreMessages = false;
  String? messagesNextCursor;
  bool isOtherUserTyping = false;
  String? typingConversationId;
  String? activeReceiverId;

  List<Conversations> get allConversations => conversations ?? const [];

  List<Conversations> get unreadConversations {
    return allConversations
        .where((conversation) => (conversation.unreadCount ?? 0) > 0)
        .toList();
  }

  List<Conversations> get callConversations {
    return allConversations
        .where(
          (conversation) =>
              (conversation.type ?? '').toLowerCase().contains('call'),
        )
        .toList();
  }

  int get unreadCount {
    return allConversations.fold<int>(
      0,
      (sum, conversation) => sum + (conversation.unreadCount ?? 0),
    );
  }

  String? get currentUserId => _currentUserId;

  void setSelectedTab(int index) {
    if (index == selectedTabIndex) return;
    if (index < 0) return;
    selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> getInitialData() async {
    updateViewState(loadingState: ChatScreenState.loading);
    await getConnectableUserList();
    await getConversation();
    updateViewState(screenStates: ChatScreenState.complete);
  }

  Future<void> initializeRealtime({String? token}) async {
    if (_socketInitialized) {
      await SocketService.instance.connect(token: token);
      return;
    }

    await SocketService.instance.connect(token: token);
    _incomingMessageSub = SocketService.instance.messages.listen(
      _handleRealtimeIncomingMessage,
    );
    _sentMessageSub = SocketService.instance.sentMessages.listen(
      _handleRealtimeSentMessage,
    );
    _messageStatusSub = SocketService.instance.messageStatuses.listen(
      _handleMessageStatus,
    );
    _presenceSub =
        SocketService.instance.presence.listen(_handlePresenceUpdate);
    _typingSub = SocketService.instance.typing.listen(_handleTypingUpdate);
    _socketInitialized = true;
  }

  Future<void> getConnectableUserList() async {
    final data = await ChatRepository.getConnectableUserList();
    if (data.response?.users != null) {
      connectableUsers = data.response!.users;
    } else {
      connectableUsers = [];
    }
    updateViewState();
  }

  Future<void> getConversation() async {
    final data = await ChatRepository.getConversation();
    if (data.response?.conversations != null) {
      conversations = data.response!.conversations;
    } else {
      conversations = [];
    }
    _resolveCurrentUserId();
    updateViewState();
  }

  Future<void> openConversation(String conversationId) async {
    if (conversationId == currentConversationId) {
      _markCurrentConversationRead();
      return;
    }
    currentConversationId = conversationId;
    messagesLoading = true;
    messages = [];
    messagesNextCursor = null;
    hasMoreMessages = false;
    isOtherUserTyping = false;
    typingConversationId = null;
    notifyListeners();

    final resp = await ChatRepository.getConversationMessages(
      conversationId,
      limit: 50,
    );
    messages = resp.data ?? [];
    messagesNextCursor = resp.nextCursor;
    hasMoreMessages = resp.hasMore ?? false;
    messagesLoading = false;
    activeReceiverId = resp.otherParticipant?.id ?? activeReceiverId;
    _markCurrentConversationRead();
    notifyListeners();
  }

  Future<void> loadMoreMessages() async {
    if (!hasMoreMessages ||
        messagesNextCursor == null ||
        currentConversationId == null) {
      return;
    }
    final resp = await ChatRepository.getConversationMessages(
      currentConversationId!,
      limit: 50,
      cursor: messagesNextCursor,
    );
    final more = resp.data ?? [];
    messages.addAll(more);
    messagesNextCursor = resp.nextCursor;
    hasMoreMessages = resp.hasMore ?? false;
    notifyListeners();
  }

  void addIncomingMessage(Message msg) {
    if (msg.conversationId != null &&
        msg.conversationId == currentConversationId) {
      if (!_hasMessage(msg.id)) {
        messages.insert(0, msg);
      }
      if (msg.id != null && msg.id!.isNotEmpty) {
        SocketService.instance.markMessageDelivered(msg.id!);
        SocketService.instance.markMessageRead(msg.id!);
      }
      _markCurrentConversationRead();
      notifyListeners();
      return;
    }

    if (conversations != null) {
      final idx = conversations!.indexWhere((c) => c.id == msg.conversationId);
      if (idx != -1) {
        final conv = conversations![idx];
        conv.lastMessage = msg.content;
        conv.lastMessageAt =
            msg.sentAt ?? DateTime.now().toUtc().toIso8601String();
        conv.unreadCount = (conv.unreadCount ?? 0) + 1;
        notifyListeners();
        return;
      }
    }
  }

  Future<void> sendMessage(String content, String receiverId) async {
    if (content.isEmpty) return;
    activeReceiverId = receiverId;
    final tmpId = 'tmp-${DateTime.now().millisecondsSinceEpoch}';
    final tmp = Message(
      id: tmpId,
      conversationId: currentConversationId,
      senderId: _currentUserId,
      receiverId: receiverId,
      content: content,
      messageType: 'text',
      status: 'sending',
      sentAt: DateTime.now().toUtc().toIso8601String(),
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
    messages.insert(0, tmp);
    _updateConversationPreview(tmp);
    notifyListeners();

    SocketService.instance.sendMessage(
      receiverId: receiverId,
      message: content,
      messageType: 'text',
    );
  }

  void setActiveReceiver(String? receiverId) {
    activeReceiverId = receiverId;
  }

  void onComposerChanged(String value) {
    final receiverId = activeReceiverId;
    if (receiverId == null || receiverId.isEmpty) return;

    if (value.trim().isEmpty) {
      SocketService.instance.stopTyping(
        receiverId: receiverId,
        conversationId: currentConversationId,
      );
      return;
    }

    SocketService.instance.startTyping(
      receiverId: receiverId,
      conversationId: currentConversationId,
    );
  }

  void markCurrentConversationRead() {
    _markCurrentConversationRead();
    notifyListeners();
  }

  Participants? getConversationCounterpart(Conversations conversation) {
    final participantList = conversation.participants ?? const <Participants>[];
    if (participantList.isEmpty) return null;
    if (_currentUserId == null || _currentUserId!.isEmpty) {
      return participantList.length > 1
          ? participantList.last
          : participantList.first;
    }

    return participantList.firstWhere(
      (participant) => participant.userId != _currentUserId,
      orElse: () => participantList.length > 1
          ? participantList.last
          : participantList.first,
    );
  }

  void _handleRealtimeIncomingMessage(Message msg) {
    addIncomingMessage(msg);
  }

  void _handleRealtimeSentMessage(Message msg) {
    final optimisticIndex = messages.indexWhere(
      (item) =>
          item.status == 'sending' &&
          item.receiverId == msg.receiverId &&
          item.content == msg.content,
    );

    if (optimisticIndex != -1) {
      messages[optimisticIndex] = msg;
    } else if (!_hasMessage(msg.id)) {
      messages.insert(0, msg);
    }

    currentConversationId ??= msg.conversationId;
    _updateConversationPreview(msg);
    notifyListeners();
  }

  void _handleMessageStatus(Map<String, dynamic> payload) {
    final messageId =
        payload['messageId']?.toString() ?? payload['id']?.toString();
    if (messageId == null || messageId.isEmpty) return;

    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index == -1) return;

    final message = messages[index];
    final status = payload['status']?.toString();
    if (status != null && status.isNotEmpty) {
      message.status = status;
    }
    if (payload['deliveredAt'] != null) {
      message.deliveredAt = payload['deliveredAt']?.toString();
    }
    if (payload['readAt'] != null) {
      message.readAt = payload['readAt']?.toString();
    }
    notifyListeners();
  }

  void _handlePresenceUpdate(Map<String, dynamic> payload) {
    final updates = _extractPresenceUpdates(payload);
    if (updates.isEmpty) return;

    for (final user in connectableUsers ?? const <Users>[]) {
      final update = updates[user.id ?? ''];
      if (update == null) continue;
      user.isOnline = update['isOnline'] as bool?;
      user.lastSeenAt = update['lastSeenAt']?.toString();
    }

    for (final conversation in conversations ?? const <Conversations>[]) {
      for (final participant
          in conversation.participants ?? const <Participants>[]) {
        final update = updates[participant.userId ?? ''];
        if (update == null) continue;
        participant.isOnline = update['isOnline'] as bool?;
        participant.lastSeenAt = update['lastSeenAt']?.toString();
      }
    }

    notifyListeners();
  }

  void _handleTypingUpdate(Map<String, dynamic> payload) {
    final conversationId = payload['conversationId']?.toString();
    final senderId =
        payload['senderId']?.toString() ?? payload['userId']?.toString();
    if (conversationId != null &&
        currentConversationId != null &&
        conversationId != currentConversationId) {
      return;
    }
    if (senderId != null && senderId == _currentUserId) return;

    final isTyping = payload['isTyping'] == true ||
        payload['typing'] == true ||
        payload['status']?.toString() == 'start' ||
        payload['event']?.toString() == 'typing:start';
    isOtherUserTyping = isTyping;
    typingConversationId = conversationId;
    notifyListeners();
  }

  void _markCurrentConversationRead() {
    final conversationId = currentConversationId;
    if (conversationId == null || conversationId.isEmpty) return;
    SocketService.instance.markConversationRead(conversationId);
    for (final message in messages) {
      if (message.id != null &&
          message.id!.isNotEmpty &&
          message.readAt == null) {
        SocketService.instance.markMessageRead(message.id!);
      }
    }
    final conversationIndex =
        conversations?.indexWhere((c) => c.id == conversationId) ?? -1;
    if (conversationIndex != -1) {
      conversations![conversationIndex].unreadCount = 0;
    }
  }

  bool _hasMessage(String? messageId) {
    if (messageId == null || messageId.isEmpty) return false;
    return messages.any((msg) => msg.id == messageId);
  }

  void _updateConversationPreview(Message message) {
    final conversationId = message.conversationId;
    if (conversationId == null ||
        conversationId.isEmpty ||
        conversations == null) {
      return;
    }
    final index =
        conversations!.indexWhere((item) => item.id == conversationId);
    if (index == -1) return;
    final conversation = conversations![index];
    conversation.lastMessage = message.content;
    conversation.lastMessageAt = message.sentAt ??
        message.createdAt ??
        DateTime.now().toUtc().toIso8601String();
  }

  Map<String, Map<String, dynamic>> _extractPresenceUpdates(
    Map<String, dynamic> payload,
  ) {
    final result = <String, Map<String, dynamic>>{};

    void addEntry(Map<String, dynamic> item) {
      final userId = item['userId']?.toString() ?? item['id']?.toString();
      if (userId == null || userId.isEmpty) return;
      result[userId] = item;
    }

    final users = payload['users'];
    if (users is List) {
      for (final item in users) {
        if (item is Map<String, dynamic>) {
          addEntry(item);
        } else if (item is Map) {
          addEntry(Map<String, dynamic>.from(item));
        }
      }
    } else {
      addEntry(payload);
    }

    return result;
  }

  void _resolveCurrentUserId() {
    final participantFrequency = <String, int>{};

    for (final conversation in allConversations) {
      final participants = conversation.participants ?? const <Participants>[];
      for (final participant in participants) {
        final userId = participant.userId;
        if (userId == null || userId.isEmpty) continue;
        participantFrequency[userId] = (participantFrequency[userId] ?? 0) + 1;
      }
    }

    if (participantFrequency.isEmpty) {
      _currentUserId = null;
      return;
    }

    _currentUserId = participantFrequency.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  void updateViewState({
    ChatScreenState? screenStates,
    ChatScreenState? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = ChatScreenState.complete;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }

  void disposeRealtime() {
    _incomingMessageSub?.cancel();
    _sentMessageSub?.cancel();
    _messageStatusSub?.cancel();
    _presenceSub?.cancel();
    _typingSub?.cancel();
    _incomingMessageSub = null;
    _sentMessageSub = null;
    _messageStatusSub = null;
    _presenceSub = null;
    _typingSub = null;
    _socketInitialized = false;
  }

  @override
  void dispose() {
    disposeRealtime();
    super.dispose();
  }
}

enum ChatScreenState {
  loading,
  complete,
}
