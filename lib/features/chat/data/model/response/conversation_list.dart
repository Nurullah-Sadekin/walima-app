import 'dart:convert';

ConversationListResponse conversationListFromJson(String str) =>
    ConversationListResponse.fromJson(json.decode(str));
String conversationListToJson(ConversationListResponse data) =>
    json.encode(data.toJson());

class ConversationListResponse {
  ConversationListResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  ConversationListResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
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
    this.conversations,
  });

  Response.fromJson(dynamic json) {
    if (json['conversations'] != null) {
      conversations = [];
      json['conversations'].forEach((v) {
        conversations?.add(Conversations.fromJson(v));
      });
    }
  }
  List<Conversations>? conversations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (conversations != null) {
      map['conversations'] = conversations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Conversations conversationsFromJson(String str) =>
    Conversations.fromJson(json.decode(str));
String conversationsToJson(Conversations data) => json.encode(data.toJson());

class Conversations {
  Conversations({
    this.id,
    this.type,
    this.status,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount,
    this.participants,
    this.createdAt,
    this.updatedAt,
  });

  Conversations.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    lastMessage = json['lastMessage'];
    lastMessageAt = json['lastMessageAt'];
    unreadCount = json['unreadCount'];
    if (json['participants'] != null) {
      participants = [];
      json['participants'].forEach((v) {
        participants?.add(Participants.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? type;
  String? status;
  String? lastMessage;
  String? lastMessageAt;
  int? unreadCount;
  List<Participants>? participants;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['status'] = status;
    map['lastMessage'] = lastMessage;
    map['lastMessageAt'] = lastMessageAt;
    map['unreadCount'] = unreadCount;
    if (participants != null) {
      map['participants'] = participants?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

Participants participantsFromJson(String str) =>
    Participants.fromJson(json.decode(str));
String participantsToJson(Participants data) => json.encode(data.toJson());

class Participants {
  Participants({
    this.userId,
    this.displayName,
    this.firstName,
    this.lastName,
    this.username,
    this.userReference,
    this.profilePhoto,
    this.profilePictureUrl,
    this.isOnline,
    this.lastSeenAt,
  });

  Participants.fromJson(dynamic json) {
    userId = json['userId'];
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    userReference = json['userReference'];
    profilePhoto = json['profilePhoto'] != null
        ? ProfilePhoto.fromJson(json['profilePhoto'])
        : null;
    final directProfilePictureUrl = json['profilePictureUrl'];
    profilePictureUrl = directProfilePictureUrl is String
        ? directProfilePictureUrl
        : profilePhoto?.url;
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
  }

  String? userId;
  String? displayName;
  String? firstName;
  String? lastName;
  String? username;
  String? userReference;
  ProfilePhoto? profilePhoto;
  String? profilePictureUrl;
  bool? isOnline;
  String? lastSeenAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['displayName'] = displayName;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['userReference'] = userReference;
    if (profilePhoto != null) {
      map['profilePhoto'] = profilePhoto?.toJson();
    }
    map['profilePictureUrl'] = profilePictureUrl;
    map['isOnline'] = isOnline;
    map['lastSeenAt'] = lastSeenAt;
    return map;
  }
}

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
