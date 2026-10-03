import 'package:dio/dio.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/features/biodata/domain/model/bio_template.dart';

class BioTemplateRepository {
  Future<List<BioTemplate>> getBioTemplates() async {
    final payload = await _getPublicTemplatePayload(AppUrls.getBioTemplates);
    return _templatesFromPayload(
      payload,
      BioTemplate.fromJson,
    ).where((template) {
      return template.id.trim().isNotEmpty &&
          template.content.trim().isNotEmpty;
    }).toList(growable: false);
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

      final responseMap = _responseMap(response.data);
      final template = responseMap?['template'] ?? responseMap?['data'];
      if (template is Map<String, dynamic>) {
        return BioTemplate.fromJson(template);
      }
      if (template is Map) {
        return BioTemplate.fromJson(Map<String, dynamic>.from(template));
      }
      return null;
    } on DioException catch (error) {
      throw Exception(_extractDioMessage(error));
    }
  }

  Future<List<ConnectMessageTemplate>> getConnectMessageTemplates() async {
    final payload = await _getPublicTemplatePayload(
      AppUrls.getConnectMessageTemplates,
    );
    final templates = _templatesFromPayload(
      payload,
      ConnectMessageTemplate.fromJson,
    ).where((template) {
      return template.id.trim().isNotEmpty &&
          template.content.trim().isNotEmpty;
    }).toList(growable: false);

    if (templates.isNotEmpty) return templates;
    return fallbackConnectMessageTemplates;
  }

  List<ConnectMessageTemplate> get fallbackConnectMessageTemplates {
    return const <ConnectMessageTemplate>[
      ConnectMessageTemplate(
        id: '',
        title: 'Polite',
        content:
            'Assalamu Alaikum, I came across your profile and would like to connect with you.',
        priority: 3,
        isDefault: true,
      ),
      ConnectMessageTemplate(
        id: '',
        title: 'Family focused',
        content:
            'Assalamu Alaikum, your profile seems aligned with what my family and I are looking for. I would be glad to connect.',
        priority: 2,
      ),
      ConnectMessageTemplate(
        id: '',
        title: 'Short',
        content: 'Assalamu Alaikum, I would like to connect with you.',
        priority: 1,
      ),
    ];
  }

  Future<Map<String, dynamic>?> _getPublicTemplatePayload(
    String endpoint,
  ) async {
    try {
      final response = await DioClient().get(
        endpoint,
        isTokenRequired: false,
      );
      if (!response.isSuccess) {
        throw Exception(response.message);
      }

      return _responseMap(response.data);
    } on DioException catch (error) {
      throw Exception(_extractDioMessage(error));
    }
  }

  List<T> _templatesFromPayload<T>(
    Map<String, dynamic>? payload,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final templates = payload?['templates'] ?? payload?['data'];
    if (templates is! List) return <T>[];

    return templates
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Map<String, dynamic>? _responseMap(Object? data) {
    final payload = _map(data);
    final nestedResponse = payload?['response'];
    if (nestedResponse is Map<String, dynamic>) return nestedResponse;
    if (nestedResponse is Map) return Map<String, dynamic>.from(nestedResponse);
    return payload;
  }

  Map<String, dynamic>? _map(Object? data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  String _extractDioMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return error.message ?? 'Request failed';
  }
}
