import 'package:walima_llc/features/profile/data/model/response/get_complete_profile_response.dart';

class ProfileSectionProfileValueUseCase {
  const ProfileSectionProfileValueUseCase();

  String resolveValueByNormalizedKey(
    CompleteProfile? profile,
    String normalizedKey,
    String Function(String?) normalize,
  ) {
    if (profile == null) return '';
    final value =
        _extractValueByKey(profile.toJson(), normalizedKey, normalize);
    if (value == null) return '';
    if (value is List) {
      return value.map((item) => item.toString()).join(', ');
    }
    return value.toString();
  }

  dynamic _extractValueByKey(
    dynamic source,
    String normalizedKey,
    String Function(String?) normalize,
  ) {
    if (source is Map) {
      for (final entry in source.entries) {
        final key = entry.key.toString();
        if (normalize(key) == normalizedKey) {
          return entry.value;
        }
        final nested =
            _extractValueByKey(entry.value, normalizedKey, normalize);
        if (nested != null) return nested;
      }
      return null;
    }
    if (source is List) {
      for (final item in source) {
        final nested = _extractValueByKey(item, normalizedKey, normalize);
        if (nested != null) return nested;
      }
      return null;
    }
    return null;
  }
}
