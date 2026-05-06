import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/registration/data/models/request/upload_media_request_body.dart';
import 'package:walima_llc/features/registration/data/models/response/upload_media_response.dart';

class MediaRepository {
  Future<UploadMediaResponse> uploadMedia(UploadMediaRequestBody body) async {
    try {
      final response = await DioClient().post(
        AppUrls.uploadMedia,
        data: await body.toFormData(),
        options: Options(headers: <String, String>{'accept': '*/*'}),
        isTokenRequired: true,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UploadMediaResponse.fromJson(data);
      }
      if (data is Map) {
        return UploadMediaResponse.fromJson(Map<String, dynamic>.from(data));
      }

      return UploadMediaResponse(
        code: 'FAILED',
        message: response.message,
      );
    } catch (e) {
      final errorMessage = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      return UploadMediaResponse(code: 'FAILED', message: errorMessage);
    }
  }
}
