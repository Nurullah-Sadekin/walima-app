class AccountSettings {
  const AccountSettings({
    this.firstName,
    this.lastName,
    this.email,
  });

  final String? firstName;
  final String? lastName;
  final String? email;

  Map<String, dynamic> toRequestJson() {
    return <String, dynamic>{
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      'email': email ?? '',
    };
  }

  static AccountSettings fromAny(dynamic data) {
    final payload = _unwrapPayload(data);
    if (payload == null) return const AccountSettings();

    return AccountSettings(
      firstName: _readString(payload, const ['firstName', 'first_name']),
      lastName: _readString(payload, const ['lastName', 'last_name']),
      email: _readString(payload, const ['email']),
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

  static String? _readString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key) && map[key] != null) {
        final str = map[key].toString().trim();
        if (str.isNotEmpty) return str;
      }
    }
    return null;
  }
}
