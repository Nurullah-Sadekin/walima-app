class UpdateFamilyResponse {
  final String? code;
  final String? message;
  final UpdateFamilyResponseBody? response;
  final String? traceId;

  UpdateFamilyResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  factory UpdateFamilyResponse.fromJson(Map<String, dynamic> json) {
    return UpdateFamilyResponse(
      code: json['code'] as String?,
      message: json['message'] as String?,
      response: json['response'] != null
          ? UpdateFamilyResponseBody.fromJson(
              json['response'] as Map<String, dynamic>)
          : null,
      traceId: json['traceId'] as String?,
    );
  }
}

class UpdateFamilyResponseBody {
  final bool? success;
  final UpdateFamilyData? data;

  UpdateFamilyResponseBody({
    this.success,
    this.data,
  });

  factory UpdateFamilyResponseBody.fromJson(Map<String, dynamic> json) {
    return UpdateFamilyResponseBody(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? UpdateFamilyData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UpdateFamilyData {
  final String id;
  final String profileId;
  final String? familyType;
  final String? familyValues;
  final String? familyEconomicCondition;
  final String? fatherName;
  final String? fatherProfession;
  final String? motherName;
  final String? motherProfession;
  final int? brothers;
  final int? sisters;
  final int? brothersMarried;
  final int? sistersMarried;
  final List<dynamic>? brothersDetails;
  final List<dynamic>? sistersDetails;
  final List<dynamic>? extendedFamilyMembers;
  final List<dynamic>? additionalFamilyMembers;
  final String? familyLocation;
  final String? familyIncome;
  final String? familyBackground;
  final String? ancestralOrigin;
  final String? aboutFamily;
  final String? marriageTimeline;
  final String? childrenPreference;
  final String? createdAt;
  final String? updatedAt;

  UpdateFamilyData({
    required this.id,
    required this.profileId,
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

  factory UpdateFamilyData.fromJson(Map<String, dynamic> json) {
    return UpdateFamilyData(
      id: json['id'] as String? ?? '',
      profileId: json['profileId'] as String? ?? '',
      familyType: json['familyType'] as String?,
      familyValues: json['familyValues'] as String?,
      familyEconomicCondition: json['familyEconomicCondition'] as String?,
      fatherName: json['fatherName'] as String?,
      fatherProfession: json['fatherProfession'] as String?,
      motherName: json['motherName'] as String?,
      motherProfession: json['motherProfession'] as String?,
      brothers: json['brothers'] as int?,
      sisters: json['sisters'] as int?,
      brothersMarried: json['brothersMarried'] as int?,
      sistersMarried: json['sistersMarried'] as int?,
      brothersDetails: json['brothersDetails'] as List<dynamic>?,
      sistersDetails: json['sistersDetails'] as List<dynamic>?,
      extendedFamilyMembers: json['extendedFamilyMembers'] as List<dynamic>?,
      additionalFamilyMembers:
          json['additionalFamilyMembers'] as List<dynamic>?,
      familyLocation: json['familyLocation'] as String?,
      familyIncome: json['familyIncome'] as String?,
      familyBackground: json['familyBackground'] as String?,
      ancestralOrigin: json['ancestralOrigin'] as String?,
      aboutFamily: json['aboutFamily'] as String?,
      marriageTimeline: json['marriageTimeline'] as String?,
      childrenPreference: json['childrenPreference'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
