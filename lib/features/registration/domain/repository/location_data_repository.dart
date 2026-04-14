import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';

abstract class LocationDataRepository {
  Future<List<CountryLocationModel>> getCountries();

  Future<PaginatedCountryResult> getCountriesPage({
    required int page,
    int size = 20,
    String keyword = '',
  });

  Future<List<String>> getCountryNames();

  Future<List<String>> getCitiesByCountry({
    required String country,
    bool includeCapitalWhenNoStates = true,
  });

  Future<PaginatedCityResult> getCitiesByCountryPage({
    required String country,
    required int page,
    int size = 100,
    String keyword = '',
  });

  Future<List<ResidencyStatusOptionModel>> getResidencyStatuses();

  Future<List<String>> getResidencyStatusNames();
}
