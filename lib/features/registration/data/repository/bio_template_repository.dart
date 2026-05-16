import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/registration/data/models/bio_template.dart';

class BioTemplateRepository {
  String _extractDioMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return e.message ?? 'Request failed';
  }

  Future<List<BioTemplate>> getBioTemplates() async {
    try {
      final response = await DioClient().get(
        AppUrls.getBioTemplates,
        isTokenRequired: false,
      );
      if (!response.isSuccess) {
        throw Exception(response.message);
      }

      final data = response.data;
      final Map<String, dynamic>? payload = data is Map<String, dynamic>
          ? data
          : data is Map
              ? Map<String, dynamic>.from(data)
              : null;

      final nestedResponse = payload?['response'];
      final Map<String, dynamic>? responseMap = nestedResponse is Map<String, dynamic>
          ? nestedResponse
          : nestedResponse is Map
              ? Map<String, dynamic>.from(nestedResponse)
              : null;

      final templates = responseMap?['templates'] ?? responseMap?['data'];
      if (templates is! List) {
        return const <BioTemplate>[];
      }

      return templates
          .whereType<Map>()
          .map((item) => BioTemplate.fromJson(Map<String, dynamic>.from(item)))
          .where((t) => t.id.trim().isNotEmpty && t.content.trim().isNotEmpty)
          .toList(growable: false);
    } on DioException catch (e) {
      throw Exception(_extractDioMessage(e));
    }
  }

  Future<BioTemplate?> suggestBioTemplate({
    required String maritalStatus,
    required String workingAs,
    required String workWith,
    required String religion,
    int? age,
  }) async {
    try {
      final response = await DioClient().post(
        AppUrls.suggestBioTemplate,
        isTokenRequired: false,
        data: <String, dynamic>{
          'maritalStatus': maritalStatus,
          'workingAs': workingAs,
          'workWith': workWith,
          'religion': religion,
          if (age != null) 'age': age,
        },
      );
      if (!response.isSuccess) {
        throw Exception(response.message);
      }

      final data = response.data;
      final Map<String, dynamic>? payload = data is Map<String, dynamic>
          ? data
          : data is Map
              ? Map<String, dynamic>.from(data)
              : null;

      final nestedResponse = payload?['response'];
      final Map<String, dynamic>? responseMap = nestedResponse is Map<String, dynamic>
          ? nestedResponse
          : nestedResponse is Map
              ? Map<String, dynamic>.from(nestedResponse)
              : null;

      final template = responseMap?['template'] ?? responseMap?['data'];
      if (template is Map<String, dynamic>) {
        return BioTemplate.fromJson(template);
      }
      if (template is Map) {
        return BioTemplate.fromJson(Map<String, dynamic>.from(template));
      }
      return null;
    } on DioException catch (e) {
      throw Exception(_extractDioMessage(e));
    }
  }
}
