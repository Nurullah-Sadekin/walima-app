class GetRequestedConnectionsResponse {
  GetRequestedConnectionsResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
    this.statusCode,
  });

  GetRequestedConnectionsResponse.fromJson(dynamic json, {this.statusCode}) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? RequestedConnectionsResult.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  RequestedConnectionsResult? response;
  String? traceId;
  int? statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['traceId'] = traceId;
    map['statusCode'] = statusCode;
    return map;
  }
}

class RequestedConnectionsResult {
  RequestedConnectionsResult({
    this.data,
    this.pagination,
  });

  RequestedConnectionsResult.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(RequestedConnectionUser.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? RequestedConnectionsPagination.fromJson(json['pagination'])
        : null;
  }

  List<RequestedConnectionUser>? data;
  RequestedConnectionsPagination? pagination;

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

class RequestedConnectionUser {
  RequestedConnectionUser({
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

  RequestedConnectionUser.fromJson(dynamic json) {
    id = json['id'];
    userReference = json['userReference'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'] != null
        ? RequestedConnectionPhoto.fromJson(json['profilePhoto'])
        : null;
    age = json['age'];
    gender = json['gender'];
    location = json['location'] != null
        ? RequestedConnectionLocation.fromJson(json['location'])
        : null;
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
    connection = json['connection'] != null
        ? RequestedConnectionDetails.fromJson(json['connection'])
        : null;
    religion = json['religion'];
    community = json['community'];
    motherTongue = json['motherTongue'];
    maritalStatus = json['maritalStatus'];
  }

  String? id;
  String? userReference;
  String? displayName;
  RequestedConnectionPhoto? profilePhoto;
  int? age;
  String? gender;
  RequestedConnectionLocation? location;
  bool? isOnline;
  String? lastSeenAt;
  RequestedConnectionDetails? connection;
  String? religion;
  String? community;
  String? motherTongue;
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

class RequestedConnectionPhoto {
  RequestedConnectionPhoto({
    this.url,
    this.visibilityStatus,
    this.isVerified,
  });

  RequestedConnectionPhoto.fromJson(dynamic json) {
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

class RequestedConnectionLocation {
  RequestedConnectionLocation({
    this.locationType,
    this.city,
    this.state,
    this.country,
  });

  RequestedConnectionLocation.fromJson(dynamic json) {
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

class RequestedConnectionDetails {
  RequestedConnectionDetails({
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

  RequestedConnectionDetails.fromJson(dynamic json) {
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

class RequestedConnectionsPagination {
  RequestedConnectionsPagination({
    this.page,
    this.size,
    this.total,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
    this.start,
    this.end,
  });

  RequestedConnectionsPagination.fromJson(dynamic json) {
    page = json['page'];
    size = json['size'];
    total = json['total'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    hasPreviousPage = json['hasPreviousPage'];
    start = json['start'];
    end = json['end'];
  }

  int? page;
  int? size;
  int? total;
  int? totalPages;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

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
