import 'package:walima_llc/core/global/enums/enums.dart';

class LookupOption {
  const LookupOption({
    required this.key,
    required this.label,
  });

  factory LookupOption.fromJson(Map<String, dynamic> json) {
    return LookupOption(
      key: (json['key'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
    );
  }

  final String key;
  final String label;
}

/// The single source of truth for religion dropdowns across the app. Kept in
/// lockstep with the web `Religion` enum — see [Religion].
final List<LookupOption> religionLookupOptions = Religion.values
    .map((item) => LookupOption(key: item.apiValue, label: item.label))
    .toList(growable: false);

/// Whether a religion key has a community lookup category server-side.
/// `open_to_all` and `others` do not, so web hides the community field for them
/// instead of issuing a request that always comes back empty.
///
/// Exposed as a top-level function because several call sites also import a
/// `Religion` response model, which would collide with the enum name.
bool religionHasCommunityOptions(String? religionKey) {
  final normalized = religionKey?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return false;
  return !Religion.valuesWithoutCommunity.contains(normalized);
}
