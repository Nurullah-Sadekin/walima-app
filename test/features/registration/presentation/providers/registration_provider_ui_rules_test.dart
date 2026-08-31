import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';

void main() {
  setUpAll(AppConfig.initialize);

  test('registration UI rules match the client report', () {
    final provider = RegistrationProvider();

    expect(RegistrationProvider.hobbiesSelectionMinimum, 5);
    expect(
      provider.dietDataList.map((item) => item.name),
      isNot(contains('Jain Vegetarian')),
    );
    expect(
      provider.registrationMaritalStatusDataList.map((item) => item.name),
      <String>[
        'Never Married',
        'Married',
        'Divorced',
        'Widowed',
        'Separated',
      ],
    );
    expect(provider.siblingCountList.first.value, '0');
    expect(provider.siblingCountList.last.name, '10+');
    expect(provider.siblingCountList.last.value, '10');
  });

  test('email is the visible default verification channel', () {
    final provider = RegistrationProvider();

    expect(provider.selectedVerificationType, 'email');
    expect(
      provider.verificationList
          .singleWhere((item) => item.name == 'Email')
          .isSelected,
      isTrue,
    );
  });
}
