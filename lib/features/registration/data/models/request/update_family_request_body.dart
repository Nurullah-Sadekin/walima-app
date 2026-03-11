class UpdateFamilyRequestBody {
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
  final List<FamilyMemberDetail>? brothersDetails;
  final List<FamilyMemberDetail>? sistersDetails;
  final List<ExtendedFamilyMember>? extendedFamilyMembers;
  final List<AdditionalFamilyMember>? additionalFamilyMembers;
  final String? familyLocation;
  final String? familyIncome;
  final String? familyBackground;
  final String? ancestralOrigin;
  final String? aboutFamily;
  final String? marriageTimeline;
  final String? childrenPreference;

  UpdateFamilyRequestBody({
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
  });

  Map<String, dynamic> toJson() {
    return {
      'familyType': familyType,
      'familyValues': familyValues,
      'familyEconomicCondition': familyEconomicCondition,
      'fatherName': fatherName,
      'fatherProfession': fatherProfession,
      'motherName': motherName,
      'motherProfession': motherProfession,
      'brothers': brothers,
      'sisters': sisters,
      // 'brothersMarried': brothersMarried,
      // 'sistersMarried': sistersMarried,
      'brothersDetails': brothersDetails?.map((e) => e.toJson()).toList(),
      'sistersDetails': sistersDetails?.map((e) => e.toJson()).toList(),
      'extendedFamilyMembers':
          extendedFamilyMembers?.map((e) => e.toJson()).toList(),
      'additionalFamilyMembers':
          additionalFamilyMembers?.map((e) => e.toJson()).toList(),
      'familyLocation': familyLocation,
      'familyIncome': familyIncome,
      'familyBackground': familyBackground,
      'ancestralOrigin': ancestralOrigin,
      'aboutFamily': aboutFamily,
      'marriageTimeline': marriageTimeline,
      'childrenPreference': childrenPreference,
    };
  }
}

class FamilyMemberDetail {
  final String? name;
  final String? maritalStatus;
  final String? profession;

  FamilyMemberDetail({
    this.name,
    this.maritalStatus,
    this.profession,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'maritalStatus': maritalStatus,
      'profession': profession,
    };
  }
}

class ExtendedFamilyMember {
  final String? name;
  final String? relation;
  final String? profession;

  ExtendedFamilyMember({
    this.name,
    this.relation,
    this.profession,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relation': relation,
      'profession': profession,
    };
  }
}

class AdditionalFamilyMember {
  final String? name;
  final String? relation;
  final String? maritalStatus;
  final String? profession;

  AdditionalFamilyMember({
    this.name,
    this.relation,
    this.maritalStatus,
    this.profession,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relation': relation,
      'maritalStatus': maritalStatus,
      'profession': profession,
    };
  }
}
