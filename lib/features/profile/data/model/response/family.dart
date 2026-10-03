part of 'get_complete_profile_response.dart';

class Family {
  Family({
    this.id,
    this.profileId,
    this.familyType,
    this.familyValues,
    this.familyEconomicCondition,
    this.fatherName,
    this.fatherProfession,
    this.motherName,
    this.motherProfession,
    this.brothers,
    this.sisters,
    this.brothersMarried,
    this.sistersMarried,
    this.brothersDetails,
    this.sistersDetails,
    this.extendedFamilyMembers,
    this.additionalFamilyMembers,
    this.familyLocation,
    this.familyIncome,
    this.familyBackground,
    this.ancestralOrigin,
    this.aboutFamily,
    this.marriageTimeline,
    this.childrenPreference,
    this.createdAt,
    this.updatedAt,
  });

  Family.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    familyType = json['familyType'];
    familyValues = json['familyValues'];
    familyEconomicCondition = json['familyEconomicCondition'];
    fatherName = json['fatherName'];
    fatherProfession = json['fatherProfession'];
    motherName = json['motherName'];
    motherProfession = json['motherProfession'];
    brothers = json['brothers'];
    sisters = json['sisters'];
    brothersMarried = json['brothersMarried'];
    sistersMarried = json['sistersMarried'];
    if (json['brothersDetails'] != null) {
      brothersDetails = [];
      // json['brothersDetails'].forEach((v) {
      //   brothersDetails?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['sistersDetails'] != null) {
      sistersDetails = [];
      // json['sistersDetails'].forEach((v) {
      //   sistersDetails?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['extendedFamilyMembers'] != null) {
      extendedFamilyMembers = [];
      // json['extendedFamilyMembers'].forEach((v) {
      //   extendedFamilyMembers?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['additionalFamilyMembers'] != null) {
      additionalFamilyMembers = [];
      // json['additionalFamilyMembers'].forEach((v) {
      //   additionalFamilyMembers?.add(Dynamic.fromJson(v));
      // });
    }
    familyLocation = json['familyLocation'];
    familyIncome = json['familyIncome'];
    familyBackground = json['familyBackground'];
    ancestralOrigin = json['ancestralOrigin'];
    aboutFamily = json['aboutFamily'];
    marriageTimeline = json['marriageTimeline'];
    childrenPreference = json['childrenPreference'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? familyType;
  String? familyValues;
  String? familyEconomicCondition;
  String? fatherName;
  String? fatherProfession;
  String? motherName;
  String? motherProfession;
  int? brothers;
  int? sisters;
  int? brothersMarried;
  int? sistersMarried;
  List<List<dynamic>>? brothersDetails;
  List<List<dynamic>>? sistersDetails;
  List<List<dynamic>>? extendedFamilyMembers;
  List<List<dynamic>>? additionalFamilyMembers;
  String? familyLocation;
  String? familyIncome;
  String? familyBackground;
  String? ancestralOrigin;
  String? aboutFamily;
  dynamic marriageTimeline;
  dynamic childrenPreference;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['familyType'] = familyType;
    map['familyValues'] = familyValues;
    map['familyEconomicCondition'] = familyEconomicCondition;
    map['fatherName'] = fatherName;
    map['fatherProfession'] = fatherProfession;
    map['motherName'] = motherName;
    map['motherProfession'] = motherProfession;
    map['brothers'] = brothers;
    map['sisters'] = sisters;
    map['brothersMarried'] = brothersMarried;
    map['sistersMarried'] = sistersMarried;
    if (brothersDetails != null) {
      // map['brothersDetails'] = brothersDetails?.map((v) => v.toJson()).toList();
    }
    if (sistersDetails != null) {
      // map['sistersDetails'] = sistersDetails?.map((v) => v.toJson()).toList();
    }
    if (extendedFamilyMembers != null) {
      // map['extendedFamilyMembers'] = extendedFamilyMembers?.map((v) => v.toJson()).toList();
    }
    if (additionalFamilyMembers != null) {
      // map['additionalFamilyMembers'] = additionalFamilyMembers?.map((v) => v.toJson()).toList();
    }
    map['familyLocation'] = familyLocation;
    map['familyIncome'] = familyIncome;
    map['familyBackground'] = familyBackground;
    map['ancestralOrigin'] = ancestralOrigin;
    map['aboutFamily'] = aboutFamily;
    map['marriageTimeline'] = marriageTimeline;
    map['childrenPreference'] = childrenPreference;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

