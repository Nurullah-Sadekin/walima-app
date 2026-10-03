import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/chat/data/model/response/connectable_user_response.dart';
import 'package:walima_llc/features/chat/data/model/response/conversation_list.dart';
import 'package:walima_llc/features/chat/data/model/response/conversation_messages_response.dart';

class ChatRepository {
  static Future<ConnectableUserResponse> getConnectableUserList() async {
    try {
      final response = await DioClient().get(
        AppUrls.getConnectableUsers,
        isTokenRequired: true,
      );
      return ConnectableUserResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return ConnectableUserResponse(code: 'FAILED', message: errorMessage);
    }
  }

  static Future<ConversationListResponse> getConversation() async {
    try {
      final response = await DioClient().get(
        AppUrls.getUserConversations,
        isTokenRequired: true,
      );
      return ConversationListResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return ConversationListResponse(code: 'FAILED', message: errorMessage);
    }
  }

  /// Fetch paginated messages for a conversation.
  static Future<ConversationMessagesResponse> getConversationMessages(
    String conversationId, {
    int limit = 50,
    String? cursor,
  }) async {
    try {
      final path = AppUrls.getConversationMessages.replaceAll(
        '{conversationId}',
        conversationId,
      );
      final response = await DioClient().get(
        path,
        isTokenRequired: true,
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );
      final payload = response.data['response'] ?? response.data;
      return ConversationMessagesResponse.fromJson(payload);
    } catch (e) {
      return ConversationMessagesResponse();
    }
  }

  /// Send a message. If `conversationId` is null the server may create a new conversation.
  static Future<Message?> sendMessage({
    String? conversationId,
    required String receiverId,
    required String content,
    String messageType = 'text',
  }) async {
    try {
      final body = {
        if (conversationId != null) 'conversationId': conversationId,
        'receiverId': receiverId,
        'content': content,
        'messageType': messageType,
      };
      final response = await DioClient().post(
        AppUrls.sendMessage,
        data: body,
        isTokenRequired: true,
      );
      final payload = response.data['response'] ?? response.data;
      if (payload is Map && payload['data'] != null) {
        return Message.fromJson(payload['data']);
      }
      if (payload is Map && payload['id'] != null) {
        return Message.fromJson(payload);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
