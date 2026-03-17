import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/chat/data/repository/chat_repository.dart';

class ChatProvider extends BaseChangeNotifier {
  ChatScreenState screenStates = ChatScreenState.complete;
  ChatScreenState loaderState = ChatScreenState.complete;


  int selectedTabIndex = 0;

  void setSelectedTab(int index) {
    if (index == selectedTabIndex) return;
    if (index < 0) return;
    selectedTabIndex = index;
    notifyListeners();
  }


  Future<void> getInitialData() async {
    updateViewState(loadingState: ChatScreenState.loading);
    await ChatRepository.getConnectableUserList();
    await ChatRepository.getConversation();
    updateViewState(screenStates: ChatScreenState.complete);
  }

  void updateViewState(
      {ChatScreenState? screenStates,
        ChatScreenState? loadingState}) {
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
