class ViewContactInfo {
  const ViewContactInfo({
    this.email,
    this.phoneNumber,
    this.isVerified = false,
  });

  final String? email;
  final String? phoneNumber;
  final bool isVerified;

  static ViewContactInfo fromAny(dynamic data) {
    final payload = _unwrapPayload(data);

    final email = _readString(payload, const ['email', 'emailAddress']);
    final phone = _readString(payload, const [
      'phoneNumber',
      'phone',
      'mobile',
      'mobileNumber',
      'phone_number',
    ]);

    final isVerified =
        _readBool(payload, const ['isVerified', 'verified', 'is_verified']) ??
            _readBool(_asMap(payload?['profilePhoto']), const ['isVerified']) ??
            _readBool(_asMap(payload?['user']), const ['isVerified']) ??
            false;

    return ViewContactInfo(
      email: email,
      phoneNumber: phone,
      isVerified: isVerified,
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

  static String? _readString(
    Map<String, dynamic>? map,
    List<String> keys,
  ) {
    if (map == null) return null;
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value != null) {
        final str = value.toString().trim();
        if (str.isNotEmpty) return str;
      }
    }
    return null;
  }

  static bool? _readBool(
    Map<String, dynamic>? map,
    List<String> keys,
  ) {
    if (map == null) return null;
    for (final key in keys) {
      final value = map[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true' || normalized == 'yes' || normalized == '1') {
          return true;
        }
        if (normalized == 'false' ||
            normalized == 'no' ||
            normalized == '0') {
          return false;
        }
      }
    }
    return null;
  }
}

