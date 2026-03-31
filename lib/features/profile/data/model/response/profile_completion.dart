part of 'get_complete_profile_response.dart';

class ProfileCompletion {
  ProfileCompletion({
    this.percentage,
    this.missingFields,
    this.completedSections,
  });

  ProfileCompletion.fromJson(dynamic json) {
    percentage = json['percentage'];
    missingFields = json['missingFields'] != null
        ? List<String>.from(json['missingFields'])
        : [];
    completedSections = json['completedSections'] != null
        ? json['completedSections'].cast<String>()
        : [];
  }
  int? percentage;
  List<String>? missingFields;
  List<String>? completedSections;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['percentage'] = percentage;
    map['missingFields'] = missingFields;
    map['completedSections'] = completedSections;
    return map;
  }
}
