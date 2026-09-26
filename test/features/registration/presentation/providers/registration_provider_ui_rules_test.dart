import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
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

  test('self religion offers only Islam and Others', () async {
    final provider = RegistrationProvider();

    await provider.loadReligionData();

    expect(
      provider.religionOptions.map((option) => option.key),
      <String>['islam', 'others'],
    );
  });

  group('work sector and profession hierarchy in RegistrationProvider', () {
    const sampleProfessions = <LookupOption>[
      LookupOption(key: 'profession_businessman', label: 'Businessman'),
      LookupOption(
        key: 'profession_businessman_self_employed',
        label: 'Businessman / Self-Employed',
      ),
      LookupOption(key: 'profession_engineer', label: 'Engineer'),
      LookupOption(
        key: 'profession_doctor_healthcare',
        label: 'Doctor / Healthcare Professional',
      ),
      LookupOption(
        key: 'profession_it_software',
        label: 'IT / Software Professional',
      ),
      LookupOption(
        key: 'profession_government_officer',
        label: 'Government Officer / Civil Servant',
      ),
    ];

    test('initial state has no selected work sector', () {
      final provider = RegistrationProvider();
      expect(provider.hasSelectedWorkSector, isFalse);
      expect(provider.isNotWorking, isFalse);
      expect(provider.selectedWorkSector, isEmpty);
    });

    test('selecting Private Company filters out Businessman / Self-Employed',
        () {
      final provider = RegistrationProvider();
      provider.professionOptions = sampleProfessions;

      provider.selectWorkSectorCategory('Private Company');

      expect(provider.hasSelectedWorkSector, isTrue);
      expect(provider.isNotWorking, isFalse);
      expect(
        provider.professionDropdownItems,
        isNot(contains('Businessman / Self-Employed')),
      );
      expect(
        provider.professionDropdownItems,
        isNot(contains('Businessman')),
      );
      expect(
        provider.professionDropdownItems,
        contains('Engineer'),
      );
    });

    test(
        'switching from Business to Private Company clears invalid selected profession',
        () {
      final provider = RegistrationProvider();
      provider.professionOptions = sampleProfessions;

      // Select Business / Self-Employed sector
      provider.selectWorkSectorCategory('Business / Self-Employed');
      expect(
        provider.professionDropdownItems,
        contains('Businessman / Self-Employed'),
      );

      // Select Businessman / Self-Employed
      provider.selectYouWorkAs('Businessman / Self-Employed');
      expect(provider.youWorkAsController.text, 'Businessman / Self-Employed');

      // Now switch sector to Private Company
      provider.selectWorkSectorCategory('Private Company');

      // Profession must be cleared because Businessman / Self-Employed is invalid in Private Company
      expect(provider.youWorkAsController.text, isEmpty);
      expect(provider.selectedYouWorkAs, isNull);
    });

    test(
        'selecting Not Working clears profession and company, sets isNotWorking',
        () {
      final provider = RegistrationProvider();
      provider.professionOptions = sampleProfessions;

      // Set some initial values
      provider.selectWorkSectorCategory('Private Company');
      provider.selectYouWorkAs('Engineer');
      provider.currentCompanyNameController.text = 'Acme Corp';

      expect(provider.youWorkAsController.text, 'Engineer');
      expect(provider.currentCompanyNameController.text, 'Acme Corp');

      // Select Not Working
      provider.selectWorkSectorCategory('Not Working');

      expect(provider.hasSelectedWorkSector, isTrue);
      expect(provider.isNotWorking, isTrue);
      expect(provider.professionDropdownItems, isEmpty);
      expect(provider.youWorkAsController.text, isEmpty);
      expect(provider.currentCompanyNameController.text, isEmpty);
    });
  });
}
