import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/domain/work_sector_hierarchy.dart';

void main() {
  group('WorkSectorHierarchy', () {
    test('returns only top-level categories as roots', () {
      const hierarchy = WorkSectorHierarchy(<LookupOption>[
        LookupOption(key: 'employed', label: 'Employed'),
        LookupOption(
            key: 'public', label: 'Public sector', parentKey: 'employed',),
        LookupOption(
            key: 'private', label: 'Private sector', parentKey: 'employed',),
        LookupOption(key: 'business', label: 'Business'),
      ]);

      expect(hierarchy.roots.map((option) => option.key),
          <String>['employed', 'business'],);
      expect(hierarchy.childrenOf('employed').map((option) => option.key),
          <String>['public', 'private'],);
    });

    test('treats a flat legacy response as selectable roots', () {
      const hierarchy = WorkSectorHierarchy(<LookupOption>[
        LookupOption(key: 'business', label: 'Business'),
        LookupOption(key: 'not_working', label: 'Not working'),
      ]);

      expect(hierarchy.roots, hasLength(2));
      expect(hierarchy.childrenOf('business'), isEmpty);
    });
  });

  group('resolveWorkSectorType', () {
    test('resolves display labels and keys correctly', () {
      expect(resolveWorkSectorType('Private Company'),
          WorkSectorType.privateCompany,);
      expect(resolveWorkSectorType('private_company'),
          WorkSectorType.privateCompany,);
      expect(resolveWorkSectorType('Business / Self-Employed'),
          WorkSectorType.business,);
      expect(resolveWorkSectorType('business'), WorkSectorType.business);
      expect(resolveWorkSectorType('Government / Public Sector'),
          WorkSectorType.government,);
      expect(resolveWorkSectorType('government'), WorkSectorType.government);
      expect(resolveWorkSectorType('Defense / Civil Services'),
          WorkSectorType.defense,);
      expect(resolveWorkSectorType('defense'), WorkSectorType.defense);
      expect(resolveWorkSectorType('Non-Profit / NGO'), WorkSectorType.ngo);
      expect(resolveWorkSectorType('ngo'), WorkSectorType.ngo);
      expect(resolveWorkSectorType('Freelancer / Remote'),
          WorkSectorType.freelancer,);
      expect(resolveWorkSectorType('freelancer'), WorkSectorType.freelancer);
      expect(resolveWorkSectorType('Not Working'), WorkSectorType.notWorking);
      expect(resolveWorkSectorType('not_working'), WorkSectorType.notWorking);
      expect(resolveWorkSectorType('Unknown Sector'), WorkSectorType.unknown);
      expect(resolveWorkSectorType(null), WorkSectorType.unknown);
      expect(resolveWorkSectorType(''), WorkSectorType.unknown);
    });
  });

  group('canonicalProfessionKey', () {
    test('normalizes labels and respects existing canonical keys', () {
      expect(
        canonicalProfessionKey(const LookupOption(
          key: 'profession_businessman_self_employed',
          label: 'Businessman / Self-Employed',
        ),),
        'profession_businessman_self_employed',
      );
      expect(
        canonicalProfessionKey(const LookupOption(
          key: 'some_random_key',
          label: 'Businessman / Self-Employed',
        ),),
        'profession_businessman_self_employed',
      );
      expect(
        canonicalProfessionKey(const LookupOption(
          key: 'some_random_key',
          label: 'Businessman',
        ),),
        'profession_businessman',
      );
      expect(
        canonicalProfessionKey(const LookupOption(
          key: 'some_random_key',
          label: 'IT / Software Professional',
        ),),
        'profession_it_software',
      );
    });
  });

  group('filterProfessionsForWorkSector', () {
    const allSampleProfessions = <LookupOption>[
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
        key: 'profession_teacher_educator',
        label: 'Teacher / Educator',
      ),
      LookupOption(
        key: 'profession_banker_finance',
        label: 'Banker / Finance Professional',
      ),
      LookupOption(
        key: 'profession_it_software',
        label: 'IT / Software Professional',
      ),
      LookupOption(
        key: 'profession_lawyer',
        label: 'Lawyer / Legal Professional',
      ),
      LookupOption(
        key: 'profession_accountant',
        label: 'Accountant / Auditor',
      ),
      LookupOption(
        key: 'profession_architect',
        label: 'Architect / Designer',
      ),
      LookupOption(
        key: 'profession_journalist_media',
        label: 'Journalist / Media Professional',
      ),
      LookupOption(
        key: 'profession_scientist_researcher',
        label: 'Scientist / Researcher',
      ),
      LookupOption(
        key: 'profession_government_officer',
        label: 'Government Officer / Civil Servant',
      ),
      LookupOption(
        key: 'profession_defense_civil_services',
        label: 'Defense / Civil Services',
      ),
      LookupOption(key: 'profession_freelancer', label: 'Freelancer'),
      LookupOption(key: 'profession_other', label: 'Other'),
    ];

    test('returns all professions if work sector is null or empty', () {
      expect(
        WorkSectorHierarchy.filterProfessionsForWorkSector(
            null, allSampleProfessions,),
        allSampleProfessions,
      );
      expect(
        WorkSectorHierarchy.filterProfessionsForWorkSector(
            '', allSampleProfessions,),
        allSampleProfessions,
      );
    });

    test('returns empty list for Not Working', () {
      final filtered = WorkSectorHierarchy.filterProfessionsForWorkSector(
        'Not Working',
        allSampleProfessions,
      );
      expect(filtered, isEmpty);

      final filteredKey = WorkSectorHierarchy.filterProfessionsForWorkSector(
        'not_working',
        allSampleProfessions,
      );
      expect(filteredKey, isEmpty);
    });

    test(
        'filters out Businessman / Self-Employed when sector is Private Company',
        () {
      final filtered = WorkSectorHierarchy.filterProfessionsForWorkSector(
        'Private Company',
        allSampleProfessions,
      );

      final labels = filtered.map((p) => p.label).toList();
      expect(labels, isNot(contains('Businessman')));
      expect(labels, isNot(contains('Businessman / Self-Employed')));
      expect(labels, isNot(contains('Government Officer / Civil Servant')));
      expect(labels, isNot(contains('Defense / Civil Services')));
      expect(labels, isNot(contains('Freelancer')));

      expect(labels, contains('Engineer'));
      expect(labels, contains('Doctor / Healthcare Professional'));
      expect(labels, contains('IT / Software Professional'));
      expect(labels, contains('Teacher / Educator'));
      expect(labels, contains('Banker / Finance Professional'));
      expect(labels, contains('Lawyer / Legal Professional'));
      expect(labels, contains('Accountant / Auditor'));
      expect(labels, contains('Architect / Designer'));
      expect(labels, contains('Journalist / Media Professional'));
      expect(labels, contains('Scientist / Researcher'));
      expect(labels, contains('Other'));
    });

    test(
        'includes Businessman and Businessman / Self-Employed when sector is Business',
        () {
      final filtered = WorkSectorHierarchy.filterProfessionsForWorkSector(
        'Business / Self-Employed',
        allSampleProfessions,
      );

      final labels = filtered.map((p) => p.label).toList();
      expect(labels, contains('Businessman'));
      expect(labels, contains('Businessman / Self-Employed'));
      expect(labels, contains('Engineer'));
      expect(labels, contains('Doctor / Healthcare Professional'));
      expect(labels, contains('Lawyer / Legal Professional'));
      expect(labels, contains('IT / Software Professional'));
      expect(labels, contains('Other'));

      expect(labels, isNot(contains('Government Officer / Civil Servant')));
      expect(labels, isNot(contains('Defense / Civil Services')));
      expect(labels, isNot(contains('Freelancer')));
    });

    test('includes Government Officer when sector is Government', () {
      final filtered = WorkSectorHierarchy.filterProfessionsForWorkSector(
        'Government / Public Sector',
        allSampleProfessions,
      );

      final labels = filtered.map((p) => p.label).toList();
      expect(labels, contains('Government Officer / Civil Servant'));
      expect(labels, isNot(contains('Businessman')));
      expect(labels, isNot(contains('Businessman / Self-Employed')));
      expect(labels, isNot(contains('Freelancer')));
    });

    test('isProfessionValidForSector validates profession correctly', () {
      expect(
        WorkSectorHierarchy.isProfessionValidForSector(
          'Private Company',
          'Businessman / Self-Employed',
          allSampleProfessions,
        ),
        isFalse,
      );
      expect(
        WorkSectorHierarchy.isProfessionValidForSector(
          'Private Company',
          'Engineer',
          allSampleProfessions,
        ),
        isTrue,
      );
      expect(
        WorkSectorHierarchy.isProfessionValidForSector(
          'Business / Self-Employed',
          'Businessman / Self-Employed',
          allSampleProfessions,
        ),
        isTrue,
      );
      expect(
        WorkSectorHierarchy.isProfessionValidForSector(
          'Not Working',
          'Engineer',
          allSampleProfessions,
        ),
        isFalse,
      );
    });
  });
}
