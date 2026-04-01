class GetMatchesResponse {
  GetMatchesResponse({
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.savedSearch,
    this.traceId,
    this.statusCode,
  });

  GetMatchesResponse.fromJson(dynamic json, {this.statusCode}) {
    final raw = _ensureMap(json);
    code = raw['code'];
    message = raw['message'];
    traceId = raw['traceId'];

    final payload = _extractPayload(raw);

    if (payload['data'] != null) {
      data = [];
      payload['data'].forEach((v) {
        data?.add(MatchProfile.fromJson(v));
      });
    }
    pagination = payload['pagination'] != null
        ? MatchesPagination.fromJson(payload['pagination'])
        : null;
    savedSearch = payload['savedSearch'] != null
        ? SavedSearch.fromJson(payload['savedSearch'])
        : null;
  }

  String? code;
  String? message;
  List<MatchProfile>? data;
  MatchesPagination? pagination;
  SavedSearch? savedSearch;
  String? traceId;
  int? statusCode;
}

class MatchProfile {
  MatchProfile({
    this.id,
    this.userReference,
    this.displayName,
    this.profilePhoto,
    this.age,
    this.height,
    this.gender,
    this.location,
    this.religion,
    this.community,
    this.motherTongue,
    this.maritalStatus,
    this.profession,
    this.education,
    this.isOnline,
    this.lastSeenAt,
    this.isPremium,
    this.compatibility,
    this.connection,
  });

  MatchProfile.fromJson(dynamic json) {
    id = json['id'];
    userReference = json['userReference'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'] != null
        ? MatchProfilePhoto.fromJson(json['profilePhoto'])
        : null;
    age = json['age'];
    height = _parseNum(json['height']);
    gender = json['gender'];
    location = json['location'] != null
        ? MatchProfileLocation.fromJson(json['location'])
        : null;
    religion = json['religion'];
    community = json['community'];
    motherTongue = json['motherTongue'];
    maritalStatus = json['maritalStatus'];
    profession = json['profession'];
    education = json['education'];
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
    isPremium = json['isPremium'];
    compatibility = json['compatibility'] != null
        ? MatchCompatibility.fromJson(json['compatibility'])
        : null;
    connection = json['connection'] != null
        ? MatchConnection.fromJson(json['connection'])
        : null;
  }

  String? id;
  String? userReference;
  String? displayName;
  MatchProfilePhoto? profilePhoto;
  int? age;
  num? height;
  String? gender;
  MatchProfileLocation? location;
  String? religion;
  String? community;
  String? motherTongue;
  String? maritalStatus;
  String? profession;
  String? education;
  bool? isOnline;
  String? lastSeenAt;
  bool? isPremium;
  MatchCompatibility? compatibility;
  MatchConnection? connection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userReference'] = userReference;
    map['displayName'] = displayName;
    if (profilePhoto != null) {
      map['profilePhoto'] = profilePhoto?.toJson();
    }
    map['age'] = age;
    map['height'] = height;
    map['gender'] = gender;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['religion'] = religion;
    map['community'] = community;
    map['motherTongue'] = motherTongue;
    map['maritalStatus'] = maritalStatus;
    map['profession'] = profession;
    map['education'] = education;
    map['isOnline'] = isOnline;
    map['lastSeenAt'] = lastSeenAt;
    map['isPremium'] = isPremium;
    if (compatibility != null) {
      map['compatibility'] = compatibility?.toJson();
    }
    if (connection != null) {
      map['connection'] = connection?.toJson();
    }
    return map;
  }
}

class MatchProfilePhoto {
  MatchProfilePhoto({
    this.url,
    this.visibilityStatus,
    this.isVerified,
  });

  MatchProfilePhoto.fromJson(dynamic json) {
    url = json['url']?.toString();
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

class MatchProfileLocation {
  MatchProfileLocation({
    this.locationType,
    this.city,
    this.state,
    this.country,
  });

  MatchProfileLocation.fromJson(dynamic json) {
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

class MatchCompatibility {
  MatchCompatibility({
    this.matchPercentage,
    this.matchedCriteria,
    this.totalCriteria,
    this.label,
  });

  MatchCompatibility.fromJson(dynamic json) {
    matchPercentage = _parseNum(json['matchPercentage']);
    matchedCriteria = json['matchedCriteria'] != null
        ? List<String>.from(json['matchedCriteria'])
        : null;
    totalCriteria = json['totalCriteria'];
    label = json['label'];
  }

  num? matchPercentage;
  List<String>? matchedCriteria;
  int? totalCriteria;
  String? label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['matchPercentage'] = matchPercentage;
    map['matchedCriteria'] = matchedCriteria;
    map['totalCriteria'] = totalCriteria;
    map['label'] = label;
    return map;
  }
}

class MatchConnection {
  MatchConnection({
    this.id,
    this.status,
    this.direction,
    this.requestType,
    this.message,
    this.responseMessage,
    this.respondedAt,
    this.expiresAt,
    this.isPriority,
    this.viewCount,
    this.lastViewedAt,
    this.reminderCount,
    this.lastReminderAt,
    this.createdAt,
    this.updatedAt,
    this.conversationId,
    this.isOnline,
    this.lastSeenAt,
  });

  MatchConnection.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    direction = json['direction'];
    requestType = json['requestType'];
    message = json['message'];
    responseMessage = json['responseMessage'];
    respondedAt = json['respondedAt'];
    expiresAt = json['expiresAt'];
    isPriority = json['isPriority'];
    viewCount = json['viewCount'];
    lastViewedAt = json['lastViewedAt'];
    reminderCount = json['reminderCount'];
    lastReminderAt = json['lastReminderAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    conversationId = json['conversationId'];
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
  }

  String? id;
  String? status;
  String? direction;
  String? requestType;
  String? message;
  String? responseMessage;
  String? respondedAt;
  String? expiresAt;
  bool? isPriority;
  int? viewCount;
  String? lastViewedAt;
  int? reminderCount;
  String? lastReminderAt;
  String? createdAt;
  String? updatedAt;
  String? conversationId;
  bool? isOnline;
  String? lastSeenAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['direction'] = direction;
    map['requestType'] = requestType;
    map['message'] = message;
    map['responseMessage'] = responseMessage;
    map['respondedAt'] = respondedAt;
    map['expiresAt'] = expiresAt;
    map['isPriority'] = isPriority;
    map['viewCount'] = viewCount;
    map['lastViewedAt'] = lastViewedAt;
    map['reminderCount'] = reminderCount;
    map['lastReminderAt'] = lastReminderAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['conversationId'] = conversationId;
    map['isOnline'] = isOnline;
    map['lastSeenAt'] = lastSeenAt;
    return map;
  }
}

class MatchesPagination {
  MatchesPagination({
    this.total,
    this.page,
    this.size,
    this.totalPages,
  });

  MatchesPagination.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    size = json['size'];
    totalPages = json['totalPages'];
  }

  int? total;
  int? page;
  int? size;
  int? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['size'] = size;
    map['totalPages'] = totalPages;
    return map;
  }
}

class SavedSearch {
  SavedSearch({
    this.id,
    this.searchTitle,
    this.isSaved,
    this.createdAt,
  });

  SavedSearch.fromJson(dynamic json) {
    id = json['id'];
    searchTitle = json['searchTitle'];
    isSaved = json['isSaved'];
    createdAt = json['createdAt'];
  }

  String? id;
  String? searchTitle;
  bool? isSaved;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['searchTitle'] = searchTitle;
    map['isSaved'] = isSaved;
    map['createdAt'] = createdAt;
    return map;
  }
}

num? _parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString());
}

Map<String, dynamic> _ensureMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  if (json is Map) return Map<String, dynamic>.from(json);
  return {};
}

Map<String, dynamic> _extractPayload(Map<String, dynamic> root) {
  final response = root['response'];
  if (response is Map<String, dynamic>) return response;
  if (response is Map) return Map<String, dynamic>.from(response);
  return root;
}
