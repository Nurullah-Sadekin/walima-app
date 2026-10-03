class ContactItem {
  const ContactItem({
    this.type,
    this.value,
    this.isPrimary,
    this.isVerified,
    this.label,
  });

  final String? type;
  final String? value;
  final bool? isPrimary;
  final bool? isVerified;
  final String? label;

  bool get isEmail => (type ?? '').toLowerCase() == 'email';
  bool get isPhone {
    final t = (type ?? '').toLowerCase();
    return t == 'phone' || t == 'phone_number' || t == 'mobile';
  }

  static ContactItem fromAny(dynamic data) {
    final map = _asMap(data);
    if (map == null) return const ContactItem();
    return ContactItem(
      type: _readString(map, const ['type']),
      value: _readString(map, const ['value']),
      isPrimary: _readBool(map, const ['isPrimary', 'is_primary']),
      isVerified: _readBool(map, const ['isVerified', 'is_verified']),
      label: _readString(map, const ['label']),
    );
  }

  Map<String, dynamic> toRequestJson() {
    return <String, dynamic>{
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (isPrimary != null) 'isPrimary': isPrimary,
      if (isVerified != null) 'isVerified': isVerified,
      if (label != null) 'label': label,
    };
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

  static bool? _readBool(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key)) {
        final v = map[key];
        if (v is bool) return v;
        if (v is String) {
          final lower = v.toLowerCase();
          if (lower == 'true') return true;
          if (lower == 'false') return false;
        }
      }
    }
    return null;
  }
}

class ContactSettings {
  const ContactSettings({
    this.id,
    this.userId,
    this.contacts = const <ContactItem>[],
    this.contactDisplayStatus,
  });

  final String? id;
  final String? userId;
  final List<ContactItem> contacts;
  final String? contactDisplayStatus;

  ContactItem? get primaryContact {
    if (contacts.isEmpty) return null;
    return contacts.firstWhere(
      (c) => c.isPrimary == true,
      orElse: () => contacts.first,
    );
  }

  static ContactSettings fromAny(dynamic data) {
    final payload = _unwrapPayload(data);
    if (payload == null) return const ContactSettings();

    final rawContacts = payload['contacts'];
    final parsedContacts = rawContacts is List
        ? rawContacts
            .map(ContactItem.fromAny)
            .where((c) => c.value != null || c.type != null)
            .toList(growable: false)
        : const <ContactItem>[];

    return ContactSettings(
      id: _readString(payload, const ['id']),
      userId: _readString(payload, const ['userId', 'user_id']),
      contacts: parsedContacts,
      contactDisplayStatus: _readString(
        payload,
        const ['contactDisplayStatus', 'contact_display_status'],
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
