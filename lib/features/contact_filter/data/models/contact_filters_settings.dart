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
      if (ageStart != null) 'ageMin': ageStart,
      if (ageEnd != null) 'ageMax': ageEnd,
      if (heightStart != null) 'heightMin': heightStart,
      if (heightEnd != null) 'heightMax': heightEnd,
      if (maritalStatus != null) 'maritalStatuses': maritalStatus,
      if (religion != null) 'religions': religion,
      if (community != null) 'communities': community,
      if (motherTongue != null) 'motherTongues': motherTongue,
      if (countryLivingIn != null) 'countriesLivingIn': countryLivingIn,
      if (workingWith != null) 'workingWiths': workingWith,
      if (annualIncome != null) 'annualIncomes': annualIncome,
    };
  }

  /// Build a PUT body containing only the fields that differ from [previous].
  /// If [previous] is null, returns all non-null fields.
  Map<String, dynamic> diffRequestJson(ContactFiltersSettings? previous) {
    if (previous == null) return toRequestJson();

    final body = <String, dynamic>{};

    if (ageStart != null && ageStart != previous.ageStart) {
      body['ageMin'] = ageStart;
    }
    if (ageEnd != null && ageEnd != previous.ageEnd) {
      body['ageMax'] = ageEnd;
    }
    if (heightStart != null && heightStart != previous.heightStart) {
      body['heightMin'] = heightStart;
    }
    if (heightEnd != null && heightEnd != previous.heightEnd) {
      body['heightMax'] = heightEnd;
    }
    if (!_listEq(maritalStatus, previous.maritalStatus)) {
      body['maritalStatuses'] = maritalStatus ?? const <String>[];
    }
    if (!_listEq(religion, previous.religion)) {
      body['religions'] = religion ?? const <String>[];
    }
    if (!_listEq(community, previous.community)) {
      body['communities'] = community ?? const <String>[];
    }
    if (!_listEq(motherTongue, previous.motherTongue)) {
      body['motherTongues'] = motherTongue ?? const <String>[];
    }
    if (!_listEq(countryLivingIn, previous.countryLivingIn)) {
      body['countriesLivingIn'] = countryLivingIn ?? const <String>[];
    }
    if (!_listEq(workingWith, previous.workingWith)) {
      body['workingWiths'] = workingWith ?? const <String>[];
    }
    if (!_listEq(annualIncome, previous.annualIncome)) {
      body['annualIncomes'] = annualIncome ?? const <String>[];
    }
    return body;
  }

  static bool _listEq(List<String>? a, List<String>? b) {
    final sa = {...?a};
    final sb = {...?b};
    if (sa.length != sb.length) return false;
    return sa.containsAll(sb);
  }

  static ContactFiltersSettings fromAny(dynamic data) {
    final payload = _unwrapPayload(data);

    final age = _parseFlexibleRange(
      payload,
      rangeKeys: const ['ageRange', 'age_range'],
      minKeys: const ['ageMin', 'age_min', 'minAge', 'min_age'],
      maxKeys: const ['ageMax', 'age_max', 'maxAge', 'max_age'],
    );
    final height = _parseFlexibleRange(
      payload,
      rangeKeys: const ['heightRange', 'height_range'],
      minKeys: const ['heightMin', 'height_min', 'minHeight', 'min_height'],
      maxKeys: const ['heightMax', 'height_max', 'maxHeight', 'max_height'],
    );

    return ContactFiltersSettings(
      ageStart: age?.$1,
      ageEnd: age?.$2,
      heightStart: height?.$1,
      heightEnd: height?.$2,
      maritalStatus: _parseStringList(
        _readAny(payload, const [
          'maritalStatuses',
          'marital_statuses',
          'maritalStatus',
          'marital_status',
        ]),
      ),
      religion: _parseStringList(
        _readAny(payload, const ['religions', 'religion']),
      ),
      community: _parseStringList(
        _readAny(payload, const ['communities', 'community']),
      ),
      motherTongue: _parseStringList(
        _readAny(payload, const [
          'motherTongues',
          'mother_tongues',
          'motherTongue',
          'mother_tongue',
        ]),
      ),
      countryLivingIn: _parseStringList(
        _readAny(payload, const [
          'countriesLivingIn',
          'countries_living_in',
          'countryLivingIn',
          'country_living_in',
        ]),
      ),
      workingWith: _parseStringList(
        _readAny(payload, const [
          'workingWiths',
          'working_withs',
          'workingWith',
          'working_with',
        ]),
      ),
      annualIncome: _parseStringList(
        _readAny(payload, const [
          'annualIncomes',
          'annual_incomes',
          'annualIncome',
          'annual_income',
        ]),
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

  static (int, int)? _parseFlexibleRange(
    Map<String, dynamic>? payload, {
    required List<String> rangeKeys,
    required List<String> minKeys,
    required List<String> maxKeys,
  }) {
    if (payload == null) return null;

    final rangeValue = _readAny(payload, rangeKeys);
    final rangeResult = _parseIntRange(rangeValue);
    if (rangeResult != null) return rangeResult;

    final min = _toInt(_readAny(payload, minKeys));
    final max = _toInt(_readAny(payload, maxKeys));
    if (min != null && max != null) return (min, max);
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

