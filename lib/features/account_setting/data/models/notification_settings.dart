class NotificationSettings {
  const NotificationSettings({this.raw = const <String, dynamic>{}});

  final Map<String, dynamic> raw;

  /// Reads the first key from [keys] that exists anywhere in [raw]
  /// (including nested maps/lists) and returns its value as a trimmed,
  /// lower-cased string. Returns null if none is found.
  String? valueOf(List<String> keys) {
    for (final key in keys) {
      final found = _findValue(raw, key);
      if (found != null) {
        final str = found.toString().trim();
        if (str.isNotEmpty) return str.toLowerCase();
      }
    }
    return null;
  }

  static dynamic _findValue(dynamic node, String key) {
    if (node is Map) {
      if (node.containsKey(key) && node[key] != null) return node[key];
      for (final v in node.values) {
        final found = _findValue(v, key);
        if (found != null) return found;
      }
    } else if (node is List) {
      for (final v in node) {
        final found = _findValue(v, key);
        if (found != null) return found;
      }
    }
    return null;
  }

  static NotificationSettings fromAny(dynamic data) {
    final payload = _unwrapPayload(data);
    if (payload == null) return const NotificationSettings();
    return NotificationSettings(raw: Map<String, dynamic>.from(payload));
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
}
