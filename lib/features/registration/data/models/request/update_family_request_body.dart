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
    final data = <String, dynamic>{};

    void addValue(String key, dynamic value) {
      if (value == null) {
        return;
      }
      if (value is String && value.trim().isEmpty) {
        return;
      }
      if (value is List && value.isEmpty) {
        return;
      }
      data[key] = value;
    }

    addValue('familyType', familyType?.trim());
    addValue('familyValues', familyValues?.trim());
    addValue('familyEconomicCondition', familyEconomicCondition?.trim());
    addValue('fatherName', fatherName?.trim());
    addValue('fatherProfession', fatherProfession?.trim());
    addValue('motherName', motherName?.trim());
    addValue('motherProfession', motherProfession?.trim());
    addValue('brothers', brothers);
    addValue('sisters', sisters);
    addValue('brothersMarried', brothersMarried);
    addValue('sistersMarried', sistersMarried);
    addValue(
      'brothersDetails',
      brothersDetails
          ?.map((e) => e.toJson())
          .where((entry) => entry.isNotEmpty)
          .toList(growable: false),
    );
    addValue(
      'sistersDetails',
      sistersDetails
          ?.map((e) => e.toJson())
          .where((entry) => entry.isNotEmpty)
          .toList(growable: false),
    );
    addValue(
      'extendedFamilyMembers',
      extendedFamilyMembers
          ?.map((e) => e.toJson())
          .where((entry) => entry.isNotEmpty)
          .toList(growable: false),
    );
    addValue(
      'additionalFamilyMembers',
      additionalFamilyMembers
          ?.map((e) => e.toJson())
          .where((entry) => entry.isNotEmpty)
          .toList(growable: false),
    );
    addValue('familyLocation', familyLocation?.trim());
    addValue('familyIncome', familyIncome?.trim());
    addValue('familyBackground', familyBackground?.trim());
    addValue('ancestralOrigin', ancestralOrigin?.trim());
    addValue('aboutFamily', aboutFamily?.trim());
    addValue('marriageTimeline', marriageTimeline?.trim());
    addValue('childrenPreference', childrenPreference?.trim());

    return data;
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
    final data = <String, dynamic>{};
    if (name != null && name!.trim().isNotEmpty) {
      data['name'] = name!.trim();
    }
    if (maritalStatus != null && maritalStatus!.trim().isNotEmpty) {
      data['maritalStatus'] = maritalStatus!.trim();
    }
    if (profession != null && profession!.trim().isNotEmpty) {
      data['profession'] = profession!.trim();
    }
    return data;
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
    final data = <String, dynamic>{};
    if (name != null && name!.trim().isNotEmpty) {
      data['name'] = name!.trim();
    }
    if (relation != null && relation!.trim().isNotEmpty) {
      data['relation'] = relation!.trim();
    }
    if (profession != null && profession!.trim().isNotEmpty) {
      data['profession'] = profession!.trim();
    }
    return data;
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
    final data = <String, dynamic>{};
    if (name != null && name!.trim().isNotEmpty) {
      data['name'] = name!.trim();
    }
    if (relation != null && relation!.trim().isNotEmpty) {
      data['relation'] = relation!.trim();
    }
    if (maritalStatus != null && maritalStatus!.trim().isNotEmpty) {
      data['maritalStatus'] = maritalStatus!.trim();
    }
    if (profession != null && profession!.trim().isNotEmpty) {
      data['profession'] = profession!.trim();
    }
    return data;
  }
}
