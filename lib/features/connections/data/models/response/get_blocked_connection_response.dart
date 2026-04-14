import 'dart:convert';

GetBlockedConnectionResponse getBlockedConnectionResponseFromJson(String str) =>
    GetBlockedConnectionResponse.fromJson(json.decode(str));

String getBlockedConnectionResponseToJson(GetBlockedConnectionResponse data) =>
    json.encode(data.toJson());

class GetBlockedConnectionResponse {
  GetBlockedConnectionResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  GetBlockedConnectionResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? BlockedConnectionsResponse.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  BlockedConnectionsResponse? response;
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

class BlockedConnectionsResponse {
  BlockedConnectionsResponse({
    this.data,
    this.pagination,
  });

  BlockedConnectionsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(BlockedConnectionData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? BlockedConnectionsPagination.fromJson(json['pagination'])
        : null;
  }

  List<BlockedConnectionData>? data;
  BlockedConnectionsPagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }
}

class BlockedConnectionsPagination {
  BlockedConnectionsPagination({
    this.page,
    this.size,
    this.total,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
    this.start,
    this.end,
  });

  BlockedConnectionsPagination.fromJson(dynamic json) {
    page = json['page'];
    size = json['size'];
    total = json['total'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    hasPreviousPage = json['hasPreviousPage'];
    start = json['start'];
    end = json['end'];
  }

  num? page;
  num? size;
  num? total;
  num? totalPages;
  bool? hasNextPage;
  bool? hasPreviousPage;
  num? start;
  num? end;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['size'] = size;
    map['total'] = total;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['hasPreviousPage'] = hasPreviousPage;
    map['start'] = start;
    map['end'] = end;
    return map;
  }
}

class BlockedConnectionData {
  BlockedConnectionData({
    this.id,
    this.userReference,
    this.displayName,
    this.profilePhoto,
    this.age,
    this.gender,
    this.location,
    this.isOnline,
    this.lastSeenAt,
    this.connection,
    this.religion,
    this.community,
    this.motherTongue,
    this.maritalStatus,
  });

  BlockedConnectionData.fromJson(dynamic json) {
    id = json['id'];
    userReference = json['userReference'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'] != null
        ? BlockedConnectionProfilePhoto.fromJson(json['profilePhoto'])
        : null;
    age = json['age'];
    gender = json['gender'];
    location = json['location'] != null
        ? BlockedConnectionLocation.fromJson(json['location'])
        : null;
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
    connection = json['connection'] != null
        ? BlockedConnectionDetails.fromJson(json['connection'])
        : null;
    religion = json['religion'];
    community = json['community'];
    motherTongue = json['motherTongue'];
    maritalStatus = json['maritalStatus'];
  }

  String? id;
  String? userReference;
  String? displayName;
  BlockedConnectionProfilePhoto? profilePhoto;
  num? age;
  String? gender;
  BlockedConnectionLocation? location;
  bool? isOnline;
  String? lastSeenAt;
  BlockedConnectionDetails? connection;
  String? religion;
  String? community;
  dynamic motherTongue;
  String? maritalStatus;

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
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['isOnline'] = isOnline;
    map['lastSeenAt'] = lastSeenAt;
    if (connection != null) {
      map['connection'] = connection?.toJson();
    }
    map['religion'] = religion;
    map['community'] = community;
    map['motherTongue'] = motherTongue;
    map['maritalStatus'] = maritalStatus;
    return map;
  }
}

class BlockedConnectionProfilePhoto {
  BlockedConnectionProfilePhoto({
    this.url,
    this.visibilityStatus,
    this.visibilitySetting,
    this.isVerified,
  });

  BlockedConnectionProfilePhoto.fromJson(dynamic json) {
    url = json['url'];
    visibilityStatus = json['visibilityStatus'];
    visibilitySetting = json['visibilitySetting'];
    isVerified = json['isVerified'];
  }

  dynamic url;
  dynamic visibilityStatus;
  dynamic visibilitySetting;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['visibilityStatus'] = visibilityStatus;
    map['visibilitySetting'] = visibilitySetting;
    map['isVerified'] = isVerified;
    return map;
  }
}

class BlockedConnectionLocation {
  BlockedConnectionLocation({
    this.locationType,
    this.city,
    this.state,
    this.country,
  });

  BlockedConnectionLocation.fromJson(dynamic json) {
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

class BlockedConnectionDetails {
  BlockedConnectionDetails({
    this.id,
    this.direction,
    this.requestType,
    this.status,
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

  BlockedConnectionDetails.fromJson(dynamic json) {
    id = json['id'];
    direction = json['direction'];
    requestType = json['requestType'];
    status = json['status'];
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
  String? direction;
  String? requestType;
  String? status;
  String? message;
  dynamic responseMessage;
  String? respondedAt;
  String? expiresAt;
  bool? isPriority;
  num? viewCount;
  dynamic lastViewedAt;
  num? reminderCount;
  dynamic lastReminderAt;
  String? createdAt;
  String? updatedAt;
  String? conversationId;
  dynamic isOnline;
  dynamic lastSeenAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['direction'] = direction;
    map['requestType'] = requestType;
    map['status'] = status;
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
