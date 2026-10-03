import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/chat/data/model/response/connectable_user_response.dart';
import 'package:walima_llc/features/chat/data/model/response/conversation_list.dart';
import 'package:walima_llc/features/chat/data/model/response/conversation_messages_response.dart'
    hide ProfilePhoto;
import 'package:walima_llc/features/chat/data/repository/chat_repository.dart';
import 'package:walima_llc/features/chat/data/socket/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatProvider extends BaseChangeNotifier {
  ChatProvider(this._ref);

  final Ref _ref;
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
  StreamSubscription<Map<String, dynamic>>? _connectionStateSub;

  String? currentConversationId;
  List<Message> messages = [];
  bool messagesLoading = false;
  bool loadingMoreMessages = false;
  bool hasMoreMessages = false;
  String? messagesNextCursor;
  bool isOtherUserTyping = false;
  String? typingConversationId;
  String? activeReceiverId;
  final Set<String> _typingConversationIds = <String>{};

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

  bool isConversationTyping(String? conversationId) {
    if (conversationId == null || conversationId.isEmpty) return false;
    return _typingConversationIds.contains(conversationId);
  }

  void setSelectedTab(int index) {
    if (index == selectedTabIndex) return;
    if (index < 0) return;
    selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> getInitialData() async {
    updateViewState(loadingState: ChatScreenState.loading);
    await _ensureCurrentUserId();
    await getConnectableUserList();
    await getConversation();
    updateViewState(screenStates: ChatScreenState.complete);
  }

  Future<void> initializeRealtime({String? token}) async {
    if (!_socketInitialized) {
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
      _connectionStateSub = SocketService.instance.connectionStates.listen(
        _handleConnectionState,
      );
      _socketInitialized = true;
      debugPrint('[ChatProvider] realtime subscriptions initialized');
    }

    await SocketService.instance.connect(token: token);
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
    _typingConversationIds.removeWhere(
      (id) => !(conversations?.any((conversation) => conversation.id == id) ??
          false),
    );
    updateViewState();
  }

  Future<void> openConversation(String conversationId) async {
    if (conversationId == currentConversationId && messages.isNotEmpty) {
      _markCurrentConversationRead();
      return;
    }
    await _ensureCurrentUserId();
    debugPrint(
      '[ChatProvider] openConversation start id=$conversationId currentUserId=$_currentUserId',
    );
    currentConversationId = conversationId;
    _typingConversationIds.remove(conversationId);
    messagesLoading = true;
    loadingMoreMessages = false;
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
    messages = _sortedMessagesNewestFirst(resp.data ?? []);
    debugPrint(
      '[ChatProvider] openConversation loaded count=${messages.length} hasMore=${resp.hasMore} nextCursor=${resp.nextCursor}',
    );
    for (final message in messages) {
      debugPrint(
        '[ChatProvider] history message id=${message.id} senderId=${message.senderId} receiverId=${message.receiverId} content=${message.content}',
      );
    }
    messagesNextCursor = resp.nextCursor;
    hasMoreMessages = resp.hasMore ?? false;
    messagesLoading = false;
    activeReceiverId = resp.otherParticipant?.id ?? activeReceiverId;
    _markCurrentConversationRead();
    notifyListeners();
  }

  Future<void> openDirectChat({
    required String receiverId,
    String? conversationId,
  }) async {
    activeReceiverId = receiverId;
    isOtherUserTyping = false;
    typingConversationId = null;

    if (conversationId == null || conversationId.isEmpty) {
      currentConversationId = null;
      messages = [];
      messagesNextCursor = null;
      hasMoreMessages = false;
      messagesLoading = false;
      loadingMoreMessages = false;
      notifyListeners();
      return;
    }

    await openConversation(conversationId);
  }

  Future<void> loadMoreMessages() async {
    if (!hasMoreMessages ||
        loadingMoreMessages ||
        messagesNextCursor == null ||
        currentConversationId == null) {
      return;
    }
    loadingMoreMessages = true;
    debugPrint(
      '[ChatProvider] loadMoreMessages conversationId=$currentConversationId cursor=$messagesNextCursor',
    );
    notifyListeners();
    final resp = await ChatRepository.getConversationMessages(
      currentConversationId!,
      limit: 50,
      cursor: messagesNextCursor,
    );
    final more = _sortedMessagesNewestFirst(resp.data ?? []);
    final existingIds =
        messages.map((message) => message.id).whereType<String>().toSet();
    for (final message in more) {
      final messageId = message.id;
      if (messageId != null && existingIds.contains(messageId)) {
        continue;
      }
      messages.add(message);
      if (messageId != null) {
        existingIds.add(messageId);
      }
    }
    messagesNextCursor = resp.nextCursor;
    hasMoreMessages = resp.hasMore ?? false;
    loadingMoreMessages = false;
    debugPrint(
      '[ChatProvider] loadMoreMessages merged total=${messages.length} hasMore=$hasMoreMessages nextCursor=$messagesNextCursor',
    );
    notifyListeners();
  }

  void addIncomingMessage(Message msg) {
    final incomingConversationId = msg.conversationId;
    if (incomingConversationId != null && incomingConversationId.isNotEmpty) {
      _typingConversationIds.remove(incomingConversationId);
    }

    if (msg.conversationId != null &&
        msg.conversationId == currentConversationId) {
      if (!_hasMessage(msg.id)) {
        messages.insert(0, msg);
      }
      _upsertConversationFromMessage(
        msg,
        increaseUnread: false,
        moveToTop: true,
      );
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
        _moveConversationToTop(idx);
        notifyListeners();
        return;
      }
    }

    _upsertConversationFromMessage(
      msg,
      increaseUnread: true,
      moveToTop: true,
    );
    notifyListeners();
  }

  Future<bool> sendMessage(String content, String receiverId) async {
    if (content.isEmpty) return false;
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

    if (!SocketService.instance.isConnected) {
      final sent = await ChatRepository.sendMessage(
        conversationId: currentConversationId,
        receiverId: receiverId,
        content: content,
      );
      final optimisticIndex = messages.indexWhere((item) => item.id == tmpId);
      if (sent != null) {
        if (optimisticIndex != -1) {
          messages[optimisticIndex] = sent;
        } else if (!_hasMessage(sent.id)) {
          messages.insert(0, sent);
        }
        currentConversationId ??= sent.conversationId;
        _upsertConversationFromMessage(sent, moveToTop: true);
      } else if (optimisticIndex != -1) {
        messages[optimisticIndex].status = 'failed';
      }
      notifyListeners();
      return sent != null;
    }

    SocketService.instance.sendMessage(
      receiverId: receiverId,
      message: content,
      messageType: 'text',
    );
    return true;
  }

  void setActiveReceiver(String? receiverId) {
    activeReceiverId = receiverId;
  }

  void closeActiveConversation() {
    currentConversationId = null;
    activeReceiverId = null;
    isOtherUserTyping = false;
    typingConversationId = null;
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
    debugPrint(
      '[ChatProvider] incoming socket message id=${msg.id} conversationId=${msg.conversationId} senderId=${msg.senderId}',
    );
    addIncomingMessage(msg);
  }

  void _handleRealtimeSentMessage(Message msg) {
    debugPrint(
      '[ChatProvider] sent socket message id=${msg.id} conversationId=${msg.conversationId} senderId=${msg.senderId}',
    );
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
    _upsertConversationFromMessage(msg, moveToTop: true);
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
    String? conversationId = payload['conversationId']?.toString();
    final senderId =
        payload['senderId']?.toString() ?? payload['userId']?.toString();
    if (senderId != null && senderId == _currentUserId) return;

    final isTyping = payload['isTyping'] == true ||
        payload['typing'] == true ||
        payload['status']?.toString() == 'start' ||
        payload['event']?.toString() == 'typing:start';

    if (conversationId == null || conversationId.isEmpty) {
      conversationId = _resolveConversationIdByParticipant(senderId);
    }

    if (conversationId != null && conversationId.isNotEmpty) {
      if (isTyping) {
        _typingConversationIds.add(conversationId);
      } else {
        _typingConversationIds.remove(conversationId);
      }
    }

    if (currentConversationId != null &&
        conversationId != null &&
        conversationId == currentConversationId) {
      isOtherUserTyping = isTyping;
      typingConversationId = conversationId;
    } else if (!isTyping &&
        typingConversationId != null &&
        conversationId == typingConversationId) {
      isOtherUserTyping = false;
      typingConversationId = null;
    }
    notifyListeners();
  }

  void _handleConnectionState(Map<String, dynamic> payload) {
    final event = payload['event']?.toString();
    debugPrint('[ChatProvider] socket state event=$event payload=$payload');
    if (event == 'connection:success') {
      unawaited(_syncAfterReconnect());
    }
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

  void _upsertConversationFromMessage(
    Message message, {
    bool increaseUnread = false,
    bool moveToTop = false,
  }) {
    final conversationId = message.conversationId;
    if (conversationId == null || conversationId.isEmpty) {
      return;
    }

    conversations ??= [];
    final index =
        conversations!.indexWhere((item) => item.id == conversationId);
    if (index != -1) {
      final conversation = conversations![index];
      conversation.lastMessage = message.content;
      conversation.lastMessageAt = message.sentAt ??
          message.createdAt ??
          DateTime.now().toUtc().toIso8601String();
      if (increaseUnread) {
        conversation.unreadCount = (conversation.unreadCount ?? 0) + 1;
      }
      if (moveToTop) {
        _moveConversationToTop(index);
      }
      return;
    }

    final counterpart = _participantFromMessage(message);
    conversations!.insert(
      0,
      Conversations(
        id: conversationId,
        type: 'direct',
        status: 'active',
        lastMessage: message.content,
        lastMessageAt: message.sentAt ??
            message.createdAt ??
            DateTime.now().toUtc().toIso8601String(),
        unreadCount: increaseUnread ? 1 : 0,
        participants: [
          if (_currentUserId != null && _currentUserId!.isNotEmpty)
            Participants(
              userId: _currentUserId,
            ),
          if (counterpart != null) counterpart,
        ],
      ),
    );
  }

  Participants? _participantFromMessage(Message message) {
    final participantLite =
        message.senderId == _currentUserId ? message.receiver : message.sender;
    final fallbackUserId = message.senderId == _currentUserId
        ? message.receiverId
        : message.senderId;
    final mapped = _participantFromLite(
      participantLite,
      fallbackUserId: fallbackUserId,
    );
    if (mapped != null) {
      return mapped;
    }

    for (final user in connectableUsers ?? const <Users>[]) {
      final candidateId = message.senderId == _currentUserId
          ? message.receiverId
          : message.senderId;
      if (user.id != candidateId) continue;
      return Participants(
        userId: user.id,
        displayName: user.displayName,
        firstName: user.firstName,
        lastName: user.lastName,
        username: user.username?.toString(),
        userReference: user.userReference,
        profilePhoto: user.profilePhoto?.url != null
            ? ProfilePhoto(
                url: user.profilePhoto?.url,
                isVerified: false,
              )
            : null,
        isOnline: user.isOnline,
        lastSeenAt: user.lastSeenAt,
      );
    }

    if (fallbackUserId == null || fallbackUserId.isEmpty) {
      return null;
    }

    return Participants(userId: fallbackUserId);
  }

  Participants? _participantFromLite(
    ParticipantLite? participantLite, {
    String? fallbackUserId,
  }) {
    final resolvedUserId = participantLite?.id ?? fallbackUserId;
    if (resolvedUserId == null || resolvedUserId.isEmpty) {
      return null;
    }

    final displayName = [
      participantLite?.firstName,
      participantLite?.lastName,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' ');

    return Participants(
      userId: resolvedUserId,
      displayName:
          displayName.isNotEmpty ? displayName : participantLite?.username,
      firstName: participantLite?.firstName,
      lastName: participantLite?.lastName,
      username: participantLite?.username,
      userReference: participantLite?.userReference,
      isOnline: participantLite?.isOnline,
      lastSeenAt: participantLite?.lastSeenAt,
    );
  }

  void _moveConversationToTop(int index) {
    if (conversations == null || index <= 0 || index >= conversations!.length) {
      return;
    }
    final conversation = conversations!.removeAt(index);
    conversations!.insert(0, conversation);
  }

  List<Message> _sortedMessagesNewestFirst(List<Message> items) {
    final sorted = List<Message>.from(items);
    sorted.sort((a, b) {
      final aTime = DateTime.tryParse(a.sentAt ?? a.createdAt ?? '');
      final bTime = DateTime.tryParse(b.sentAt ?? b.createdAt ?? '');
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });
    return sorted;
  }

  String? _resolveConversationIdByParticipant(String? participantUserId) {
    if (participantUserId == null || participantUserId.isEmpty) return null;
    for (final conversation in conversations ?? const <Conversations>[]) {
      final participants = conversation.participants ?? const <Participants>[];
      final hasParticipant = participants
          .any((participant) => participant.userId == participantUserId);
      if (!hasParticipant) continue;
      final conversationId = conversation.id;
      if (conversationId != null && conversationId.isNotEmpty) {
        return conversationId;
      }
    }
    return null;
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

  Future<void> _ensureCurrentUserId() async {
    if (_currentUserId != null && _currentUserId!.isNotEmpty) {
      return;
    }

    final global = _ref.read(globalProvider);
    var resolvedUserId = global.currentUserId;

    if (resolvedUserId.isEmpty) {
      await global.refreshCurrentUserAndQuota(silent: true);
      resolvedUserId = global.currentUserId;
    }

    if (resolvedUserId.isNotEmpty) {
      _currentUserId = resolvedUserId;
    }
  }

  Future<void> _syncAfterReconnect() async {
    await _ensureCurrentUserId();
    await getConnectableUserList();
    await getConversation();

    final conversationId = currentConversationId;
    if (conversationId != null && conversationId.isNotEmpty) {
      final resp = await ChatRepository.getConversationMessages(
        conversationId,
        limit: 50,
      );
      messages = _sortedMessagesNewestFirst(resp.data ?? []);
      messagesNextCursor = resp.nextCursor;
      hasMoreMessages = resp.hasMore ?? false;
      loadingMoreMessages = false;
      activeReceiverId = resp.otherParticipant?.id ?? activeReceiverId;
      _markCurrentConversationRead();
      notifyListeners();
    }
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
    _connectionStateSub?.cancel();
    _incomingMessageSub = null;
    _sentMessageSub = null;
    _messageStatusSub = null;
    _presenceSub = null;
    _typingSub = null;
    _connectionStateSub = null;
    _socketInitialized = false;
  }

  void clearChatState({bool notify = true}) {
    disposeRealtime();
    connectableUsers = [];
    conversations = [];
    _currentUserId = null;
    selectedTabIndex = 0;

    currentConversationId = null;
    messages = [];
    messagesLoading = false;
    loadingMoreMessages = false;
    hasMoreMessages = false;
    messagesNextCursor = null;
    isOtherUserTyping = false;
    typingConversationId = null;
    _typingConversationIds.clear();
    activeReceiverId = null;
    screenStates = ChatScreenState.complete;
    loaderState = ChatScreenState.complete;

    if (notify) {
      notifyListeners();
    }
  }

  // Future<void> blockConnection() async {
  //   final response = await ConnectionsRepository.performConnectionAction(
  //     connectionId,
  //     PerformConnectionActionRequestBody(
  //       action: 'respond',
  //       status: status,
  //       message: connection.connection?.message,
  //       expiresAt: connection.connection?.expiresAt,
  //       isPriority: connection.connection?.isPriority,
  //     ),
  //   );
  //
  // }

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
