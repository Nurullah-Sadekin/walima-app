import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';

void main() {
  setUpAll(AppConfig.initialize);

  test('recommended preference ranges match the requested limits', () {
    final provider = RecommendedPreferencesProvider();

    expect(provider.ageMinLimit, 18);
    expect(provider.ageMaxLimit, 60);
    expect(provider.heightMinLimit, 122);
    expect(provider.heightMaxLimit, 213);
    expect(provider.heightStart, 152);
    expect(provider.heightEnd, 180);
  });

  test('recommended marital statuses exclude unsupported choices', () {
    final provider = RecommendedPreferencesProvider();

    expect(
      provider.maritalStatusDataList.map((item) => item.name),
      <String>[
        'Never Married',
        'Married',
        'Divorced',
        'Widowed',
        'Separated',
      ],
    );
  });
}
