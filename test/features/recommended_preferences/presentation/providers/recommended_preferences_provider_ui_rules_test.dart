import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';
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
        'Divorced',
        'Widowed',
        'Separated',
      ],
    );
  });

  test('saved partner preferences prefill controls and selections', () {
    final provider = RecommendedPreferencesProvider();
    provider.religionOptions = const [
      LookupOption(key: 'islam', label: 'Islam'),
    ];
    provider.communityOptions = const [
      LookupOption(key: 'sunni', label: 'Sunni'),
    ];
    provider.educationDataList = [
      SingleStringModel(name: 'Bachelor', value: 'bachelor'),
    ];
    provider.workSectorLookupOptions = const [
      LookupOption(key: 'private_company', label: 'Private Company'),
    ];
    provider.professionLookupOptions = const [
      LookupOption(key: 'engineer', label: 'Engineer'),
    ];
    provider.incomeRangeLookupOptions = const [
      LookupOption(key: '50k_100k', label: '50k - 100k'),
    ];

    provider.applySavedPreferences(Preferences.fromJson({
      'ageMin': 28,
      'ageMax': 38,
      'heightMin': 160,
      'heightMax': 185,
      'maritalStatusPreference': ['never_married'],
      'educationPreference': ['bachelor'],
      'religionPreference': ['islam'],
      'communityPreference': ['sunni'],
      'motherTonguePreference': ['Bangla'],
      'preferredCountries': ['Bangladesh'],
      'preferredCities': ['Sylhet'],
      'workingAsPreference': ['private_company'],
      'professionPreference': ['engineer'],
      'annualIncomePreference': ['50k_100k'],
    }));

    expect(provider.ageStart, 28);
    expect(provider.ageEnd, 38);
    expect(provider.heightStart, 160);
    expect(provider.heightEnd, 185);
    expect(provider.maritalStatusDataList.first.isSelected, isTrue);
    expect(provider.educationDataList.first.isSelected, isTrue);
    expect(provider.religionPreferenceController.text, 'Islam');
    expect(provider.communityPreferenceController.text, 'Sunni');
    expect(provider.motherTonguePreferenceController.text, 'Bangla');
    expect(provider.countryPreferenceController.text, 'Bangladesh');
    expect(provider.preferableCity, ['Sylhet']);
    expect(provider.workSectorPreferenceController.text, 'Private Company');
    expect(provider.professionPreferenceController.text, 'Engineer');
    expect(provider.annualIncomePreferenceController.text, '50k - 100k');

    provider.applySavedPreferences(null);
    expect(provider.ageStart, 25);
    expect(provider.preferableCity, isEmpty);
    expect(provider.educationDataList.first.isSelected, isFalse);
    expect(provider.religionPreferenceController.text, isEmpty);
  });
}
