import 'package:walima_llc/features/registration/data/models/lookup_option.dart';

/// Builds the work-sector picker tree from the lookup API response.
///
/// Older responses are flat; in that case every option remains a selectable
/// root option. This lets the mobile app adopt nested lookup data without
/// inventing or maintaining a second taxonomy in the client.
class WorkSectorHierarchy {
  const WorkSectorHierarchy(this.options);

  final List<LookupOption> options;

  List<LookupOption> get roots {
    final knownKeys = options
        .map((option) => option.key.trim().toLowerCase())
        .where((key) => key.isNotEmpty)
        .toSet();

    return options.where((option) {
      final parentKey = option.parentKey?.trim();
      return parentKey == null ||
          parentKey.isEmpty ||
          !knownKeys.contains(parentKey.toLowerCase());
    }).toList(growable: false);
  }

  List<LookupOption> childrenOf(String parentKey) {
    final normalizedParentKey = parentKey.trim().toLowerCase();
    if (normalizedParentKey.isEmpty) return const <LookupOption>[];

    return options
        .where(
          (option) =>
              option.parentKey?.trim().toLowerCase() == normalizedParentKey,
        )
        .toList(growable: false);
  }

  LookupOption? find(String value) {
    final normalizedValue = value.trim().toLowerCase();
    if (normalizedValue.isEmpty) return null;

    for (final option in options) {
      if (option.key.trim().toLowerCase() == normalizedValue ||
          option.label.trim().toLowerCase() == normalizedValue) {
        return option;
      }
    }
    return null;
  }

  /// Filters a list of profession [LookupOption]s to only those relevant to
  /// the selected [workSector].
  static List<LookupOption> filterProfessionsForWorkSector(
    String? workSector,
    List<LookupOption> professions,
  ) {
    if (workSector == null || workSector.trim().isEmpty) {
      return professions;
    }

    final sectorType = resolveWorkSectorType(workSector);
    if (sectorType == WorkSectorType.notWorking) {
      return const <LookupOption>[];
    }

    final allowedKeys = allowedProfessionKeysBySector[sectorType];
    if (allowedKeys == null) {
      return professions;
    }

    return professions.where((option) {
      final cKey = canonicalProfessionKey(option);
      return allowedKeys.contains(cKey);
    }).toList(growable: false);
  }

  /// Determines whether a [profession] is allowed under the given [workSector].
  static bool isProfessionValidForSector(
    String? workSector,
    String? profession,
    List<LookupOption> allProfessions,
  ) {
    if (profession == null || profession.trim().isEmpty) return false;
    final validOptions =
        filterProfessionsForWorkSector(workSector, allProfessions);
    final normProf = profession.trim().toLowerCase();
    return validOptions.any(
      (opt) =>
          opt.label.trim().toLowerCase() == normProf ||
          opt.key.trim().toLowerCase() == normProf,
    );
  }
}

enum WorkSectorType {
  government,
  privateCompany,
  business,
  defense,
  ngo,
  freelancer,
  notWorking,
  unknown,
}

WorkSectorType resolveWorkSectorType(String? sector) {
  if (sector == null) return WorkSectorType.unknown;
  final normalized = sector.trim().toLowerCase();
  if (normalized.isEmpty) return WorkSectorType.unknown;

  if (normalized.contains('not working') ||
      normalized == 'not_working' ||
      normalized.contains('not_working')) {
    return WorkSectorType.notWorking;
  }
  if (normalized.contains('defense') || normalized.contains('civil service')) {
    return WorkSectorType.defense;
  }
  if (normalized.contains('government') || normalized.contains('public')) {
    return WorkSectorType.government;
  }
  if (normalized.contains('business') || normalized.contains('self')) {
    return WorkSectorType.business;
  }
  if (normalized.contains('private')) {
    return WorkSectorType.privateCompany;
  }
  if (normalized.contains('ngo') ||
      normalized.contains('non-profit') ||
      normalized.contains('non profit')) {
    return WorkSectorType.ngo;
  }
  if (normalized.contains('freelancer') || normalized.contains('remote')) {
    return WorkSectorType.freelancer;
  }
  return WorkSectorType.unknown;
}

String canonicalProfessionKey(LookupOption option) {
  final key = option.key.trim().toLowerCase();
  if (key.startsWith('profession_')) {
    return key;
  }
  final label = option.label.trim().toLowerCase();
  if (label.contains('self-employed') ||
      (label.contains('business') && label.contains('self'))) {
    return 'profession_businessman_self_employed';
  }
  if (label == 'businessman') {
    return 'profession_businessman';
  }
  if (label.contains('government')) {
    return 'profession_government_officer';
  }
  if (label.contains('defense')) {
    return 'profession_defense_civil_services';
  }
  if (label.contains('freelancer')) {
    return 'profession_freelancer';
  }
  if (label.contains('engineer')) {
    return 'profession_engineer';
  }
  if (label.contains('doctor') || label.contains('healthcare')) {
    return 'profession_doctor_healthcare';
  }
  if (label.contains('teacher') || label.contains('educator')) {
    return 'profession_teacher_educator';
  }
  if (label.contains('banker') || label.contains('finance')) {
    return 'profession_banker_finance';
  }
  if (label.contains('it') || label.contains('software')) {
    return 'profession_it_software';
  }
  if (label.contains('lawyer')) {
    return 'profession_lawyer';
  }
  if (label.contains('accountant')) {
    return 'profession_accountant';
  }
  if (label.contains('architect')) {
    return 'profession_architect';
  }
  if (label.contains('journalist') || label.contains('media')) {
    return 'profession_journalist_media';
  }
  if (label.contains('scientist') || label.contains('researcher')) {
    return 'profession_scientist_researcher';
  }
  if (label.contains('other')) {
    return 'profession_other';
  }
  return key;
}

const Map<WorkSectorType, Set<String>> allowedProfessionKeysBySector = {
  WorkSectorType.government: {
    'profession_government_officer',
    'profession_engineer',
    'profession_doctor_healthcare',
    'profession_teacher_educator',
    'profession_banker_finance',
    'profession_it_software',
    'profession_lawyer',
    'profession_accountant',
    'profession_architect',
    'profession_journalist_media',
    'profession_scientist_researcher',
    'profession_other',
  },
  WorkSectorType.privateCompany: {
    'profession_engineer',
    'profession_doctor_healthcare',
    'profession_teacher_educator',
    'profession_banker_finance',
    'profession_it_software',
    'profession_lawyer',
    'profession_accountant',
    'profession_architect',
    'profession_journalist_media',
    'profession_scientist_researcher',
    'profession_other',
  },
  WorkSectorType.business: {
    'profession_businessman',
    'profession_businessman_self_employed',
    'profession_engineer',
    'profession_doctor_healthcare',
    'profession_lawyer',
    'profession_accountant',
    'profession_architect',
    'profession_it_software',
    'profession_other',
  },
  WorkSectorType.defense: {
    'profession_defense_civil_services',
    'profession_government_officer',
    'profession_doctor_healthcare',
    'profession_engineer',
    'profession_it_software',
    'profession_other',
  },
  WorkSectorType.ngo: {
    'profession_teacher_educator',
    'profession_doctor_healthcare',
    'profession_engineer',
    'profession_it_software',
    'profession_lawyer',
    'profession_accountant',
    'profession_journalist_media',
    'profession_scientist_researcher',
    'profession_other',
  },
  WorkSectorType.freelancer: {
    'profession_freelancer',
    'profession_it_software',
    'profession_architect',
    'profession_journalist_media',
    'profession_engineer',
    'profession_accountant',
    'profession_teacher_educator',
    'profession_other',
  },
  WorkSectorType.notWorking: {},
};
