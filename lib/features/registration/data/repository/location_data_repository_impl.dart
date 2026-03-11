import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';
import 'package:flutter_boilerplate/features/registration/domain/repository/location_data_repository.dart';

class LocationDataRepositoryImpl implements LocationDataRepository {
  static const String _countryAssetPath =
      'lib/features/registration/domain/json/country_state.json';
  static const String _residencyAssetPath =
      'lib/features/registration/domain/json/residency_status_options.json';

  List<CountryLocationModel>? _cachedCountries;
  List<ResidencyStatusOptionModel>? _cachedResidencyStatuses;

  @override
  Future<List<CountryLocationModel>> getCountries() async {
    if (_cachedCountries != null) {
      return _cachedCountries!;
    }

    final jsonString = await rootBundle.loadString(_countryAssetPath);
    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      _cachedCountries = <CountryLocationModel>[];
      return _cachedCountries!;
    }

    final countries = <CountryLocationModel>[];
    for (final item in decoded) {
      if (item is Map<String, dynamic>) {
        countries.add(CountryLocationModel.fromJson(item));
      } else if (item is Map) {
        countries.add(
          CountryLocationModel.fromJson(Map<String, dynamic>.from(item)),
        );
      }
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
    final normalized = country.trim().toLowerCase();
    if (normalized.isEmpty) {
      return <String>[];
    }

    final countries = await getCountries();
    CountryLocationModel? selectedCountry;

    for (final countryItem in countries) {
      if (countryItem.name.toLowerCase() == normalized) {
        selectedCountry = countryItem;
        break;
      }
    }

    if (selectedCountry == null) {
      return <String>[];
    }

    return selectedCountry.cityNames(
      includeCapitalWhenEmpty: includeCapitalWhenNoStates,
    );
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
