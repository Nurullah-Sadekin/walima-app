import 'package:walima_llc/core/global/enums/enums.dart';

class GetMatchesQueryParams {
  GetMatchesQueryParams({
    this.type,
    this.responseFormat,
    this.page,
    this.size,
    this.maxDistance,
    this.sortBy,
    this.debugNearMe,
    this.ageMin,
    this.ageMax,
    this.heightMin,
    this.heightMax,
    this.maritalStatus,
    this.religion,
    this.motherTongue,
    this.countryLivingIn,
    this.community,
    this.haveChildren,
    this.liveWithFamily,
    this.photoVisibility,
    this.doNotShow,
    this.stateLivingIn,
    this.countryGrewUpIn,
    this.residencyStatus,
    this.qualification,
    this.educationArea,
    this.workingWith,
    this.professionArea,
    this.annualIncome,
    this.eatingHabits,
    this.matchFilterType,
    this.recentlyJoined,
    this.activeMembers,
    this.saveSearch,
    this.searchTitle,
    this.extraParams,
  });

  final String? type;
  final String? responseFormat;
  final int? page;
  final int? size;
  final int? maxDistance;
  final String? sortBy;
  final bool? debugNearMe;
  final int? ageMin;
  final int? ageMax;
  final int? heightMin;
  final int? heightMax;
  final String? maritalStatus;
  final String? religion;
  final String? motherTongue;
  final List<String>? countryLivingIn;
  final List<String>? community;
  final String? haveChildren;
  final bool? liveWithFamily;
  final String? photoVisibility;
  final List<String>? doNotShow;
  final List<String>? stateLivingIn;
  final String? countryGrewUpIn;
  final String? residencyStatus;
  final List<String>? qualification;
  final List<String>? educationArea;
  final String? workingWith;
  final String? professionArea;
  final String? annualIncome;
  final String? eatingHabits;
  final String? matchFilterType;
  final String? recentlyJoined;
  final String? activeMembers;
  final bool? saveSearch;
  final String? searchTitle;
  final Map<String, dynamic>? extraParams;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    String? normalizeScalar(String? value) {
      final trimmed = value?.trim();
      if (trimmed == null || trimmed.isEmpty) return null;
      if (RegExp(r'^\d+$').hasMatch(trimmed)) return null;
      return trimmed;
    }

    List<String>? normalizeList(List<String>? values) {
      if (values == null) return null;
      final items = values
          .map((value) => normalizeScalar(value))
          .whereType<String>()
          .toList(growable: false);
      return items.isEmpty ? null : items;
    }

    String? normalizeEnumValue<T extends ApiUiEnum>(
      String? raw,
      Iterable<T> values, {
      Map<String, T>? aliases,
    }) {
      final fromApi = EnumMapper.fromApiValue(raw, values, aliases: aliases);
      if (fromApi != null) return fromApi.apiValue;

      final fromUi = EnumMapper.fromUiValue(raw, values, aliases: aliases);
      if (fromUi != null) return fromUi.apiValue;

      return null;
    }

    List<String>? normalizeEnumList<T extends ApiUiEnum>(
      List<String>? values,
      Iterable<T> enumValues, {
      Map<String, T>? aliases,
    }) {
      if (values == null) return null;
      final items = values
          .map(
            (value) => normalizeEnumValue(
              value,
              enumValues,
              aliases: aliases,
            ),
          )
          .whereType<String>()
          .toList(growable: false);
      return items.isEmpty ? null : items;
    }

    void addValue(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      if (value is List && value.isEmpty) return;
      map[key] = value;
    }

    String? csv(List<String>? values) {
      if (values == null) return null;
      final items = values
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toList();
      if (items.isEmpty) return null;
      return items.join(',');
    }

    addValue('type', type);
    addValue('responseFormat', responseFormat);
    addValue('page', page);
    addValue('size', size);
    addValue('maxDistance', maxDistance);
    addValue('sortBy', sortBy);
    addValue('debugNearMe', debugNearMe);
    addValue('ageMin', ageMin);
    addValue('ageMax', ageMax);
    final normalizedHeightMin =
        heightMin != null && heightMin! >= 100 ? heightMin : null;
    final normalizedHeightMax =
        heightMax != null && heightMax! >= 100 ? heightMax : null;
    final normalizedMaritalStatus = normalizeEnumValue(
      maritalStatus,
      RegistrationMaritalStatus.values,
    );
    final normalizedReligion = normalizeScalar(religion);
    final normalizedMotherTongue = normalizeScalar(motherTongue);
    final normalizedCountryLivingIn = normalizeList(countryLivingIn);
    final normalizedCommunity = normalizeList(community);
    final normalizedHaveChildren = normalizeEnumValue(
      haveChildren,
      HaveChildrenOption.values,
      aliases: {
        'okay,_if_we\'re_not_staying_together':
            HaveChildrenOption.okayIfNotStayingTogether,
        'okay_if_we_re_not_staying_together':
            HaveChildrenOption.okayIfNotStayingTogether,
      },
    );
    final normalizedPhotoVisibility = normalizeEnumValue(
      photoVisibility,
      PhotoVisibilityFilter.values,
      aliases: {
        'open_to_all': PhotoVisibilityFilter.visibleToAll,
        'visible_to_everyone': PhotoVisibilityFilter.visibleToAll,
        'custom': PhotoVisibilityFilter.privatePhoto,
      },
    );
    final normalizedStateLivingIn = normalizeList(stateLivingIn);
    final normalizedCountryGrewUpIn = normalizeScalar(countryGrewUpIn);
    final normalizedResidencyStatus = normalizeEnumValue(
      residencyStatus,
      ResidencyStatus.values,
    );
    final normalizedQualification = normalizeEnumList(
      qualification,
      EducationLevel.values,
      aliases: {
        'high_school': EducationLevel.secondary,
        'master': EducationLevel.masters,
      },
    );
    final normalizedEducationArea = normalizeList(educationArea);
    final normalizedWorkingWith = normalizeScalar(workingWith);
    final normalizedProfessionArea = normalizeScalar(professionArea);
    final normalizedAnnualIncome = normalizeScalar(annualIncome);
    final normalizedEatingHabits = normalizeEnumValue(
      eatingHabits,
      RegistrationDiet.values,
      aliases: {
        'veg': RegistrationDiet.vegetarian,
        'non_veg': RegistrationDiet.nonVegetarian,
        'jain': RegistrationDiet.jainVegetarian,
      },
    );
    final normalizedSearchTitle = normalizeScalar(searchTitle);

    addValue('heightMin', normalizedHeightMin);
    addValue('heightMax', normalizedHeightMax);
    addValue('maritalStatus', normalizedMaritalStatus);
    // `open_to_all` is a preference wildcard, rather than a value stored on
    // profiles. Sending it to the matches endpoint turns it into a literal
    // equality filter and therefore produces no results.
    addValue(
      'religion',
      normalizedReligion == Religion.openToAll.apiValue
          ? null
          : normalizedReligion,
    );
    addValue('motherTongue', normalizedMotherTongue);
    addValue('countryLivingIn', csv(normalizedCountryLivingIn));
    addValue('community', csv(normalizedCommunity));
    addValue('haveChildren', normalizedHaveChildren);
    addValue('liveWithFamily', liveWithFamily);
    addValue('photoVisibility', normalizedPhotoVisibility);
    addValue('doNotShow', csv(doNotShow));
    addValue('stateLivingIn', csv(normalizedStateLivingIn));
    addValue('countryGrewUpIn', normalizedCountryGrewUpIn);
    addValue('residencyStatus', normalizedResidencyStatus);
    addValue('qualification', csv(normalizedQualification));
    addValue('educationArea', csv(normalizedEducationArea));
    addValue('workingWith', normalizedWorkingWith);
    addValue('professionArea', normalizedProfessionArea);
    addValue('annualIncome', normalizedAnnualIncome);
    addValue('eatingHabits', normalizedEatingHabits);
    addValue('matchFilterType', matchFilterType);
    addValue('recentlyJoined', recentlyJoined);
    addValue('activeMembers', activeMembers);
    addValue('saveSearch', saveSearch);
    addValue('searchTitle', normalizedSearchTitle);
    extraParams?.forEach(addValue);

    return map;
  }
}
