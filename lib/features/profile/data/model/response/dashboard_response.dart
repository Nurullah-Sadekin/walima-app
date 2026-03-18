class DashboardResponse {
  DashboardResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  DashboardResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response =
        json['response'] != null ? DashboardData.fromJson(json['response']) : null;
    traceId = json['traceId'];
  }
  String? code;
  String? message;
  DashboardData? response;
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

class DashboardData {
  DashboardData({
    this.profile,
    this.activitySummary,
    this.premiumActivity,
    this.partnerPreferences,
  });

  DashboardData.fromJson(dynamic json) {
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    activitySummary = json['activitySummary'] != null
        ? ActivitySummary.fromJson(json['activitySummary'])
        : null;
    premiumActivity = json['premiumActivity'] != null
        ? PremiumActivity.fromJson(json['premiumActivity'])
        : null;
    partnerPreferences = json['partnerPreferences'] != null
        ? PartnerPreferences.fromJson(json['partnerPreferences'])
        : null;
  }
  Profile? profile;
  ActivitySummary? activitySummary;
  PremiumActivity? premiumActivity;
  PartnerPreferences? partnerPreferences;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (profile != null) {
      map['profile'] = profile?.toJson();
    }
    if (activitySummary != null) {
      map['activitySummary'] = activitySummary?.toJson();
    }
    if (premiumActivity != null) {
      map['premiumActivity'] = premiumActivity?.toJson();
    }
    if (partnerPreferences != null) {
      map['partnerPreferences'] = partnerPreferences?.toJson();
    }
    return map;
  }
}

class PartnerPreferences {
  PartnerPreferences({
    this.ageMin,
    this.ageMax,
    this.heightMin,
    this.heightMax,
    this.maritalStatus,
    this.postedBy,
    this.religion,
    this.community,
    this.country,
    this.city,
    this.motherTongue,
  });

  PartnerPreferences.fromJson(dynamic json) {
    ageMin = json['ageMin'];
    ageMax = json['ageMax'];
    heightMin = json['heightMin'];
    heightMax = json['heightMax'];
    maritalStatus = json['maritalStatus'] != null
        ? json['maritalStatus'].cast<String>()
        : [];
    postedBy = json['postedBy'] != null ? json['postedBy'].cast<String>() : [];
    religion = json['religion'] != null ? json['religion'].cast<String>() : [];
    community =
        json['community'] != null ? json['community'].cast<String>() : [];
    country = json['country'] != null ? json['country'].cast<String>() : [];
    city = json['city'] != null ? json['city'].cast<String>() : [];
    motherTongue =
        json['motherTongue'] != null ? json['motherTongue'].cast<String>() : [];
  }
  int? ageMin;
  int? ageMax;
  int? heightMin;
  int? heightMax;
  List<String>? maritalStatus;
  List<String>? postedBy;
  List<String>? religion;
  List<String>? community;
  List<String>? country;
  List<String>? city;
  List<String>? motherTongue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ageMin'] = ageMin;
    map['ageMax'] = ageMax;
    map['heightMin'] = heightMin;
    map['heightMax'] = heightMax;
    map['maritalStatus'] = maritalStatus;
    map['postedBy'] = postedBy;
    map['religion'] = religion;
    map['community'] = community;
    map['country'] = country;
    map['city'] = city;
    map['motherTongue'] = motherTongue;
    return map;
  }
}

class PremiumActivity {
  PremiumActivity({
    this.features,
  });

  PremiumActivity.fromJson(dynamic json) {
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features?.add(Features.fromJson(v));
      });
    }
  }
  List<Features>? features;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (features != null) {
      map['features'] = features?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Features {
  Features({
    this.featureKey,
    this.featureName,
    this.usedCount,
    this.limitCount,
    this.remaining,
    this.isLimitExceeded,
    this.isUnlimited,
    this.resetDate,
    this.lastUsedAt,
  });

  Features.fromJson(dynamic json) {
    featureKey = json['featureKey'];
    featureName = json['featureName'];
    usedCount = json['usedCount'];
    limitCount = json['limitCount'];
    remaining = json['remaining'];
    isLimitExceeded = json['isLimitExceeded'];
    isUnlimited = json['isUnlimited'];
    resetDate = json['resetDate'];
    lastUsedAt = json['lastUsedAt'];
  }
  String? featureKey;
  String? featureName;
  int? usedCount;
  int? limitCount;
  int? remaining;
  bool? isLimitExceeded;
  bool? isUnlimited;
  dynamic resetDate;
  dynamic lastUsedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['featureKey'] = featureKey;
    map['featureName'] = featureName;
    map['usedCount'] = usedCount;
    map['limitCount'] = limitCount;
    map['remaining'] = remaining;
    map['isLimitExceeded'] = isLimitExceeded;
    map['isUnlimited'] = isUnlimited;
    map['resetDate'] = resetDate;
    map['lastUsedAt'] = lastUsedAt;
    return map;
  }
}

class ActivitySummary {
  ActivitySummary({
    this.pendingInvitations,
    this.acceptedInvitations,
    this.recentVisitors,
  });

  ActivitySummary.fromJson(dynamic json) {
    pendingInvitations = json['pendingInvitations'];
    acceptedInvitations = json['acceptedInvitations'];
    recentVisitors = json['recentVisitors'];
  }
  int? pendingInvitations;
  int? acceptedInvitations;
  int? recentVisitors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pendingInvitations'] = pendingInvitations;
    map['acceptedInvitations'] = acceptedInvitations;
    map['recentVisitors'] = recentVisitors;
    return map;
  }
}

class Profile {
  Profile({
    this.id,
    this.profileManagedBy,
    this.displayName,
    this.nickName,
    this.name,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.maritalStatus,
    this.bio,
    this.motherTongue,
    this.languages,
    this.isVerified,
    this.userReference,
    this.username,
    this.profilePicture,
    this.membership,
    this.mobileVerified,
    this.accountStatus,
  });

  Profile.fromJson(dynamic json) {
    id = json['id'];
    profileManagedBy = json['profileManagedBy'];
    displayName = json['displayName'];
    nickName = json['nickName'];
    name = json['name'];
    dateOfBirth = json['dateOfBirth'];
    age = json['age'];
    gender = json['gender'];
    maritalStatus = json['maritalStatus'];
    bio = json['bio'];
    motherTongue = json['motherTongue'];
    if (json['languages'] != null) {
      languages = [];
      json['languages'].forEach((v) {
        // languages?.add(Dynamic.fromJson(v));
      });
    }
    isVerified = json['isVerified'];
    userReference = json['userReference'];
    username = json['username'];
    profilePicture = json['profilePicture'] != null
        ? ProfilePicture.fromJson(json['profilePicture'])
        : null;
    membership = json['membership'] != null
        ? Membership.fromJson(json['membership'])
        : null;
    mobileVerified = json['mobileVerified'];
    accountStatus = json['accountStatus'];
  }
  String? id;
  String? profileManagedBy;
  String? displayName;
  dynamic nickName;
  String? name;
  String? dateOfBirth;
  int? age;
  String? gender;
  String? maritalStatus;
  String? bio;
  String? motherTongue;
  List<dynamic>? languages;
  bool? isVerified;
  String? userReference;
  String? username;
  ProfilePicture? profilePicture;
  Membership? membership;
  bool? mobileVerified;
  String? accountStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileManagedBy'] = profileManagedBy;
    map['displayName'] = displayName;
    map['nickName'] = nickName;
    map['name'] = name;
    map['dateOfBirth'] = dateOfBirth;
    map['age'] = age;
    map['gender'] = gender;
    map['maritalStatus'] = maritalStatus;
    map['bio'] = bio;
    map['motherTongue'] = motherTongue;
    if (languages != null) {
      map['languages'] = languages?.map((v) => v.toJson()).toList();
    }
    map['isVerified'] = isVerified;
    map['userReference'] = userReference;
    map['username'] = username;
    if (profilePicture != null) {
      map['profilePicture'] = profilePicture?.toJson();
    }
    if (membership != null) {
      map['membership'] = membership?.toJson();
    }
    map['mobileVerified'] = mobileVerified;
    map['accountStatus'] = accountStatus;
    return map;
  }
}

class Membership {
  Membership({
    this.id,
    this.membershipTier,
    this.planId,
    this.plan,
    this.subscriptionId,
    this.autoRenew,
    this.membershipExpiresAt,
    this.nextPaymentDate,
    this.isPremium,
    this.isExpired,
    this.isUpgradeable,
    this.createdAt,
    this.updatedAt,
  });

  Membership.fromJson(dynamic json) {
    id = json['id'];
    membershipTier = json['membershipTier'];
    planId = json['planId'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    subscriptionId = json['subscriptionId'];
    autoRenew = json['autoRenew'];
    membershipExpiresAt = json['membershipExpiresAt'];
    nextPaymentDate = json['nextPaymentDate'];
    isPremium = json['isPremium'];
    isExpired = json['isExpired'];
    isUpgradeable = json['isUpgradeable'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? membershipTier;
  String? planId;
  Plan? plan;
  String? subscriptionId;
  bool? autoRenew;
  String? membershipExpiresAt;
  dynamic nextPaymentDate;
  bool? isPremium;
  bool? isExpired;
  bool? isUpgradeable;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['membershipTier'] = membershipTier;
    map['planId'] = planId;
    if (plan != null) {
      map['plan'] = plan?.toJson();
    }
    map['subscriptionId'] = subscriptionId;
    map['autoRenew'] = autoRenew;
    map['membershipExpiresAt'] = membershipExpiresAt;
    map['nextPaymentDate'] = nextPaymentDate;
    map['isPremium'] = isPremium;
    map['isExpired'] = isExpired;
    map['isUpgradeable'] = isUpgradeable;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Plan {
  Plan({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.status,
    this.tag,
    this.tagIcon,
  });

  Plan.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    status = json['status'];
    tag = json['tag'];
    tagIcon = json['tagIcon'];
  }
  String? id;
  String? name;
  String? slug;
  String? description;
  String? status;
  String? tag;
  String? tagIcon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['slug'] = slug;
    map['description'] = description;
    map['status'] = status;
    map['tag'] = tag;
    map['tagIcon'] = tagIcon;
    return map;
  }
}

class ProfilePicture {
  ProfilePicture({
    this.id,
    this.url,
    this.alt,
    this.caption,
    this.status,
  });

  ProfilePicture.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    alt = json['alt'];
    caption = json['caption'];
    status = json['status'];
  }
  String? id;
  String? url;
  String? alt;
  String? caption;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    map['alt'] = alt;
    map['caption'] = caption;
    map['status'] = status;
    return map;
  }
}
