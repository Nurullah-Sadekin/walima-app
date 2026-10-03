class PremiumSettings {
  const PremiumSettings({
    this.autoRenew,
    this.membershipTier,
    this.membershipExpiresAt,
    this.nextPaymentDate,
  });

  final bool? autoRenew;
  final String? membershipTier;
  final String? membershipExpiresAt;
  final String? nextPaymentDate;

  String? get currentPlan => membershipTier;

  PremiumSettings copyWith({
    bool? autoRenew,
    String? membershipTier,
    String? membershipExpiresAt,
    String? nextPaymentDate,
  }) {
    return PremiumSettings(
      autoRenew: autoRenew ?? this.autoRenew,
      membershipTier: membershipTier ?? this.membershipTier,
      membershipExpiresAt: membershipExpiresAt ?? this.membershipExpiresAt,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
    );
  }

  Map<String, dynamic> toRequestJson() {
    return <String, dynamic>{
      if (membershipTier != null) 'membershipTier': membershipTier,
      if (autoRenew != null) 'autoRenew': autoRenew,
      if (membershipExpiresAt != null)
        'membershipExpiresAt': membershipExpiresAt,
      if (nextPaymentDate != null) 'nextPaymentDate': nextPaymentDate,
    };
  }

  static PremiumSettings fromAny(dynamic data) {
    final payload = _unwrapPayload(data);
    if (payload == null) return const PremiumSettings();

    return PremiumSettings(
      autoRenew: _readBool(
        payload,
        const ['autoRenew', 'auto_renew', 'isAutoRenew', 'is_auto_renew'],
      ),
      membershipTier: _readTier(payload),
      membershipExpiresAt: _readString(
        payload,
        const [
          'membershipExpiresAt',
          'membership_expires_at',
          'expiresAt',
          'expires_at',
        ],
      ),
      nextPaymentDate: _readString(
        payload,
        const ['nextPaymentDate', 'next_payment_date'],
      ),
    );
  }

  static String? _readTier(Map<String, dynamic> payload) {
    final direct = _readString(
      payload,
      const [
        'membershipTier',
        'membership_tier',
        'currentPlan',
        'current_plan',
        'planName',
        'plan_name',
        'plan',
      ],
    );
    if (direct != null) return direct;

    final tierObj = _asMap(payload['membershipTier']) ??
        _asMap(payload['membership_tier']) ??
        _asMap(payload['currentPlan']) ??
        _asMap(payload['current_plan']) ??
        _asMap(payload['plan']);
    if (tierObj != null) {
      return _readString(
        tierObj,
        const ['name', 'title', 'displayName', 'display_name', 'label'],
      );
    }
    return null;
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
