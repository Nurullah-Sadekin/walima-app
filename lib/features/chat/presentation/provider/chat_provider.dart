import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/connectable_user_response.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_list.dart';
import 'package:flutter_boilerplate/features/chat/data/repository/chat_repository.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_messages_response.dart';

class ChatProvider extends BaseChangeNotifier {
  ChatScreenState screenStates = ChatScreenState.complete;
  ChatScreenState loaderState = ChatScreenState.complete;
  List<Users>? connectableUsers;
  List<Conversations>? conversations;
  String? _currentUserId;
  int selectedTabIndex = 0;

  // Current conversation + messages
  String? currentConversationId;
  List<Message> messages = [];
  bool messagesLoading = false;
  bool hasMoreMessages = false;
  String? messagesNextCursor;

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

  String? get currentUserId => _currentUserId;

  /// Open a conversation and load the latest messages (limit 50).
  Future<void> openConversation(String conversationId) async {
    if (conversationId == currentConversationId) return;
    currentConversationId = conversationId;
    messagesLoading = true;
    messages = [];
    messagesNextCursor = null;
    hasMoreMessages = false;
    notifyListeners();

    final resp = await ChatRepository.getConversationMessages(conversationId, limit: 50);
    messages = resp.data ?? [];
    messagesNextCursor = resp.nextCursor;
    hasMoreMessages = resp.hasMore ?? false;
    messagesLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreMessages() async {
    if (!hasMoreMessages || messagesNextCursor == null || currentConversationId == null) return;
    final resp = await ChatRepository.getConversationMessages(currentConversationId!, limit: 50, cursor: messagesNextCursor);
    final more = resp.data ?? [];
    messages.addAll(more);
    messagesNextCursor = resp.nextCursor;
    hasMoreMessages = resp.hasMore ?? false;
    notifyListeners();
  }

  /// Called when a message is received from the socket.
  void addIncomingMessage(Message msg) {
    if (msg.conversationId != null && msg.conversationId == currentConversationId) {
      messages.insert(0, msg);
      notifyListeners();
      return;
    }

    if (conversations != null) {
      final idx = conversations!.indexWhere((c) => c.id == msg.conversationId);
      if (idx != -1) {
        final conv = conversations![idx];
        conv.lastMessage = msg.content;
        conv.lastMessageAt = msg.sentAt ?? DateTime.now().toUtc().toIso8601String();
        conv.unreadCount = (conv.unreadCount ?? 0) + 1;
        notifyListeners();
        return;
      }
    }
  }

  /// Optimistic send: insert a temporary message locally then attempt to send.
  Future<void> sendMessage(String content, String receiverId) async {
    if (content.isEmpty) return;
    final tmpId = 'tmp-${DateTime.now().millisecondsSinceEpoch}';
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
    notifyListeners();

    final sent = await ChatRepository.sendMessage(conversationId: currentConversationId, receiverId: receiverId, content: content, messageType: 'text');

    if (sent != null) {
      final idx = messages.indexWhere((m) => m.id == tmpId);
      if (idx != -1) messages[idx] = sent;
    } else {
      final idx = messages.indexWhere((m) => m.id == tmpId);
      if (idx != -1) messages[idx].status = 'failed';
    }
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
}

enum ChatScreenState {
  loading,
  complete,
}
