class ContactFiltersSettings {
  const ContactFiltersSettings({
    this.ageStart,
    this.ageEnd,
    this.heightStart,
    this.heightEnd,
    this.maritalStatus,
    this.religion,
    this.community,
    this.motherTongue,
    this.countryLivingIn,
    this.workingWith,
    this.annualIncome,
  });

  final int? ageStart;
  final int? ageEnd;
  final int? heightStart;
  final int? heightEnd;

  final List<String>? maritalStatus;
  final List<String>? religion;
  final List<String>? community;
  final List<String>? motherTongue;
  final List<String>? countryLivingIn;
  final List<String>? workingWith;
  final List<String>? annualIncome;

  Map<String, dynamic> toRequestJson() {
    return <String, dynamic>{
      'ageRange': (ageStart != null && ageEnd != null) ? <int>[ageStart!, ageEnd!] : null,
      'heightRange':
          (heightStart != null && heightEnd != null) ? <int>[heightStart!, heightEnd!] : null,
      'maritalStatus': maritalStatus ?? const <String>[],
      'religion': religion ?? const <String>[],
      'community': community ?? const <String>[],
      'motherTongue': motherTongue ?? const <String>[],
      'countryLivingIn': countryLivingIn ?? const <String>[],
      'workingWith': workingWith ?? const <String>[],
      'annualIncome': annualIncome ?? const <String>[],
    }..removeWhere((key, value) => value == null);
  }

  static ContactFiltersSettings fromAny(dynamic data) {
    final payload = _unwrapPayload(data);

    final ageRange = _readAny(payload, const ['ageRange', 'age_range']);
    final heightRange = _readAny(payload, const ['heightRange', 'height_range']);

    final age = _parseIntRange(ageRange);
    final height = _parseIntRange(heightRange);

    return ContactFiltersSettings(
      ageStart: age?.$1,
      ageEnd: age?.$2,
      heightStart: height?.$1,
      heightEnd: height?.$2,
      maritalStatus: _parseStringList(
        _readAny(payload, const ['maritalStatus', 'marital_status']),
      ),
      religion: _parseStringList(
        _readAny(payload, const ['religion', 'religions']),
      ),
      community: _parseStringList(
        _readAny(payload, const ['community', 'communities']),
      ),
      motherTongue: _parseStringList(
        _readAny(payload, const ['motherTongue', 'mother_tongue']),
      ),
      countryLivingIn: _parseStringList(
        _readAny(payload, const ['countryLivingIn', 'country_living_in']),
      ),
      workingWith: _parseStringList(
        _readAny(payload, const ['workingWith', 'working_with']),
      ),
      annualIncome: _parseStringList(
        _readAny(payload, const ['annualIncome', 'annual_income']),
      ),
    );
  }

  static Map<String, dynamic>? _unwrapPayload(dynamic root) {
    final rootMap = _asMap(root);
    if (rootMap == null) return null;

    final response = _asMap(rootMap['response']);
    if (response != null) {
      final responseData = _asMap(response['data']);
      return responseData ?? response;
    }

    final data = _asMap(rootMap['data']);
    return data ?? rootMap;
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static dynamic _readAny(Map<String, dynamic>? map, List<String> keys) {
    if (map == null) return null;
    for (final key in keys) {
      if (map.containsKey(key)) return map[key];
    }
    return null;
  }

  static (int, int)? _parseIntRange(dynamic value) {
    if (value is List && value.length >= 2) {
      final start = _toInt(value[0]);
      final end = _toInt(value[1]);
      if (start != null && end != null) return (start, end);
    }
    final map = _asMap(value);
    if (map != null) {
      final start = _toInt(map['start'] ?? map['min'] ?? map['from']);
      final end = _toInt(map['end'] ?? map['max'] ?? map['to']);
      if (start != null && end != null) return (start, end);
    }
    return null;
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value
          .map((e) => e?.toString().trim())
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
    }
    final str = value.toString().trim();
    if (str.isEmpty) return null;
    return <String>[str];
  }
}

