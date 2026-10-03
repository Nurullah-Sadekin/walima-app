import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/features/recommended_preferences/data/models/request/update_preferences_request_body.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';

void main() {
  setUpAll(AppConfig.initialize);

  test('Open to All cities clears selected cities and is exclusive', () {
    final provider = RecommendedPreferencesProvider();

    provider.togglePreferableCity('Dhaka');
    provider.toggleOpenToAllCities();

    expect(provider.isOpenToAllCities, isTrue);
    expect(provider.preferableCity, isEmpty);

    provider.togglePreferableCity('Chittagong');

    expect(provider.isOpenToAllCities, isFalse);
    expect(provider.preferableCity, <String>['Chittagong']);
  });

  test('an empty city list is sent to clear saved city restrictions', () {
    final body = UpdatePreferencesRequestBody(preferredCities: <String>[]);

    expect(body.toJson()['preferredCities'], <String>[]);
  });
}
