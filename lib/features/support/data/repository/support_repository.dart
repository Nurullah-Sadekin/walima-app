import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/support/domain/model/contact_support_request.dart';
import 'package:walima_llc/features/support/domain/model/contact_support_response.dart';

class SupportRepository {
  static Future<ApiResponse<ContactSupportResponse>> contactSupport({
    required ContactSupportRequest request,
    bool isTokenRequired = false,
  }) async {
    final response = await DioClient().post(
      AppUrls.contactSupport,
      data: request.toJson(),
      isTokenRequired: isTokenRequired,
    );

    if (!response.isSuccess) {
      return ApiResponse.error(
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ApiResponse.success(
        data: ContactSupportResponse.fromJson(data),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    if (data is Map) {
      return ApiResponse.success(
        data: ContactSupportResponse.fromJson(Map<String, dynamic>.from(data)),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.success(
      data: const ContactSupportResponse(code: 'SUCCESS', message: ''),
      message: response.message,
      statusCode: response.statusCode,
    );
  }
}
