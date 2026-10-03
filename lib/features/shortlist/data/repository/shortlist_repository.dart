import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/shortlist/data/models/shortlist_models.dart';

/// Member shortlist endpoints. The owner is derived from the JWT; no body.
class ShortlistRepository {
  const ShortlistRepository._();

  /// Max page size accepted by the backend.
  static const maxPageSize = 50;

  /// `POST add-to-shortlist/{userId}` — 201, also when already shortlisted.
  /// 409 means the member is connected and cannot be shortlisted.
  static Future<ApiResponse<ShortlistAction>> add(String memberId) async {
    final response = await DioClient().post(
      AppUrls.addToShortlist(memberId),
      isTokenRequired: true,
    );
    return _action(response);
  }

  /// `DELETE remove-from-shortlist/{userId}` — 200, also when absent.
  static Future<ApiResponse<ShortlistAction>> remove(String memberId) async {
    final response = await DioClient().delete(
      AppUrls.removeFromShortlist(memberId),
      isTokenRequired: true,
    );
    return _action(response);
  }

  /// `GET {userId}/status` — connected members report `shortlisted: false`.
  static Future<ApiResponse<ShortlistAction>> status(String memberId) async {
    final response = await DioClient().get(
      AppUrls.getShortlistStatus(memberId),
      isTokenRequired: true,
    );
    return _action(response);
  }

  /// `GET get-all-shortlist?page&size` — newest first; size 1–50.
  static Future<ApiResponse<ShortlistPage>> getPage({
    int page = 1,
    int size = 20,
  }) async {
    final response = await DioClient().get(
      AppUrls.getShortlistedUsers,
      isTokenRequired: true,
      queryParameters: <String, dynamic>{
        'page': page < 1 ? 1 : page,
        'size': size.clamp(1, maxPageSize),
      },
    );
    if (!response.isSuccess) return _error(response);

    final payload = _payload(response.data);
    final rawList = payload?['data'];
    if (rawList is! List) {
      return ApiResponse.error(
        message: 'Unexpected shortlist response',
        statusCode: response.statusCode,
      );
    }
    final pagination = payload?['pagination'];
    return ApiResponse.success(
      data: ShortlistPage(
        members: rawList
            .whereType<Map>()
            .map((m) => ShortlistedMember.fromJson(Map<String, dynamic>.from(m)))
            .where((m) => m.id.isNotEmpty)
            .toList(growable: false),
        pagination: ShortlistPagination.fromJson(
          pagination is Map ? Map<String, dynamic>.from(pagination) : null,
        ),
      ),
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  static ApiResponse<ShortlistAction> _action(ApiResponse response) {
    if (!response.isSuccess) return _error(response);
    final data = _payload(response.data)?['data'];
    if (data is! Map) {
      return ApiResponse.error(
        message: 'Unexpected shortlist response',
        statusCode: response.statusCode,
      );
    }
    return ApiResponse.success(
      data: ShortlistAction.fromJson(Map<String, dynamic>.from(data)),
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  static ApiResponse<T> _error<T>(ApiResponse response) => ApiResponse.error(
        message: response.message.isNotEmpty
            ? response.message
            : 'Shortlist request failed',
        statusCode: response.statusCode,
      );

  static Map<String, dynamic>? _payload(dynamic body) {
    if (body is! Map) return null;
    final payload = body['response'];
    return payload is Map ? Map<String, dynamic>.from(payload) : null;
  }
}
