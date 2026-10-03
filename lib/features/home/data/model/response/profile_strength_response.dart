import 'dart:convert';

ProfileStrengthResponse profileStrengthResponseFromJson(String str) =>
    ProfileStrengthResponse.fromJson(json.decode(str));

String profileStrengthResponseToJson(ProfileStrengthResponse data) =>
    json.encode(data.toJson());

class ProfileStrengthResponse {
  const ProfileStrengthResponse({
    required this.code,
    required this.message,
    this.response,
    this.traceId,
  });

  factory ProfileStrengthResponse.fromJson(dynamic json) {
    final map = _asStringMap(json, 'profile strength envelope');
    final code = map['code']?.toString() ?? '';
    final message = map['message']?.toString() ?? '';
    final traceId = map['traceId']?.toString();

    if (code != 'SUCCESS') {
      return ProfileStrengthResponse(
        code: code,
        message: message,
        traceId: traceId,
      );
    }

    final payload = map['response'];
    if (payload == null) {
      throw const FormatException('Profile strength response is missing.');
    }

    return ProfileStrengthResponse(
      code: code,
      message: message,
      response: ProfileStrengthData.fromJson(payload),
      traceId: traceId,
    );
  }

  final String code;
  final String message;
  final ProfileStrengthData? response;
  final String? traceId;

  bool get isSuccess => code == 'SUCCESS' && response != null;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'message': message,
        if (response != null) 'response': response!.toJson(),
        if (traceId != null) 'traceId': traceId,
      };
}

class ProfileStrengthData {
  const ProfileStrengthData({
    required this.overallScore,
    required this.sections,
    required this.tips,
  });

  factory ProfileStrengthData.fromJson(dynamic json) {
    final map = _asStringMap(json, 'profile strength response');
    final rawSections = map['sections'];
    final rawTips = map['tips'];

    if (rawSections is! List) {
      throw const FormatException('Profile strength sections are missing.');
    }
    if (rawTips is! List) {
      throw const FormatException('Profile strength tips are missing.');
    }

    return ProfileStrengthData(
      overallScore: _requiredInt(map['overallScore'], 'overallScore'),
      sections: rawSections
          .map(ProfileStrengthSection.fromJson)
          .toList(growable: false),
      tips: rawTips.map((tip) {
        if (tip is! String) {
          throw const FormatException('A profile strength tip is invalid.');
        }
        return tip;
      }).toList(growable: false),
    );
  }

  final int overallScore;
  final List<ProfileStrengthSection> sections;
  final List<String> tips;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'overallScore': overallScore,
        'sections': sections.map((section) => section.toJson()).toList(),
        'tips': tips,
      };
}

class ProfileStrengthSection {
  const ProfileStrengthSection({
    required this.key,
    required this.label,
    required this.weight,
    required this.score,
    required this.completionPercentage,
    required this.completed,
    required this.fields,
  });

  factory ProfileStrengthSection.fromJson(dynamic json) {
    final map = _asStringMap(json, 'profile strength section');
    final rawFields = map['fields'];
    if (rawFields is! List) {
      throw const FormatException(
        'Profile strength section fields are missing.',
      );
    }

    return ProfileStrengthSection(
      key: _requiredString(map['key'], 'section.key'),
      label: _requiredString(map['label'], 'section.label'),
      weight: _requiredDouble(map['weight'], 'section.weight'),
      score: _requiredDouble(map['score'], 'section.score'),
      completionPercentage: _requiredInt(
        map['completionPercentage'],
        'section.completionPercentage',
      ),
      completed: _requiredBool(map['completed'], 'section.completed'),
      fields:
          rawFields.map(ProfileStrengthField.fromJson).toList(growable: false),
    );
  }

  final String key;
  final String label;
  final double weight;
  final double score;
  final int completionPercentage;
  final bool completed;
  final List<ProfileStrengthField> fields;

  ProfileStrengthField? get firstIncompleteField {
    for (final field in fields) {
      if (!field.completed) return field;
    }
    return null;
  }

  String? get firstIncompleteFieldKey => firstIncompleteField?.key;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'key': key,
        'label': label,
        'weight': weight,
        'score': score,
        'completionPercentage': completionPercentage,
        'completed': completed,
        'fields': fields.map((field) => field.toJson()).toList(),
      };
}

class ProfileStrengthField {
  const ProfileStrengthField({
    required this.key,
    required this.label,
    required this.completed,
  });

  factory ProfileStrengthField.fromJson(dynamic json) {
    final map = _asStringMap(json, 'profile strength field');
    return ProfileStrengthField(
      key: _requiredString(map['key'], 'field.key'),
      label: _requiredString(map['label'], 'field.label'),
      completed: _requiredBool(map['completed'], 'field.completed'),
    );
  }

  final String key;
  final String label;
  final bool completed;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'key': key,
        'label': label,
        'completed': completed,
      };
}

Map<String, dynamic> _asStringMap(dynamic value, String name) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw FormatException('Invalid $name.');
}

String _requiredString(dynamic value, String name) {
  if (value is String && value.trim().isNotEmpty) return value;
  throw FormatException('Invalid $name.');
}

int _requiredInt(dynamic value, String name) {
  if (value is num) return value.round();
  throw FormatException('Invalid $name.');
}

double _requiredDouble(dynamic value, String name) {
  if (value is num) return value.toDouble();
  throw FormatException('Invalid $name.');
}

bool _requiredBool(dynamic value, String name) {
  if (value is bool) return value;
  throw FormatException('Invalid $name.');
}
