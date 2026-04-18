import 'dart:convert';

ProfileStrengthResponse profileStrengthResponseFromJson(String str) =>
    ProfileStrengthResponse.fromJson(json.decode(str));

String profileStrengthResponseToJson(ProfileStrengthResponse data) =>
    json.encode(data.toJson());

class ProfileStrengthResponse {
  ProfileStrengthResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  ProfileStrengthResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? ProfileStrengthData.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  ProfileStrengthData? response;
  String? traceId;

  bool get isSuccess => code == 'SUCCESS' && response != null;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['traceId'] = traceId;
    return map;
  }
}

class ProfileStrengthData {
  ProfileStrengthData({
    this.overallScore,
    this.sections,
    this.tips,
  });

  ProfileStrengthData.fromJson(dynamic json) {
    overallScore = _toInt(json['overallScore']);
    sections = json['sections'] != null
        ? List<ProfileStrengthSection>.from(
            json['sections'].map(ProfileStrengthSection.fromJson),
          )
        : [];
    tips = json['tips'] != null ? List<String>.from(json['tips']) : [];
  }

  int? overallScore;
  List<ProfileStrengthSection>? sections;
  List<String>? tips;

  List<ProfileStrengthSection> get incompleteSections =>
      (sections ?? const <ProfileStrengthSection>[])
          .where((section) => section.completed != true)
          .toList(growable: false);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['overallScore'] = overallScore;
    map['sections'] = sections?.map((section) => section.toJson()).toList();
    map['tips'] = tips;
    return map;
  }
}

class ProfileStrengthSection {
  ProfileStrengthSection({
    this.key,
    this.label,
    this.weight,
    this.score,
    this.completionPercentage,
    this.completed,
    this.fields,
  });

  ProfileStrengthSection.fromJson(dynamic json) {
    key = json['key'];
    label = json['label'];
    weight = _toInt(json['weight']);
    score = _toInt(json['score']);
    completionPercentage = _toInt(json['completionPercentage']);
    completed = json['completed'];
    fields = json['fields'] != null
        ? List<ProfileStrengthField>.from(
            json['fields'].map(ProfileStrengthField.fromJson),
          )
        : [];
  }

  String? key;
  String? label;
  int? weight;
  int? score;
  int? completionPercentage;
  bool? completed;
  List<ProfileStrengthField>? fields;

  String? get firstIncompleteFieldKey {
    for (final field in fields ?? const <ProfileStrengthField>[]) {
      if (field.completed != true) {
        return field.key;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['label'] = label;
    map['weight'] = weight;
    map['score'] = score;
    map['completionPercentage'] = completionPercentage;
    map['completed'] = completed;
    map['fields'] = fields?.map((field) => field.toJson()).toList();
    return map;
  }
}

class ProfileStrengthField {
  ProfileStrengthField({
    this.key,
    this.label,
    this.completed,
  });

  ProfileStrengthField.fromJson(dynamic json) {
    key = json['key'];
    label = json['label'];
    completed = json['completed'];
  }

  String? key;
  String? label;
  bool? completed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['label'] = label;
    map['completed'] = completed;
    return map;
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value.toString());
}
