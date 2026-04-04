class AcceptedConnectionResponse {
  AcceptedConnectionResponse({this.code, this.message, this.response, this.traceId});

  AcceptedConnectionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null ? AcceptedResponse.fromJson(json['response']) : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  AcceptedResponse? response;
  String? traceId;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (response != null) data['response'] = response!.toJson();
    data['traceId'] = traceId;
    return data;
  }
}

class AcceptedResponse {
  AcceptedResponse({this.data, this.pagination});

  AcceptedResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AcceptedData>[];
      json['data'].forEach((v) {
        data!.add(AcceptedData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? AcceptedPagination.fromJson(json['pagination']) : null;
  }

  List<AcceptedData>? data;
  AcceptedPagination? pagination;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) data['data'] = this.data!.map((v) => v.toJson()).toList();
    if (pagination != null) data['pagination'] = pagination!.toJson();
    return data;
  }
}

class AcceptedData {
  AcceptedData({
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

  AcceptedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userReference = json['userReference'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'] != null ? AcceptedProfilePhoto.fromJson(json['profilePhoto']) : null;
    age = json['age'];
    gender = json['gender'];
    location = json['location'] != null ? AcceptedLocation.fromJson(json['location']) : null;
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
    connection = json['connection'] != null ? AcceptedConnection.fromJson(json['connection']) : null;
    religion = json['religion'];
    community = json['community'];
    motherTongue = json['motherTongue'];
    maritalStatus = json['maritalStatus'];
  }

  String? id;
  String? userReference;
  String? displayName;
  AcceptedProfilePhoto? profilePhoto;
  int? age;
  String? gender;
  AcceptedLocation? location;
  bool? isOnline;
  String? lastSeenAt;
  AcceptedConnection? connection;
  String? religion;
  String? community;
  String? motherTongue;
  String? maritalStatus;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userReference'] = userReference;
    data['displayName'] = displayName;
    if (profilePhoto != null) data['profilePhoto'] = profilePhoto!.toJson();
    data['age'] = age;
    data['gender'] = gender;
    if (location != null) data['location'] = location!.toJson();
    data['isOnline'] = isOnline;
    data['lastSeenAt'] = lastSeenAt;
    if (connection != null) data['connection'] = connection!.toJson();
    data['religion'] = religion;
    data['community'] = community;
    data['motherTongue'] = motherTongue;
    data['maritalStatus'] = maritalStatus;
    return data;
  }
}

class AcceptedProfilePhoto {
  AcceptedProfilePhoto({this.url, this.visibilityStatus, this.isVerified});

  AcceptedProfilePhoto.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    visibilityStatus = json['visibilityStatus'];
    isVerified = json['isVerified'];
  }

  String? url;
  String? visibilityStatus;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['visibilityStatus'] = visibilityStatus;
    data['isVerified'] = isVerified;
    return data;
  }
}

class AcceptedLocation {
  AcceptedLocation({this.locationType, this.city, this.state, this.country});

  AcceptedLocation.fromJson(Map<String, dynamic> json) {
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
    final data = <String, dynamic>{};
    data['locationType'] = locationType;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    return data;
  }
}

class AcceptedConnection {
  AcceptedConnection({
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

  AcceptedConnection.fromJson(Map<String, dynamic> json) {
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
    final data = <String, dynamic>{};
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

class AcceptedPagination {
  AcceptedPagination({this.page, this.size, this.total});

  AcceptedPagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    size = json['size'];
    total = json['total'];
  }

  int? page;
  int? size;
  int? total;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['page'] = page;
    data['size'] = size;
    data['total'] = total;
    return data;
  }
}

