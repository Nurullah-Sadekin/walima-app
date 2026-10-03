class UpdateProfileSectionRequestBody {
  UpdateProfileSectionRequestBody({
    required this.fields,
  });

  final Map<String, dynamic> fields;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    void addValue(String key, dynamic value) {
      final normalized = _normalizeValue(value);
      if (normalized == null) {
        return;
      }
      map[key] = normalized;
    }

    fields.forEach(addValue);
    return map;
  }

  dynamic _normalizeValue(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final normalized = value.trim();
      return normalized.isEmpty ? null : normalized;
    }

    if (value is List) {
      final normalized = value
          .map(_normalizeValue)
          .where((item) => item != null)
          .cast<dynamic>()
          .toList(growable: false);
      return normalized.isEmpty ? null : normalized;
    }

    if (value is Map) {
      final normalized = <String, dynamic>{};
      value.forEach((key, item) {
        final safeValue = _normalizeValue(item);
        if (safeValue != null) {
          normalized[key.toString()] = safeValue;
        }
      });
      return normalized.isEmpty ? null : normalized;
    }

    return value;
  }
}
