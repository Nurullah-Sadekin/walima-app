import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/connectable_user_response.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_list.dart';

class ChatRepository {

  static Future<ConnectableUserResponse> getConnectableUserList() async {
    try {
      final response = await DioClient().get(AppUrls.getConnectableUsers, isTokenRequired: true);
      return ConnectableUserResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return ConnectableUserResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<ConversationListResponse> getConversation() async {
    try {
      final response = await DioClient().get(AppUrls.getUserConversations, isTokenRequired: true);
      return ConversationListResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException ? e.response?.data['message'] ?? e.message : e.toString();
      return ConversationListResponse(code: 'FAILED', message: errorMessage);
    }
  }
}