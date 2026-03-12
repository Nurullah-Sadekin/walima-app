part of 'get_complete_profile_response.dart';

class ProfileCompletion {
  ProfileCompletion({
    this.percentage,
    this.missingFields,
    this.completedSections,
  });

  ProfileCompletion.fromJson(dynamic json) {
    percentage = json['percentage'];
    if (json['missingFields'] != null) {
      missingFields = [];
      // json['missingFields'].forEach((v) {
      //   missingFields?.add(Dynamic.fromJson(v));
      // });
    }
    completedSections = json['completedSections'] != null
        ? json['completedSections'].cast<String>()
        : [];
  }
  int? percentage;
  List<dynamic>? missingFields;
  List<String>? completedSections;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['percentage'] = percentage;
    if (missingFields != null) {
      map['missingFields'] = missingFields?.map((v) => v.toJson()).toList();
    }
    map['completedSections'] = completedSections;
    return map;
  }
}

