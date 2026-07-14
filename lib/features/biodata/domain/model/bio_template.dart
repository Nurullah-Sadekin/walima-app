class BioTemplate {
  const BioTemplate({
    required this.id,
    required this.title,
    required this.content,
    this.tags = const <String>[],
    this.priority = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory BioTemplate.fromJson(Map<String, dynamic> json) {
    return BioTemplate(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      tags: _stringList(json['tags']),
      priority: _intValue(json['priority']),
      isActive: _boolValue(json['isActive'], fallback: true),
      createdAt: _dateValue(json['createdAt']),
      updatedAt: _dateValue(json['updatedAt']),
    );
  }

  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final int priority;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class ConnectMessageTemplate {
  const ConnectMessageTemplate({
    required this.id,
    required this.title,
    required this.content,
    this.priority = 0,
    this.isDefault = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ConnectMessageTemplate.fromJson(Map<String, dynamic> json) {
    return ConnectMessageTemplate(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      priority: _intValue(json['priority']),
      isDefault: _boolValue(json['isDefault']),
      isActive: _boolValue(json['isActive'], fallback: true),
      createdAt: _dateValue(json['createdAt']),
      updatedAt: _dateValue(json['updatedAt']),
    );
  }

  final String id;
  final String title;
  final String content;
  final int priority;
  final bool isDefault;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

List<String> _stringList(Object? value) {
  if (value is! List) return const <String>[];
  return value
      .map((item) => item.toString().trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}

int _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse((value ?? '').toString()) ?? 0;
}

bool _boolValue(Object? value, {bool fallback = false}) {
  if (value is bool) return value;
  final normalized = (value ?? '').toString().trim().toLowerCase();
  if (normalized == 'true') return true;
  if (normalized == 'false') return false;
  return fallback;
}

DateTime? _dateValue(Object? value) {
  final normalized = (value ?? '').toString().trim();
  if (normalized.isEmpty) return null;
  return DateTime.tryParse(normalized);
}
