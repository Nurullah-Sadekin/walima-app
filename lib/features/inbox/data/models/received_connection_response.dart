class ReceivedConnectionResponse {

  ReceivedConnectionResponse(
      {this.code, this.message, this.response, this.traceId});

  ReceivedConnectionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }
  String? code;
  String? message;
  Response? response;
  String? traceId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    data['traceId'] = traceId;
    return data;
  }
}

class Response {

  Response({this.data, this.pagination});

  Response.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }
  List<Data>? data;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Data {

  Data(
      {this.id,
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
        this.maritalStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userReference = json['userReference'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'] != null
        ? new ProfilePhoto.fromJson(json['profilePhoto'])
        : null;
    age = json['age'];
    gender = json['gender'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
    connection = json['connection'] != null
        ? new Connection.fromJson(json['connection'])
        : null;
    religion = json['religion'];
    community = json['community'];
    motherTongue = json['motherTongue'];
    maritalStatus = json['maritalStatus'];
  }
  String? id;
  String? userReference;
  String? displayName;
  ProfilePhoto? profilePhoto;
  int? age;
  String? gender;
  Location? location;
  bool? isOnline;
  String? lastSeenAt;
  Connection? connection;
  String? religion;
  String? community;
  String? motherTongue;
  String? maritalStatus;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userReference'] = userReference;
    data['displayName'] = displayName;
    if (profilePhoto != null) {
      data['profilePhoto'] = profilePhoto!.toJson();
    }
    data['age'] = age;
    data['gender'] = gender;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['isOnline'] = isOnline;
    data['lastSeenAt'] = lastSeenAt;
    if (connection != null) {
      data['connection'] = connection!.toJson();
    }
    data['religion'] = religion;
    data['community'] = community;
    data['motherTongue'] = motherTongue;
    data['maritalStatus'] = maritalStatus;
    return data;
  }
}

class ProfilePhoto {

  ProfilePhoto({this.url, this.visibilityStatus, this.isVerified});

  ProfilePhoto.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    visibilityStatus = json['visibilityStatus'];
    isVerified = json['isVerified'];
  }
  String? url;
  String? visibilityStatus;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['visibilityStatus'] = visibilityStatus;
    data['isVerified'] = isVerified;
    return data;
  }
}

class Location {

  Location({this.locationType, this.city, this.state, this.country});

  Location.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationType'] = locationType;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    return data;
  }
}

class Connection {

  Connection(
      {this.id,
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
        this.lastSeenAt});

  Connection.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['direction'] = direction;
    data['requestType'] = requestType;
    data['status'] = status;
    data['message'] = message;
    data['responseMessage'] = responseMessage;
    data['respondedAt'] = respondedAt;
    data['expiresAt'] = expiresAt;
    data['isPriority'] = isPriority;
    data['viewCount'] = viewCount;
    data['lastViewedAt'] = lastViewedAt;
    data['reminderCount'] = reminderCount;
    data['lastReminderAt'] = lastReminderAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['conversationId'] = conversationId;
    data['isOnline'] = isOnline;
    data['lastSeenAt'] = lastSeenAt;
    return data;
  }
}

class Pagination {

  Pagination(
      {this.page,
        this.size,
        this.total,
        this.totalPages,
        this.hasNextPage,
        this.hasPreviousPage,
        this.start,
        this.end});

  Pagination.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['size'] = size;
    data['total'] = total;
    data['totalPages'] = totalPages;
    data['hasNextPage'] = hasNextPage;
    data['hasPreviousPage'] = hasPreviousPage;
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
