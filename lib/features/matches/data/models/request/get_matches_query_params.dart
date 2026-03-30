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
    addValue('heightMin', heightMin);
    addValue('heightMax', heightMax);
    addValue('maritalStatus', maritalStatus);
    addValue('religion', religion);
    addValue('motherTongue', motherTongue);
    addValue('countryLivingIn', csv(countryLivingIn));
    addValue('community', csv(community));
    addValue('haveChildren', haveChildren);
    addValue('liveWithFamily', liveWithFamily);
    addValue('photoVisibility', photoVisibility);
    addValue('doNotShow', csv(doNotShow));
    addValue('stateLivingIn', csv(stateLivingIn));
    addValue('countryGrewUpIn', countryGrewUpIn);
    addValue('residencyStatus', residencyStatus);
    addValue('qualification', csv(qualification));
    addValue('educationArea', csv(educationArea));
    addValue('workingWith', workingWith);
    addValue('professionArea', professionArea);
    addValue('annualIncome', annualIncome);
    addValue('eatingHabits', eatingHabits);
    addValue('matchFilterType', matchFilterType);
    addValue('recentlyJoined', recentlyJoined);
    addValue('activeMembers', activeMembers);
    addValue('saveSearch', saveSearch);
    addValue('searchTitle', searchTitle);
    extraParams?.forEach(addValue);

    return map;
  }
}
