import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';

class LocationDataRepositoryImpl implements LocationDataRepository {
  static const String _residencyAssetPath =
      'lib/features/registration/domain/json/residency_status_options.json';
  static const int _pageSize = 100;

  final DioClient _dioClient = DioClient();
  List<CountryLocationModel>? _cachedCountries;
  final Map<String, List<String>> _cachedCitiesByCountry =
      <String, List<String>>{};
  List<ResidencyStatusOptionModel>? _cachedResidencyStatuses;

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  List<dynamic> _asList(dynamic value) {
    if (value is List) {
      return value;
    }
    return const <dynamic>[];
  }

  List<dynamic> _extractPaginatedData(dynamic payload) {
    final root = _asMap(payload);
    final response = _asMap(root?['response']);
    return _asList(response?['data']);
  }

  bool _extractHasNextPage(dynamic payload) {
    final root = _asMap(payload);
    final response = _asMap(root?['response']);
    final pagination = _asMap(response?['pagination']);
    return pagination?['hasNextPage'] == true;
  }

  @override
  Future<List<CountryLocationModel>> getCountries() async {
    if (_cachedCountries != null) {
      return _cachedCountries!;
    }

    final countries = <CountryLocationModel>[];
    var page = 1;

    while (true) {
      final response = await _dioClient.get(
        AppUrls.getAllCountry,
        queryParameters: <String, dynamic>{
          'page': page,
          'size': _pageSize,
          'sortBy': 'id',
          'sortOrder': 'ASC',
        },
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        throw Exception(response.message);
      }

      final pageItems = _extractPaginatedData(response.data);

      for (final item in pageItems) {
        if (item is Map<String, dynamic>) {
          countries.add(CountryLocationModel.fromJson(item));
        } else if (item is Map) {
          countries.add(
            CountryLocationModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }

      final hasNextPage = _extractHasNextPage(response.data);
      if (!hasNextPage || pageItems.isEmpty) {
        break;
      }

      page++;
    }

    _cachedCountries = countries;
    return _cachedCountries!;
  }

  @override
  Future<List<String>> getCountryNames() async {
    final countries = await getCountries();
    return countries.map((item) => item.name).toList(growable: false);
  }

  @override
  Future<List<String>> getCitiesByCountry({
    required String country,
    bool includeCapitalWhenNoStates = true,
  }) async {
    final normalized = country.trim();
    if (normalized.isEmpty) {
      return <String>[];
    }

    final cacheKey = normalized.toLowerCase();
    final cached = _cachedCitiesByCountry[cacheKey];
    if (cached != null) {
      return cached;
    }

    final cities = <String>[];
    final seen = <String>{};
    var page = 1;

    while (true) {
      final response = await _dioClient.get(
        AppUrls.getCityByCountry,
        queryParameters: <String, dynamic>{
          'page': page,
          'size': _pageSize,
          'sortBy': 'id',
          'sortOrder': 'ASC',
          'countries': cacheKey,
        },
        isTokenRequired: true,
      );

      if (!response.isSuccess) {
        throw Exception(response.message);
      }

      final pageItems = _extractPaginatedData(response.data);
      for (final item in pageItems) {
        final cityMap = _asMap(item);
        final cityName = cityMap?['name']?.toString().trim() ?? '';
        if (cityName.isEmpty) {
          continue;
        }

        final marker = cityName.toLowerCase();
        if (seen.add(marker)) {
          cities.add(cityName);
        }
      }

      final hasNextPage = _extractHasNextPage(response.data);
      if (!hasNextPage || pageItems.isEmpty) {
        break;
      }

      page++;
    }

    _cachedCitiesByCountry[cacheKey] = cities;
    return cities;
  }

  @override
  Future<List<ResidencyStatusOptionModel>> getResidencyStatuses() async {
    if (_cachedResidencyStatuses != null) {
      return _cachedResidencyStatuses!;
    }

    final jsonString = await rootBundle.loadString(_residencyAssetPath);
    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      _cachedResidencyStatuses = <ResidencyStatusOptionModel>[];
      return _cachedResidencyStatuses!;
    }

    final statuses = <ResidencyStatusOptionModel>[];
    for (final item in decoded) {
      if (item is Map<String, dynamic>) {
        statuses.add(ResidencyStatusOptionModel.fromJson(item));
      } else if (item is Map) {
        statuses.add(
          ResidencyStatusOptionModel.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }

    _cachedResidencyStatuses = statuses;
    return _cachedResidencyStatuses!;
  }

  @override
  Future<List<String>> getResidencyStatusNames() async {
    final statuses = await getResidencyStatuses();
    return statuses.map((item) => item.name).toList(growable: false);
  }
}
