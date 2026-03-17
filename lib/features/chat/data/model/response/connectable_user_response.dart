import 'dart:convert';
ConnectableUserResponse connectableUserResponseFromJson(String str) => ConnectableUserResponse.fromJson(json.decode(str));
String connectableUserResponseToJson(ConnectableUserResponse data) => json.encode(data.toJson());
class ConnectableUserResponse {
  ConnectableUserResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  ConnectableUserResponse.fromJson(dynamic json) {
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
      this.users, 
      this.total, 
      this.onlineCount,});

  Response.fromJson(dynamic json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(Users.fromJson(v));
      });
    }
    total = json['total'];
    onlineCount = json['onlineCount'];
  }
  List<Users>? users;
  int? total;
  int? onlineCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['onlineCount'] = onlineCount;
    return map;
  }

}

Users usersFromJson(String str) => Users.fromJson(json.decode(str));
String usersToJson(Users data) => json.encode(data.toJson());
class Users {
  Users({
      this.id, 
      this.displayName, 
      this.firstName, 
      this.lastName, 
      this.username, 
      this.userReference, 
      this.profilePictureUrl, 
      this.isConnected, 
      this.conversationId, 
      this.lastMessagePreview, 
      this.lastMessageSenderId, 
      this.lastMessageStatus, 
      this.lastMessageAt, 
      this.lastMessageReadAt, 
      this.lastMessageIsRead, 
      this.isOnline, 
      this.lastSeenAt,});

  Users.fromJson(dynamic json) {
    id = json['id'];
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    userReference = json['userReference'];
    profilePictureUrl = json['profilePictureUrl'];
    isConnected = json['isConnected'];
    conversationId = json['conversationId'];
    lastMessagePreview = json['lastMessagePreview'];
    lastMessageSenderId = json['lastMessageSenderId'];
    lastMessageStatus = json['lastMessageStatus'];
    lastMessageAt = json['lastMessageAt'];
    lastMessageReadAt = json['lastMessageReadAt'];
    lastMessageIsRead = json['lastMessageIsRead'];
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
  }
  String? id;
  String? displayName;
  String? firstName;
  String? lastName;
  dynamic username;
  String? userReference;
  String? profilePictureUrl;
  bool? isConnected;
  String? conversationId;
  String? lastMessagePreview;
  String? lastMessageSenderId;
  String? lastMessageStatus;
  String? lastMessageAt;
  String? lastMessageReadAt;
  bool? lastMessageIsRead;
  bool? isOnline;
  String? lastSeenAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['displayName'] = displayName;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['userReference'] = userReference;
    map['profilePictureUrl'] = profilePictureUrl;
    map['isConnected'] = isConnected;
    map['conversationId'] = conversationId;
    map['lastMessagePreview'] = lastMessagePreview;
    map['lastMessageSenderId'] = lastMessageSenderId;
    map['lastMessageStatus'] = lastMessageStatus;
    map['lastMessageAt'] = lastMessageAt;
    map['lastMessageReadAt'] = lastMessageReadAt;
    map['lastMessageIsRead'] = lastMessageIsRead;
    map['isOnline'] = isOnline;
    map['lastSeenAt'] = lastSeenAt;
    return map;
  }

}