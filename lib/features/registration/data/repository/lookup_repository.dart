import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/registration/data/models/lookup_option.dart';

class LookupRepository {
  Future<List<LookupOption>> getLookups(
    LookupCategory category, {
    String? search,
  }) async {
    return getLookupsBySlug(
      category.apiValue,
      search: search,
    );
  }

  Future<List<LookupOption>> getLookupsBySlug(
    String categorySlug, {
    String? search,
  }) async {
    try {
      final response = await DioClient().get(
        AppUrls.getLookups,
        isTokenRequired: true,
        queryParameters: <String, dynamic>{
          'categorySlug': categorySlug,
          if (search != null && search.trim().isNotEmpty) 'search': search,
        },
      );

      final data = response.data;
      final Map<String, dynamic>? payload = data is Map<String, dynamic>
          ? data
          : data is Map
              ? Map<String, dynamic>.from(data)
              : null;
      final nestedResponse = payload?['response'];
      final items = nestedResponse is Map<String, dynamic>
          ? nestedResponse['data']
          : nestedResponse is Map
              ? Map<String, dynamic>.from(nestedResponse)['data']
              : null;

      if (items is! List) {
        return const <LookupOption>[];
      }

      return items
          .whereType<Map>()
          .map((item) => LookupOption.fromJson(Map<String, dynamic>.from(item)))
          .where((item) =>
              item.key.trim().isNotEmpty && item.label.trim().isNotEmpty)
          .toList(growable: false);
    } catch (e) {
      final message = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      throw Exception(message);
    }
  }
}
