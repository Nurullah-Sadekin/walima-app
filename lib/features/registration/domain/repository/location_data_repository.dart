import 'package:flutter_boilerplate/features/registration/domain/location_data_model.dart';

abstract class LocationDataRepository {
  Future<List<CountryLocationModel>> getCountries();

  Future<List<String>> getCountryNames();

  Future<List<String>> getCitiesByCountry({
    required String country,
    bool includeCapitalWhenNoStates = true,
  });

  Future<List<ResidencyStatusOptionModel>> getResidencyStatuses();

  Future<List<String>> getResidencyStatusNames();
}
