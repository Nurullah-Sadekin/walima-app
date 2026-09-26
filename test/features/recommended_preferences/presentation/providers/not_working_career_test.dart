import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/features/recommended_preferences/data/models/request/update_preferences_request_body.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';

void main() {
  setUpAll(AppConfig.initialize);

  test('Not Working hides career details and clears previous choices', () {
    final provider = RecommendedPreferencesProvider();
    provider.professionPreferenceController.text = 'Engineer';
    provider.annualIncomePreferenceController.text = '50k - 100k';

    provider.selectWorkSector('Not Working');

    expect(provider.isNotWorkingSector, isTrue);
    expect(provider.professionPreferenceController.text, isEmpty);
    expect(provider.annualIncomePreferenceController.text, isEmpty);

    provider.selectWorkSector('Private Company');
    expect(provider.isNotWorkingSector, isFalse);
  });

  test('empty career lists are sent to clear saved choices', () {
    final body = UpdatePreferencesRequestBody(
      professionPreference: <String>[],
      annualIncomePreference: <String>[],
    );

    expect(body.toJson()['professionPreference'], <String>[]);
    expect(body.toJson()['annualIncomePreference'], <String>[]);
  });
}
