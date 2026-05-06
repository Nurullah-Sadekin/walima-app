import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/contact_filter/data/models/contact_filters_settings.dart';

class ContactFiltersRepository {
  static Future<ApiResponse<ContactFiltersSettings>> getContactFilters() async {
    try {
      final response = await DioClient().get(
        AppUrls.contactFilters,
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.success(
        data: ContactFiltersSettings.fromAny(response.data),
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is DioException) {
        return ApiResponse.error(
          message: e.response?.data['message'] ?? e.message ?? 'Request failed',
          statusCode: e.response?.statusCode ?? 0,
        );
      }

      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse> updateContactFilters(
    ContactFiltersSettings settings, {
    ContactFiltersSettings? previous,
  }) async {
    try {
      final body = settings.diffRequestJson(previous);
      if (body.isEmpty) {
        return ApiResponse.success(
          data: null,
          message: 'No changes to save',
          statusCode: 200,
        );
      }
      final response = await DioClient().put(
        AppUrls.contactFilters,
        isTokenRequired: true,
        data: body,
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        return ApiResponse.error(
          message: e.response?.data['message'] ?? e.message ?? 'Request failed',
          statusCode: e.response?.statusCode ?? 0,
        );
      }

      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }
}

