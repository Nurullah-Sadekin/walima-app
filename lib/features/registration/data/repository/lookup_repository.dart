import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/registration/data/models/lookup_option.dart';

class LookupRepository {
  Future<List<LookupOption>> getLookups(
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
      final items = data is Map<String, dynamic>
          ? data['data']
          : data is Map
              ? Map<String, dynamic>.from(data)['data']
              : null;

      if (items is! List) {
        return const <LookupOption>[];
      }

      return items
          .whereType<Map>()
          .map((item) => LookupOption.fromJson(Map<String, dynamic>.from(item)))
          .where((item) => item.key.trim().isNotEmpty && item.label.trim().isNotEmpty)
          .toList(growable: false);
    } catch (e) {
      final message = e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
      throw Exception(message);
    }
  }
}
