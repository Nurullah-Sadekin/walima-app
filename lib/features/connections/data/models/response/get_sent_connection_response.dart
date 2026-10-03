import 'dart:convert';
GetSentConnectionResponse getSentConnectionResponseFromJson(String str) => GetSentConnectionResponse.fromJson(json.decode(str));
String getSentConnectionResponseToJson(GetSentConnectionResponse data) => json.encode(data.toJson());
class GetSentConnectionResponse {
  GetSentConnectionResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  GetSentConnectionResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
    traceId = json['traceId'];
  }
  String? code;
  String? message;
  Response? response;
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

Response responseFromJson(String str) => Response.fromJson(json.decode(str));
String responseToJson(Response data) => json.encode(data.toJson());
class Response {
  Response({
      this.data, 
      this.pagination,});

  Response.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<Data>? data;
  Pagination? pagination;

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

Pagination paginationFromJson(String str) => Pagination.fromJson(json.decode(str));
String paginationToJson(Pagination data) => json.encode(data.toJson());
class Pagination {
  Pagination({
      this.page, 
      this.size, 
      this.total, 
      this.totalPages, 
      this.hasNextPage, 
      this.hasPreviousPage, 
      this.start, 
      this.end,});

  Pagination.fromJson(dynamic json) {
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
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
      this.maritalStatus,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    userReference = json['userReference'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'] != null ? ProfilePhoto.fromJson(json['profilePhoto']) : null;
    age = json['age'];
    gender = json['gender'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
    connection = json['connection'] != null ? Connection.fromJson(json['connection']) : null;
    religion = json['religion'];
    community = json['community'];
    motherTongue = json['motherTongue'];
    maritalStatus = json['maritalStatus'];
  }
  String? id;
  String? userReference;
  String? displayName;
  ProfilePhoto? profilePhoto;
  num? age;
  String? gender;
  Location? location;
  bool? isOnline;
  String? lastSeenAt;
  Connection? connection;
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

Connection connectionFromJson(String str) => Connection.fromJson(json.decode(str));
String connectionToJson(Connection data) => json.encode(data.toJson());
class Connection {
  Connection({
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
      this.lastSeenAt,});

  Connection.fromJson(dynamic json) {
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
  dynamic respondedAt;
  String? expiresAt;
  bool? isPriority;
  num? viewCount;
  dynamic lastViewedAt;
  num? reminderCount;
  dynamic lastReminderAt;
  String? createdAt;
  String? updatedAt;
  dynamic conversationId;
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

Location locationFromJson(String str) => Location.fromJson(json.decode(str));
String locationToJson(Location data) => json.encode(data.toJson());
class Location {
  Location({
      this.locationType, 
      this.city, 
      this.state, 
      this.country,});

  Location.fromJson(dynamic json) {
    locationType = json['locationType'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }
  dynamic locationType;
  dynamic city;
  dynamic state;
  dynamic country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['locationType'] = locationType;
    map['city'] = city;
    map['state'] = state;
    map['country'] = country;
    return map;
  }

}

ProfilePhoto profilePhotoFromJson(String str) => ProfilePhoto.fromJson(json.decode(str));
String profilePhotoToJson(ProfilePhoto data) => json.encode(data.toJson());
class ProfilePhoto {
  ProfilePhoto({
      this.url, 
      this.visibilityStatus, 
      this.isVerified,});

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