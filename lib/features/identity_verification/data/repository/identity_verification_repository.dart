import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/identity_verification/data/models/identity_verification_models.dart';

/// Talks to the Walima backend verification endpoints. The backend is the only
/// component that talks to Didit (guide §15).
///
/// All responses are wrapped by the global transform interceptor as:
/// `{ code, message, response: { data, message }, traceId }`.
/// The helpers below unwrap down to the inner `response.data`.
class IdentityVerificationRepository {
  const IdentityVerificationRepository._();

  /// `POST /api/v1/verification/session`
  ///
  /// Creates (or resumes) a Didit session. The backend returns the existing
  /// non-terminal session when one is active, and marks the user as `pending`.
  static Future<ApiResponse<CreateVerificationSessionData>> createSession({
    bool isIframe = false,
  }) async {
    try {
      final response = await DioClient().post(
        AppUrls.verificationSession,
        isTokenRequired: true,
        data: <String, dynamic>{'isIframe': isIframe},
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      final data = _innerObject(response.data);
      if (data == null) {
        return ApiResponse.error(
          message: 'Unexpected verification session response.',
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.success(
        data: CreateVerificationSessionData.fromJson(data),
        message: _innerMessage(response.data) ?? response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _mapError(e);
    }
  }

  /// `GET /api/v1/verification/status`
  ///
  /// Source of truth for the current screen. The backend syncs the latest
  /// session with Didit before returning when possible.
  static Future<ApiResponse<IdentityVerificationStatusData>>
      getStatus() async {
    try {
      final response = await DioClient().get(
        AppUrls.verificationStatus,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      final data = _innerObject(response.data);
      if (data == null) {
        return ApiResponse.error(
          message: 'Unexpected verification status response.',
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.success(
        data: IdentityVerificationStatusData.fromJson(data),
        message: _innerMessage(response.data) ?? response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _mapError(e);
    }
  }

  /// `GET /api/v1/verification/sessions`
  ///
  /// All sessions for the current user, newest first. Useful for history but
  /// not required for the main UX.
  static Future<ApiResponse<List<LatestSession>>> getSessions() async {
    try {
      final response = await DioClient().get(
        AppUrls.verificationSessions,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      final data = _innerList(response.data);
      final sessions = data
          .whereType<Map>()
          .map((item) => LatestSession.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);

      return ApiResponse.success(
        data: sessions,
        message: _innerMessage(response.data) ?? response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _mapError(e);
    }
  }

  /// Unwraps the envelope to the inner `response` map (`{ data, message }`).
  static Map<String, dynamic>? _container(dynamic body) {
    if (body is! Map) return null;
    final response = body['response'];
    if (response is Map) return Map<String, dynamic>.from(response);
    return Map<String, dynamic>.from(body);
  }

  /// Unwraps the envelope to `response.data` as an object.
  static Map<String, dynamic>? _innerObject(dynamic body) {
    final container = _container(body);
    final data = container?['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  /// Unwraps the envelope to `response.data` as a list.
  static List<dynamic> _innerList(dynamic body) {
    final container = _container(body);
    final data = container?['data'];
    if (data is List) return data;
    return const <dynamic>[];
  }

  static String? _innerMessage(dynamic body) {
    final container = _container(body);
    final message = container?['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();
    return null;
  }

  static ApiResponse<T> _mapError<T>(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      final message =
          (data is Map && data['message'] is String) ? data['message'] : null;
      return ApiResponse.error(
        message: message ?? e.message ?? 'Request failed',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
    return ApiResponse.error(
      message: e.toString(),
      statusCode: 0,
    );
  }
}
