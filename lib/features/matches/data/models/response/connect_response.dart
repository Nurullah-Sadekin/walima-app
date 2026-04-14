import 'dart:convert';

ConnectResponse connectResponseFromJson(String str) =>
    ConnectResponse.fromJson(json.decode(str));
String connectResponseToJson(ConnectResponse data) =>
    json.encode(data.toJson());

class ConnectResponse {
  ConnectResponse({
    this.code,
    this.message,
    this.traceId,
    this.statusCode,
    this.id,
    this.userReference,
    this.displayName,
    this.profilePhoto,
    this.connection,
    this.age,
    this.height,
    this.gender,
    this.location,
    this.religion,
    this.community,
    this.motherTongue,
    this.maritalStatus,
    this.isOnline,
    this.lastSeenAt,
    this.successfulRequests,
    this.failedRequests,
  });

  ConnectResponse.fromJson(dynamic json, {this.statusCode}) {
    code = json['code']?.toString();
    message = json['message']?.toString();
    traceId = json['traceId']?.toString();

    dynamic payload = json;
    final response = json['response'];
    if (response is Map) {
      successfulRequests = (response['successful'] as List<dynamic>?)
          ?.map((item) => ConnectionBatchResult.fromJson(item))
          .toList();
      failedRequests = (response['failed'] as List<dynamic>?)
          ?.map((item) => ConnectionBatchResult.fromJson(item))
          .toList();
      if (response['data'] is Map) {
        payload = response['data'];
      } else if (response['connection'] is Map) {
        payload = response['connection'];
      } else if (response['receiver'] is Map) {
        payload = response['receiver'];
      } else if (response.isNotEmpty) {
        payload = response;
      }
    }
    _mapPayload(payload);
  }
  String? code;
  String? message;
  String? traceId;
  int? statusCode;
  String? id;
  String? userReference;
  String? displayName;
  ProfilePhoto? profilePhoto;
  Connection? connection;
  num? age;
  num? height;
  String? gender;
  Location? location;
  String? religion;
  String? community;
  String? motherTongue;
  String? maritalStatus;
  bool? isOnline;
  String? lastSeenAt;
  List<ConnectionBatchResult>? successfulRequests;
  List<ConnectionBatchResult>? failedRequests;

  bool get isSuccess {
    if ((code ?? '').toUpperCase() == 'SUCCESS') return true;
    if (statusCode != null && statusCode! >= 200 && statusCode! < 300) {
      return true;
    }
    return false;
  }

  int get successfulCount => successfulRequests?.length ?? 0;

  int get failedCount => failedRequests?.length ?? 0;

  bool get isFullyFailed => failedCount > 0 && successfulCount == 0;

  bool get hasPartialOrFullSuccess {
    if (successfulCount > 0) return true;
    return isSuccess && failedCount == 0;
  }

  void _mapPayload(dynamic payload) {
    if (payload is! Map) return;
    id = payload['id']?.toString();
    userReference = payload['userReference']?.toString();
    displayName = payload['displayName']?.toString();
    profilePhoto = payload['profilePhoto'] != null
        ? ProfilePhoto.fromJson(payload['profilePhoto'])
        : null;
    connection = payload['connection'] != null
        ? Connection.fromJson(payload['connection'])
        : null;
    age = payload['age'];
    height = payload['height'];
    gender = payload['gender']?.toString();
    location = payload['location'] != null
        ? Location.fromJson(payload['location'])
        : null;
    religion = payload['religion']?.toString();
    community = payload['community']?.toString();
    motherTongue = payload['motherTongue']?.toString();
    maritalStatus = payload['maritalStatus']?.toString();
    isOnline = payload['isOnline'] == true;
    lastSeenAt = payload['lastSeenAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['traceId'] = traceId;
    map['statusCode'] = statusCode;
    map['id'] = id;
    map['userReference'] = userReference;
    map['displayName'] = displayName;
    if (profilePhoto != null) {
      map['profilePhoto'] = profilePhoto?.toJson();
    }
    if (connection != null) {
      map['connection'] = connection?.toJson();
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
    map['isOnline'] = isOnline;
    map['lastSeenAt'] = lastSeenAt;
    if (successfulRequests != null) {
      map['successful'] = successfulRequests?.map((item) => item.toJson()).toList();
    }
    if (failedRequests != null) {
      map['failed'] = failedRequests?.map((item) => item.toJson()).toList();
    }
    return map;
  }
}

class ConnectionBatchResult {
  ConnectionBatchResult({
    this.userId,
    this.reason,
  });

  ConnectionBatchResult.fromJson(dynamic json) {
    userId = json['userId']?.toString();
    reason = json['reason']?.toString();
  }

  String? userId;
  String? reason;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'reason': reason,
    };
  }
}

Location locationFromJson(String str) => Location.fromJson(json.decode(str));
String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  Location({
    this.locationType,
    this.city,
    this.state,
    this.country,
  });

  Location.fromJson(dynamic json) {
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

Connection connectionFromJson(String str) =>
    Connection.fromJson(json.decode(str));
String connectionToJson(Connection data) => json.encode(data.toJson());

class Connection {
  Connection({
    this.id,
    this.direction,
    this.requestType,
    this.status,
    this.isPriority,
    this.viewCount,
    this.reminderCount,
    this.createdAt,
    this.updatedAt,
    this.message,
    this.responseMessage,
    this.respondedAt,
    this.expiresAt,
    this.lastViewedAt,
    this.lastReminderAt,
    this.conversationId,
    this.isOnline,
    this.lastSeenAt,
  });

  Connection.fromJson(dynamic json) {
    id = json['id'];
    direction = json['direction'];
    requestType = json['requestType'];
    status = json['status'];
    isPriority = json['isPriority'];
    viewCount = json['viewCount'];
    reminderCount = json['reminderCount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    message = json['message'];
    responseMessage = json['responseMessage'];
    respondedAt = json['respondedAt'];
    expiresAt = json['expiresAt'];
    lastViewedAt = json['lastViewedAt'];
    lastReminderAt = json['lastReminderAt'];
    conversationId = json['conversationId'];
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
  }
  String? id;
  String? direction;
  String? requestType;
  String? status;
  bool? isPriority;
  num? viewCount;
  num? reminderCount;
  String? createdAt;
  String? updatedAt;
  String? message;
  String? responseMessage;
  String? respondedAt;
  String? expiresAt;
  String? lastViewedAt;
  String? lastReminderAt;
  String? conversationId;
  bool? isOnline;
  String? lastSeenAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['direction'] = direction;
    map['requestType'] = requestType;
    map['status'] = status;
    map['isPriority'] = isPriority;
    map['viewCount'] = viewCount;
    map['reminderCount'] = reminderCount;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['message'] = message;
    map['responseMessage'] = responseMessage;
    map['respondedAt'] = respondedAt;
    map['expiresAt'] = expiresAt;
    map['lastViewedAt'] = lastViewedAt;
    map['lastReminderAt'] = lastReminderAt;
    map['conversationId'] = conversationId;
    map['isOnline'] = isOnline;
    map['lastSeenAt'] = lastSeenAt;
    return map;
  }
}

ProfilePhoto profilePhotoFromJson(String str) =>
    ProfilePhoto.fromJson(json.decode(str));
String profilePhotoToJson(ProfilePhoto data) => json.encode(data.toJson());

class ProfilePhoto {
  ProfilePhoto({
    this.url,
    this.visibilityStatus,
    this.isVerified,
  });

  ProfilePhoto.fromJson(dynamic json) {
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
