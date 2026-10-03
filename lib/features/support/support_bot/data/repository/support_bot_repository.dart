import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/support/support_bot/domain/model/support_bot_conversation.dart';
import 'package:walima_llc/features/support/support_bot/domain/model/support_bot_message.dart';
import 'package:walima_llc/features/support/support_bot/domain/model/support_bot_queued_response.dart';

class SupportBotRepository {
  static dynamic _unwrapEnvelope(dynamic data) {
    if (data is Map<String, dynamic>) return data['response'] ?? data;
    if (data is Map) return Map<String, dynamic>.from(data)['response'] ?? data;
    return data;
  }

  static Future<ApiResponse<SupportBotConversation>>
      createOrResumeConversation() async {
    final response = await DioClient().post(
      AppUrls.supportBotConversations,
      isTokenRequired: true,
    );

    if (!response.isSuccess) {
      return ApiResponse.error(
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    final payload = _unwrapEnvelope(response.data);
    if (payload is Map<String, dynamic>) {
      return ApiResponse.success(
        data: SupportBotConversation.fromJson(payload),
        message: response.message,
        statusCode: response.statusCode,
      );
    }
    if (payload is Map) {
      return ApiResponse.success(
        data:
            SupportBotConversation.fromJson(Map<String, dynamic>.from(payload)),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(
      message: 'Invalid conversation response',
      statusCode: response.statusCode,
    );
  }

  static Future<ApiResponse<List<SupportBotMessage>>> getMessages({
    required String conversationId,
    int page = 1,
    int size = 50,
  }) async {
    final endpoint = AppUrls.supportBotMessages
        .replaceFirst('{conversationId}', conversationId);
    final response = await DioClient().get(
      endpoint,
      queryParameters: {'page': page, 'size': size},
      isTokenRequired: true,
    );

    if (!response.isSuccess) {
      return ApiResponse.error(
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    final payload = _unwrapEnvelope(response.data);
    final raw = payload is Map
        ? payload['items'] ?? payload['data'] ?? payload
        : payload;
    if (raw is List) {
      final items = raw
          .whereType<Map>()
          .map((e) => SupportBotMessage.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return ApiResponse.success(
        data: items,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    // Some backends return { items: [...] }
    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);
      final itemsRaw = map['items'];
      if (itemsRaw is List) {
        final items = itemsRaw
            .whereType<Map>()
            .map(
              (e) => SupportBotMessage.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
        return ApiResponse.success(
          data: items,
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.success(
      data: const <SupportBotMessage>[],
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  static Future<ApiResponse<SupportBotQueuedResponse>> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final endpoint = AppUrls.supportBotSendMessage
        .replaceFirst('{conversationId}', conversationId);
    final response = await DioClient().post(
      endpoint,
      data: {'content': content},
      isTokenRequired: true,
    );

    if (!response.isSuccess) {
      return ApiResponse.error(
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    final payload = _unwrapEnvelope(response.data);
    if (payload is Map<String, dynamic>) {
      return ApiResponse.success(
        data: SupportBotQueuedResponse.fromJson(payload),
        message: response.message,
        statusCode: response.statusCode,
      );
    }
    if (payload is Map) {
      return ApiResponse.success(
        data: SupportBotQueuedResponse.fromJson(
          Map<String, dynamic>.from(payload),
        ),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(
      message: 'Invalid queued response',
      statusCode: response.statusCode,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> escalate({
    required String conversationId,
  }) async {
    final endpoint = AppUrls.supportBotEscalate
        .replaceFirst('{conversationId}', conversationId);
    final response = await DioClient().post(
      endpoint,
      isTokenRequired: true,
    );

    if (!response.isSuccess) {
      return ApiResponse.error(
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    final payload = _unwrapEnvelope(response.data);
    if (payload is Map<String, dynamic>) {
      return ApiResponse.success(
        data: payload,
        message: response.message,
        statusCode: response.statusCode,
      );
    }
    if (payload is Map) {
      return ApiResponse.success(
        data: Map<String, dynamic>.from(payload),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.success(
      data: const <String, dynamic>{},
      message: response.message,
      statusCode: response.statusCode,
    );
  }
}
