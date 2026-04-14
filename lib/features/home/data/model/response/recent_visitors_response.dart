import 'dart:convert';
RecentVisitorsResponse recentVisitorsResponseFromJson(String str) => RecentVisitorsResponse.fromJson(json.decode(str));
String recentVisitorsResponseToJson(RecentVisitorsResponse data) => json.encode(data.toJson());
class RecentVisitorsResponse {
  RecentVisitorsResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  RecentVisitorsResponse.fromJson(dynamic json) {
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
      this.total, 
      this.page, 
      this.size, 
      this.totalPages, 
      this.hasNextPage, 
      this.hasPreviousPage,});

  Pagination.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    size = json['size'];
    totalPages = json['totalPages'];
    hasNextPage = json['hasNextPage'];
    hasPreviousPage = json['hasPreviousPage'];
  }
  num? total;
  num? page;
  num? size;
  num? totalPages;
  bool? hasNextPage;
  bool? hasPreviousPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['size'] = size;
    map['totalPages'] = totalPages;
    map['hasNextPage'] = hasNextPage;
    map['hasPreviousPage'] = hasPreviousPage;
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
      this.height, 
      this.gender, 
      this.location, 
      this.maritalStatus, 
      this.profession, 
      this.connection, 
      this.isPremium, 
      this.isVerified, 
      this.visitedAt, 
      this.visitCount, 
      this.mutualView,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    userReference = json['userReference'];
    displayName = json['displayName'];
    profilePhoto = json['profilePhoto'] != null ? ProfilePhoto.fromJson(json['profilePhoto']) : null;
    age = json['age'];
    height = json['height'];
    gender = json['gender'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    maritalStatus = json['maritalStatus'];
    profession = json['profession'];
    connection = json['connection'] != null ? Connection.fromJson(json['connection']) : null;
    isPremium = json['isPremium'];
    isVerified = json['isVerified'];
    visitedAt = json['visitedAt'];
    visitCount = json['visitCount'];
    mutualView = json['mutualView'];
  }
  String? id;
  String? userReference;
  String? displayName;
  ProfilePhoto? profilePhoto;
  num? age;
  num? height;
  String? gender;
  Location? location;
  String? maritalStatus;
  dynamic profession;
  Connection? connection;
  bool? isPremium;
  bool? isVerified;
  String? visitedAt;
  num? visitCount;
  bool? mutualView;

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
    map['maritalStatus'] = maritalStatus;
    map['profession'] = profession;
    if (connection != null) {
      map['connection'] = connection?.toJson();
    }
    map['isPremium'] = isPremium;
    map['isVerified'] = isVerified;
    map['visitedAt'] = visitedAt;
    map['visitCount'] = visitCount;
    map['mutualView'] = mutualView;
    return map;
  }

}

Connection connectionFromJson(String str) => Connection.fromJson(json.decode(str));
String connectionToJson(Connection data) => json.encode(data.toJson());
class Connection {
  Connection({
      this.id, 
      this.status, 
      this.direction, 
      this.requestType, 
      this.message, 
      this.responseMessage, 
      this.respondedAt, 
      this.conversationId, 
      this.expiresAt, 
      this.isPriority, 
      this.viewCount, 
      this.lastViewedAt, 
      this.reminderCount, 
      this.lastReminderAt, 
      this.createdAt, 
      this.updatedAt,});

  Connection.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    direction = json['direction'];
    requestType = json['requestType'];
    message = json['message'];
    responseMessage = json['responseMessage'];
    respondedAt = json['respondedAt'];
    conversationId = json['conversationId'];
    expiresAt = json['expiresAt'];
    isPriority = json['isPriority'];
    viewCount = json['viewCount'];
    lastViewedAt = json['lastViewedAt'];
    reminderCount = json['reminderCount'];
    lastReminderAt = json['lastReminderAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? status;
  String? direction;
  String? requestType;
  String? message;
  dynamic responseMessage;
  dynamic respondedAt;
  dynamic conversationId;
  String? expiresAt;
  bool? isPriority;
  num? viewCount;
  dynamic lastViewedAt;
  num? reminderCount;
  dynamic lastReminderAt;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['direction'] = direction;
    map['requestType'] = requestType;
    map['message'] = message;
    map['responseMessage'] = responseMessage;
    map['respondedAt'] = respondedAt;
    map['conversationId'] = conversationId;
    map['expiresAt'] = expiresAt;
    map['isPriority'] = isPriority;
    map['viewCount'] = viewCount;
    map['lastViewedAt'] = lastViewedAt;
    map['reminderCount'] = reminderCount;
    map['lastReminderAt'] = lastReminderAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

Location locationFromJson(String str) => Location.fromJson(json.decode(str));
String locationToJson(Location data) => json.encode(data.toJson());
class Location {
  Location({
      this.city, 
      this.state, 
      this.country,});

  Location.fromJson(dynamic json) {
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }
  String? city;
  dynamic state;
  String? country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
  dynamic url;
  dynamic visibilityStatus;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['visibilityStatus'] = visibilityStatus;
    map['isVerified'] = isVerified;
    return map;
  }

}