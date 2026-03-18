import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/connectable_user_response.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_list.dart';
import 'package:flutter_boilerplate/features/chat/data/repository/chat_repository.dart';

class ChatProvider extends BaseChangeNotifier {
  ChatScreenState screenStates = ChatScreenState.complete;
  ChatScreenState loaderState = ChatScreenState.complete;
  List<Users>? connectableUsers;
  List<Conversations>? conversations;
  String? _currentUserId;
  int selectedTabIndex = 0;

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
