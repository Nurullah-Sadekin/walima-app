import 'dart:convert';

import 'package:walima_llc/features/matches/domain/enums/match_connection_state.dart';

RecentVisitorsResponse recentVisitorsResponseFromJson(String source) =>
    RecentVisitorsResponse.fromJson(json.decode(source));

String recentVisitorsResponseToJson(RecentVisitorsResponse value) =>
    json.encode(value.toJson());

class RecentVisitorsResponse {
  RecentVisitorsResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
    this.statusCode,
  });

  RecentVisitorsResponse.fromJson(dynamic json, {this.statusCode}) {
    final root = _asMap(json);
    code = root['code']?.toString();
    message = root['message']?.toString();
    traceId = root['traceId']?.toString();
    final payload = root['response'];
    response = payload is Map ? Response.fromJson(payload) : null;
  }

  String? code;
  String? message;
  Response? response;
  String? traceId;
  int? statusCode;

  bool get isSuccess {
    if (code != null) return code?.toUpperCase() == 'SUCCESS';
    return statusCode != null && statusCode! >= 200 && statusCode! < 300;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'message': message,
        if (response != null) 'response': response!.toJson(),
        'traceId': traceId,
      };
}

class Response {
  Response({
    this.data,
    this.pagination,
    this.hasRecentVisitorsFeature,
    this.recentVisitorsFeatureKey,
  });

  Response.fromJson(dynamic json) {
    final payload = _asMap(json);
    final rawData = payload['data'];
    data = rawData is List
        ? rawData.map(Data.fromJson).toList(growable: false)
        : <Data>[];
    pagination = payload['pagination'] is Map
        ? Pagination.fromJson(payload['pagination'])
        : null;
    hasRecentVisitorsFeature = payload['hasRecentVisitorsFeature'] is bool
        ? payload['hasRecentVisitorsFeature'] as bool
        : null;
    recentVisitorsFeatureKey = payload['recentVisitorsFeatureKey']?.toString();
  }

  List<Data>? data;
  Pagination? pagination;
  bool? hasRecentVisitorsFeature;
  String? recentVisitorsFeatureKey;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (data != null) 'data': data!.map((item) => item.toJson()).toList(),
        if (pagination != null) 'pagination': pagination!.toJson(),
        'hasRecentVisitorsFeature': hasRecentVisitorsFeature,
        'recentVisitorsFeatureKey': recentVisitorsFeatureKey,
      };
}

class Pagination {
  Pagination({
    this.total,
    this.page,
    this.size,
    this.totalPages,
    this.serverHasNextPage,
    this.hasPreviousPage,
  });

  Pagination.fromJson(dynamic json) {
    final raw = _asMap(json);
    total = _parseInt(raw['total']);
    page = _parseInt(raw['page']);
    size = _parseInt(raw['size']);
    totalPages = _parseInt(raw['totalPages']);
    serverHasNextPage = raw['hasNextPage'] as bool?;
    hasPreviousPage = raw['hasPreviousPage'] as bool?;
  }

  int? total;
  int? page;
  int? size;
  int? totalPages;
  bool? serverHasNextPage;
  bool? hasPreviousPage;

  bool get hasNextPage => serverHasNextPage ?? (page ?? 1) < (totalPages ?? 0);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'total': total,
        'page': page,
        'size': size,
        'totalPages': totalPages,
        'hasNextPage': hasNextPage,
        'hasPreviousPage': hasPreviousPage,
      };
}

class Data {
  Data({
    this.id,
    this.userReference,
    this.displayName,
    this.profilePhoto,
    this.age,
    this.height,
    this.gender,
    this.isOnline,
    this.lastSeenAt,
    this.location,
    this.maritalStatus,
    this.profession,
    this.education,
    this.connection,
    this.isPremium,
    this.isVerified,
    this.viewedAt,
    this.viewCount,
    this.visitedAt,
    this.visitCount,
    this.mutualView,
  });

  Data.fromJson(dynamic json) {
    final raw = _asMap(json);
    id = raw['id']?.toString();
    userReference = raw['userReference']?.toString();
    displayName = raw['displayName']?.toString();
    profilePhoto = raw['profilePhoto'] is Map
        ? ProfilePhoto.fromJson(raw['profilePhoto'])
        : null;
    age = _parseNum(raw['age']);
    height = _parseNum(raw['height']);
    gender = raw['gender']?.toString();
    isOnline = raw['isOnline'] as bool?;
    lastSeenAt = raw['lastSeenAt']?.toString();
    location =
        raw['location'] is Map ? Location.fromJson(raw['location']) : null;
    maritalStatus = raw['maritalStatus']?.toString();
    profession = raw['profession']?.toString();
    education = raw['education']?.toString();
    connection = raw['connection'] is Map
        ? Connection.fromJson(raw['connection'])
        : raw['connectionStatus'] != null
            ? Connection.fromLegacyStatus(raw['connectionStatus'])
            : null;
    isPremium = raw['isPremium'] as bool?;
    isVerified = raw['isVerified'] as bool?;
    viewedAt = raw['viewedAt']?.toString();
    viewCount = _parseInt(raw['viewCount']);
    visitedAt = raw['visitedAt']?.toString();
    visitCount = _parseInt(raw['visitCount']);
    mutualView = raw['mutualView'] as bool?;
  }

  String? id;
  String? userReference;
  String? displayName;
  ProfilePhoto? profilePhoto;
  num? age;
  num? height;
  String? gender;
  bool? isOnline;
  String? lastSeenAt;
  Location? location;
  String? maritalStatus;
  String? profession;
  String? education;
  Connection? connection;
  bool? isPremium;
  bool? isVerified;
  String? viewedAt;
  int? viewCount;
  String? visitedAt;
  int? visitCount;
  bool? mutualView;

  MatchConnectionState get connectionState =>
      connection?.state ?? MatchConnectionState.none;

  bool get canConnect => connectionState.canConnect;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userReference': userReference,
        'displayName': displayName,
        if (profilePhoto != null) 'profilePhoto': profilePhoto!.toJson(),
        'age': age,
        'height': height,
        'gender': gender,
        'isOnline': isOnline,
        'lastSeenAt': lastSeenAt,
        if (location != null) 'location': location!.toJson(),
        'maritalStatus': maritalStatus,
        'profession': profession,
        'education': education,
        if (connection != null) 'connection': connection!.toJson(),
        'isPremium': isPremium,
        'isVerified': isVerified,
        'viewedAt': viewedAt,
        'viewCount': viewCount,
        'visitedAt': visitedAt,
        'visitCount': visitCount,
        'mutualView': mutualView,
      };
}

class Connection {
  Connection({
    this.id,
    this.status,
    this.rawStatus,
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
    this.updatedAt,
  });

  Connection.fromJson(dynamic json) {
    final raw = _asMap(json);
    id = raw['id']?.toString();
    direction = raw['direction']?.toString();
    rawStatus = raw['status']?.toString();
    status = normalizeMatchConnectionState(
      rawStatus,
      direction: direction,
    ).apiValue;
    requestType = raw['requestType']?.toString();
    message = raw['message']?.toString();
    responseMessage = raw['responseMessage'];
    respondedAt = raw['respondedAt']?.toString();
    conversationId = raw['conversationId']?.toString();
    expiresAt = raw['expiresAt']?.toString();
    isPriority = raw['isPriority'] as bool?;
    viewCount = _parseInt(raw['viewCount']);
    lastViewedAt = raw['lastViewedAt']?.toString();
    reminderCount = _parseInt(raw['reminderCount']);
    lastReminderAt = raw['lastReminderAt']?.toString();
    createdAt = raw['createdAt']?.toString();
    updatedAt = raw['updatedAt']?.toString();
  }

  Connection.fromLegacyStatus(dynamic value) {
    rawStatus = value?.toString();
    status = normalizeMatchConnectionState(rawStatus).apiValue;
  }

  String? id;
  String? status;
  String? rawStatus;
  String? direction;
  String? requestType;
  String? message;
  dynamic responseMessage;
  String? respondedAt;
  String? conversationId;
  String? expiresAt;
  bool? isPriority;
  int? viewCount;
  String? lastViewedAt;
  int? reminderCount;
  String? lastReminderAt;
  String? createdAt;
  String? updatedAt;

  MatchConnectionState get state => normalizeMatchConnectionState(
        rawStatus ?? status,
        direction: direction,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'status': rawStatus ?? status,
        'direction': direction,
        'requestType': requestType,
        'message': message,
        'responseMessage': responseMessage,
        'respondedAt': respondedAt,
        'conversationId': conversationId,
        'expiresAt': expiresAt,
        'isPriority': isPriority,
        'viewCount': viewCount,
        'lastViewedAt': lastViewedAt,
        'reminderCount': reminderCount,
        'lastReminderAt': lastReminderAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class Location {
  Location({this.city, this.state, this.country});

  Location.fromJson(dynamic json) {
    final raw = _asMap(json);
    city = raw['city']?.toString();
    state = raw['state']?.toString();
    country = raw['country']?.toString();
  }

  String? city;
  String? state;
  String? country;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'city': city,
        'state': state,
        'country': country,
      };
}

class ProfilePhoto {
  ProfilePhoto({this.url, this.visibilityStatus, this.isVerified});

  ProfilePhoto.fromJson(dynamic json) {
    final raw = _asMap(json);
    url = raw['url']?.toString();
    visibilityStatus = raw['visibilityStatus']?.toString();
    isVerified = raw['isVerified'] as bool?;
  }

  String? url;
  String? visibilityStatus;
  bool? isVerified;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'url': url,
        'visibilityStatus': visibilityStatus,
        'isVerified': isVerified,
      };
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

num? _parseNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '');
}

int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
