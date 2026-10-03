class HomepageTopMatchesResponse {
  HomepageTopMatchesResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  HomepageTopMatchesResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? HomepageTopMatchesData.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  HomepageTopMatchesData? response;
  String? traceId;

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

class HomepageTopMatchesData {
  HomepageTopMatchesData({
    this.data,
  });

  HomepageTopMatchesData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(HomepageTopMatch.fromJson(v));
      });
    }
  }

  List<HomepageTopMatch>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class HomepageTopMatch {
  HomepageTopMatch({
    this.id,
    this.userReference,
    this.displayName,
    this.profilePhoto,
    this.age,
    this.gender,
    this.profession,
    this.education,
    this.location,
    this.compatibility,
  });

  HomepageTopMatch.fromJson(dynamic json) {
    id = json['id'];
    userReference = json['userReference'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'] != null
        ? HomepageTopMatchPhoto.fromJson(json['profilePhoto'])
        : null;
    age = json['age'];
    gender = json['gender'];
    profession = json['profession'];
    education = json['education'];
    location = json['location'] != null
        ? HomepageTopMatchLocation.fromJson(json['location'])
        : null;
    compatibility = json['compatibility'] != null
        ? HomepageTopMatchCompatibility.fromJson(json['compatibility'])
        : null;
  }

  String? id;
  String? userReference;
  String? displayName;
  HomepageTopMatchPhoto? profilePhoto;
  int? age;
  String? gender;
  String? profession;
  String? education;
  HomepageTopMatchLocation? location;
  HomepageTopMatchCompatibility? compatibility;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userReference'] = userReference;
    map['displayName'] = displayName;
    if (profilePhoto != null) {
      map['profilePhoto'] = profilePhoto?.toJson();
    }
    map['age'] = age;
    map['gender'] = gender;
    map['profession'] = profession;
    map['education'] = education;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    if (compatibility != null) {
      map['compatibility'] = compatibility?.toJson();
    }
    return map;
  }
}

class HomepageTopMatchPhoto {
  HomepageTopMatchPhoto({
    this.url,
    this.visibilityStatus,
    this.isVerified,
  });

  HomepageTopMatchPhoto.fromJson(dynamic json) {
    url = json['url'];
    visibilityStatus = json['visibilityStatus'];
    isVerified = json['isVerified'];
  }

  String? url;
  String? visibilityStatus;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['visibilityStatus'] = visibilityStatus;
    map['isVerified'] = isVerified;
    return map;
  }
}

class HomepageTopMatchLocation {
  HomepageTopMatchLocation({
    this.locationType,
    this.city,
    this.state,
    this.country,
  });

  HomepageTopMatchLocation.fromJson(dynamic json) {
    locationType = json['locationType'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  String? locationType;
  String? city;
  String? state;
  String? country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['locationType'] = locationType;
    map['city'] = city;
    map['state'] = state;
    map['country'] = country;
    return map;
  }
}

class HomepageTopMatchCompatibility {
  HomepageTopMatchCompatibility({
    this.matchPercentage,
    this.label,
  });

  HomepageTopMatchCompatibility.fromJson(dynamic json) {
    final rawMatchPercentage = json['matchPercentage'];
    matchPercentage = rawMatchPercentage?.toString();
    label = json['label'];
  }

  String? matchPercentage;
  String? label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['matchPercentage'] = matchPercentage;
    map['label'] = label;
    return map;
  }
}
