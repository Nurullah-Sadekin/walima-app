class MessagesSettings {
  const MessagesSettings({
    this.autoMessageOnConnect,
    this.messageOnConnect,
    this.messageOnAccept,
    this.messageOnRemind,
  });

  final bool? autoMessageOnConnect;
  final String? messageOnConnect;
  final String? messageOnAccept;
  final String? messageOnRemind;

  Map<String, dynamic> toRequestJson() {
    return <String, dynamic>{
      if (autoMessageOnConnect != null)
        'autoMessageOnConnect': autoMessageOnConnect,
      if (messageOnConnect != null) 'messageOnConnect': messageOnConnect,
      if (messageOnAccept != null) 'messageOnAccept': messageOnAccept,
      if (messageOnRemind != null) 'messageOnRemind': messageOnRemind,
    };
  }

  static MessagesSettings fromAny(dynamic data) {
    final payload = _unwrapPayload(data);
    if (payload == null) return const MessagesSettings();

    return MessagesSettings(
      autoMessageOnConnect: _readBool(
        payload,
        const [
          'autoMessageOnConnect',
          'auto_message_on_connect',
          'autoMessageConnect',
          'auto_message_connect',
          'isAutoMessageOnConnect',
        ],
      ),
      messageOnConnect: _readString(
        payload,
        const ['messageOnConnect', 'message_on_connect', 'connectMessage'],
      ),
      messageOnAccept: _readString(
        payload,
        const ['messageOnAccept', 'message_on_accept', 'acceptMessage'],
      ),
      messageOnRemind: _readString(
        payload,
        const ['messageOnRemind', 'message_on_remind', 'remindMessage'],
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
        final str = map[key].toString();
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
        if (v is num) return v != 0;
        if (v is String) {
          final lower = v.toLowerCase().trim();
          if (lower == 'true' || lower == '1' || lower == 'yes') return true;
          if (lower == 'false' || lower == '0' || lower == 'no') return false;
        }
      }
    }
    return null;
  }
}
