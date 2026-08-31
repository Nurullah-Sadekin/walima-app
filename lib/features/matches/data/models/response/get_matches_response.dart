import 'package:walima_llc/features/matches/domain/enums/match_connection_state.dart';

class GetMatchesResponse {
  GetMatchesResponse({
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.savedSearch,
    this.errors,
    this.traceId,
    this.statusCode,
  });

  GetMatchesResponse.fromJson(dynamic json, {this.statusCode}) {
    final raw = _ensureMap(json);
    code = raw['code'];
    message = raw['message'];
    traceId = raw['traceId'];

    final payload = _extractPayload(raw);

    final rawData = payload['data'];
    if (rawData is List) {
      data = rawData.map(MatchProfile.fromJson).toList(growable: false);
    }
    pagination = payload['pagination'] != null
        ? MatchesPagination.fromJson(payload['pagination'])
        : null;
    savedSearch = payload['savedSearch'] != null
        ? SavedSearch.fromJson(payload['savedSearch'])
        : null;
    errors = _parseErrors(payload['errors']);
  }

  String? code;
  String? message;
  List<MatchProfile>? data;
  MatchesPagination? pagination;
  SavedSearch? savedSearch;
  Map<String, List<String>>? errors;
  String? traceId;
  int? statusCode;

  bool get isSuccess {
    if (code != null) return code?.toUpperCase() == 'SUCCESS';
    return statusCode != null && statusCode! >= 200 && statusCode! < 300;
  }

  String? firstErrorFor(String field) {
    final fieldErrors = errors?[field];
    if (fieldErrors == null || fieldErrors.isEmpty) return null;
    return fieldErrors.first;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['response'] = <String, dynamic>{
      if (data != null) 'data': data?.map((item) => item.toJson()).toList(),
      if (pagination != null) 'pagination': pagination?.toJson(),
      if (savedSearch != null) 'savedSearch': savedSearch?.toJson(),
      if (errors != null) 'errors': errors,
    };
    map['traceId'] = traceId;
    map['statusCode'] = statusCode;
    return map;
  }
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
    age = _parseInt(json['age']);
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

  MatchConnectionState get connectionState =>
      connection?.state ?? MatchConnectionState.none;

  bool get canConnect => connectionState.canConnect;

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
    this.criteria,
    this.scoreBreakdown,
  });

  MatchCompatibility.fromJson(dynamic json) {
    matchPercentage = _parseNum(json['matchPercentage']);
    matchedCriteria = json['matchedCriteria'] != null
        ? List<String>.from(json['matchedCriteria'])
        : null;
    totalCriteria = _parseInt(json['totalCriteria']);
    label = json['label'];
    criteria = json['criteria'] is Map
        ? Map<String, dynamic>.from(json['criteria'])
        : null;
    scoreBreakdown = json['scoreBreakdown'] is Map
        ? Map<String, dynamic>.from(json['scoreBreakdown'])
        : null;
  }

  num? matchPercentage;
  List<String>? matchedCriteria;
  int? totalCriteria;
  String? label;
  Map<String, dynamic>? criteria;
  Map<String, dynamic>? scoreBreakdown;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['matchPercentage'] = matchPercentage;
    map['matchedCriteria'] = matchedCriteria;
    map['totalCriteria'] = totalCriteria;
    map['label'] = label;
    map['criteria'] = criteria;
    map['scoreBreakdown'] = scoreBreakdown;
    return map;
  }
}

class MatchConnection {
  MatchConnection({
    this.id,
    this.status,
    this.rawStatus,
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
    direction = json['direction'];
    rawStatus = json['status']?.toString();
    status = normalizeMatchConnectionState(
      rawStatus,
      direction: direction,
    ).apiValue;
    requestType = json['requestType'];
    message = json['message'];
    responseMessage = json['responseMessage'];
    respondedAt = json['respondedAt'];
    expiresAt = json['expiresAt'];
    isPriority = json['isPriority'];
    viewCount = _parseInt(json['viewCount']);
    lastViewedAt = json['lastViewedAt'];
    reminderCount = _parseInt(json['reminderCount']);
    lastReminderAt = json['lastReminderAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    conversationId = json['conversationId'];
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
  }

  String? id;
  String? status;
  String? rawStatus;
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

  MatchConnectionState get state => normalizeMatchConnectionState(
        rawStatus ?? status,
        direction: direction,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = rawStatus ?? status;
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
    total = _parseInt(json['total']);
    page = _parseInt(json['page']);
    size = _parseInt(json['size']);
    totalPages = _parseInt(json['totalPages']);
  }

  int? total;
  int? page;
  int? size;
  int? totalPages;

  bool get hasNextPage => (page ?? 1) < (totalPages ?? 0);

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

int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
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
  return const <String, dynamic>{};
}

Map<String, List<String>>? _parseErrors(dynamic raw) {
  if (raw is! Map) return null;

  final parsed = <String, List<String>>{};
  raw.forEach((key, value) {
    final normalizedKey = key.toString();
    if (value is List) {
      final messages = value.map((item) => item.toString()).toList();
      if (messages.isNotEmpty) {
        parsed[normalizedKey] = messages;
      }
      return;
    }

    if (value != null) {
      parsed[normalizedKey] = [value.toString()];
    }
  });

  return parsed.isEmpty ? null : parsed;
}
