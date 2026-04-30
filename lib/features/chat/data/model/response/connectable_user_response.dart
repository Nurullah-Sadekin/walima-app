import 'conversation_list.dart';

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
}

class Response {
  Response({
      this.users, 
      this.total, 
      this.onlineCount,
  });

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
}
class Users {
  Users({
      this.id, 
      this.displayName, 
      this.firstName, 
      this.lastName,
      this.gender,
      this.username, 
      this.userReference, 
      this.profilePhoto,
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
    gender = json['gender'];
    username = json['username'];
    userReference = json['userReference'];
    // correctly parse profilePhoto into ProfilePhoto model if present
    profilePhoto = json['profilePhoto'] != null ? ProfilePhoto.fromJson(json['profilePhoto']) : null;
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
  String? gender;
  dynamic username;
  String? userReference;
  ProfilePhoto? profilePhoto;
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
    map['gender'] = gender;
    map['username'] = username;
    map['userReference'] = userReference;
    if (profilePhoto != null) {
      map['profilePhoto'] = profilePhoto?.toJson();
    }
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