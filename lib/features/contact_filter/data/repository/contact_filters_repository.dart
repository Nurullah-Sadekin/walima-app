import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/contact_filter/data/models/contact_filters_settings.dart';

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
    ContactFiltersSettings settings,
  ) async {
    try {
      final response = await DioClient().put(
        AppUrls.contactFilters,
        isTokenRequired: true,
        data: settings.toRequestJson(),
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

