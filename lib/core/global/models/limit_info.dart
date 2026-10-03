import 'dart:convert';

LimitInfo limitInfoFromJson(String source) =>
    LimitInfo.fromJson(json.decode(source) as Map<String, dynamic>);

String limitInfoToJson(LimitInfo data) => json.encode(data.toJson());

class LimitInfo {
  LimitInfo({
    this.key,
    this.name,
    this.displayOrder,
    this.valueType,
    this.used,
    this.limit,
    this.remaining,
    this.isUnlimited,
    this.resetDate,
    this.resetPeriod,
    this.tierValue,
  });

  factory LimitInfo.fromJson(Map<String, dynamic> json) {
    return LimitInfo(
      key: json['key']?.toString(),
      name: json['name']?.toString(),
      displayOrder: _asInt(json['displayOrder']),
      valueType: json['valueType']?.toString(),
      used: _asInt(json['used']) ?? 0,
      limit: _asInt(json['limit']),
      remaining: _asInt(json['remaining']),
      isUnlimited: json['isUnlimited'] == true,
      resetDate: json['resetDate']?.toString(),
      resetPeriod: json['resetPeriod']?.toString(),
      tierValue: json['tierValue']?.toString(),
    );
  }

  final String? key;
  final String? name;
  final int? displayOrder;
  final String? valueType;
  final int? used;
  final int? limit;
  final int? remaining;
  final bool? isUnlimited;
  final String? resetDate;
  final String? resetPeriod;
  final String? tierValue;

  bool get unlimited => isUnlimited == true;
  bool get isCounter => valueType == 'counter';
  bool get isBoolean => valueType == 'boolean';
  bool get isTier => valueType == 'tier';
  bool get isEnabled => unlimited || (remaining ?? 0) > 0;

  DateTime? get parsedResetDate {
    final value = resetDate;
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  bool canConsume([int amount = 1]) {
    if (amount <= 0) return true;
    if (unlimited) return true;
    if (isCounter) return (remaining ?? 0) >= amount;
    return isEnabled;
  }

  LimitInfo consume([int amount = 1]) {
    if (amount <= 0 || unlimited) return this;
    return copyWith(
      used: (used ?? 0) + amount,
      remaining: isCounter ? ((remaining ?? 0) - amount).clamp(0, 1 << 30) : 0,
    );
  }

  LimitInfo rollback([int amount = 1]) {
    if (amount <= 0 || unlimited) return this;
    final nextUsed = ((used ?? 0) - amount).clamp(0, 1 << 30);
    final nextRemaining = isCounter
        ? ((remaining ?? 0) + amount).clamp(0, 1 << 30)
        : ((remaining ?? 0) + amount).clamp(0, 1);
    return copyWith(
      used: nextUsed,
      remaining: nextRemaining,
    );
  }

  LimitInfo copyWith({
    String? key,
    String? name,
    int? displayOrder,
    String? valueType,
    int? used,
    int? limit,
    int? remaining,
    bool? isUnlimited,
    String? resetDate,
    String? resetPeriod,
    String? tierValue,
  }) {
    return LimitInfo(
      key: key ?? this.key,
      name: name ?? this.name,
      displayOrder: displayOrder ?? this.displayOrder,
      valueType: valueType ?? this.valueType,
      used: used ?? this.used,
      limit: limit ?? this.limit,
      remaining: remaining ?? this.remaining,
      isUnlimited: isUnlimited ?? this.isUnlimited,
      resetDate: resetDate ?? this.resetDate,
      resetPeriod: resetPeriod ?? this.resetPeriod,
      tierValue: tierValue ?? this.tierValue,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'name': name,
      'displayOrder': displayOrder,
      'valueType': valueType,
      'used': used,
      'limit': limit,
      'remaining': remaining,
      'isUnlimited': isUnlimited,
      'resetDate': resetDate,
      'resetPeriod': resetPeriod,
      'tierValue': tierValue,
    };
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
