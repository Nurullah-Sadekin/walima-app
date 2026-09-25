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
}
