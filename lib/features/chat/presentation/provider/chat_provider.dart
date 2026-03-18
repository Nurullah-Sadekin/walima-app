import 'dart:math';

import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/connectable_user_response.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_list.dart';
import 'package:flutter_boilerplate/features/chat/data/repository/chat_repository.dart';

class ChatProvider extends BaseChangeNotifier {
  ChatScreenState screenStates = ChatScreenState.complete;
  ChatScreenState loaderState = ChatScreenState.complete;
  List<Users>? connectableUsers;
  List<Conversations>? conversations;
  int selectedTabIndex = 0;

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
     if(data.response?.users != null){
      connectableUsers = data.response!.users;
     }
     else{
      connectableUsers = [];
     }
     updateViewState();
  }
  Future<void> getConversation() async {
    final data = await ChatRepository.getConversation();
      if(data.response?.conversations != null){
        conversations = data.response!.conversations;
      }
      else{
        conversations = [];
      }
      updateViewState();
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
