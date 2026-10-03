import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/network/dio_client.dart';

class BiodataRepository {
  const BiodataRepository._();

  static Future<Map<String, dynamic>> getBiodataProfile() async {
    final response = await DioClient().get(
      AppUrls.getBiodataProfile,
      isTokenRequired: true,
    );

    if (!response.isSuccess) {
      throw Exception(response.message);
    }

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final nested = data['response'];
      if (nested is Map<String, dynamic>) return nested;
      if (nested is Map) return Map<String, dynamic>.from(nested);
      return data;
    }

    if (data is Map) {
      final mapped = Map<String, dynamic>.from(data);
      final nested = mapped['response'];
      if (nested is Map<String, dynamic>) return nested;
      if (nested is Map) return Map<String, dynamic>.from(nested);
      return mapped;
    }

    throw Exception('Unable to load biodata profile');
  }
}
