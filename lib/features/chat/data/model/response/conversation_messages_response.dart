class ConversationMessagesResponse {
  ConversationMessagesResponse({
    this.connection,
    this.otherParticipant,
    this.data,
    this.nextCursor,
    this.hasMore,
  });

  ConversationMessagesResponse.fromJson(dynamic json) {
    if (json == null) return;
    connection = json['connection'] != null ? Connection.fromJson(json['connection']) : null;
    otherParticipant = json['otherParticipant'] != null ? OtherParticipant.fromJson(json['otherParticipant']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Message.fromJson(v));
      });
    } else {
      data = [];
    }
    nextCursor = json['nextCursor']?.toString();
    hasMore = json['hasMore'] ?? false;
  }

  Connection? connection;
  OtherParticipant? otherParticipant;
  List<Message>? data;
  String? nextCursor;
  bool? hasMore;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (connection != null) map['connection'] = connection!.toJson();
    if (otherParticipant != null) map['otherParticipant'] = otherParticipant!.toJson();
    if (data != null) map['data'] = data!.map((v) => v.toJson()).toList();
    map['nextCursor'] = nextCursor;
    map['hasMore'] = hasMore;
    return map;
  }
}

class Connection {
  Connection({
    this.conversationId,
    this.isOnline,
  });

  Connection.fromJson(dynamic json) {
    conversationId = json['conversationId'];
    isOnline = json['isOnline'];
  }

  String? conversationId;
  bool? isOnline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conversationId'] = conversationId;
    map['isOnline'] = isOnline;
    return map;
  }
}

class OtherParticipant {
  OtherParticipant({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.userReference,
    this.profilePhoto,
  });

  OtherParticipant.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    userReference = json['userReference'];
    profilePhoto = json['profilePhoto'] != null ? ProfilePhoto.fromJson(json['profilePhoto']) : null;
  }

  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? userReference;
  ProfilePhoto? profilePhoto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['userReference'] = userReference;
    if (profilePhoto != null) map['profilePhoto'] = profilePhoto!.toJson();
    return map;
  }
}

class Message {
  Message({
    this.id,
    this.conversationId,
    this.senderId,
    this.receiverId,
    this.content,
    this.messageType,
    this.status,
    this.mediaUrl,
    this.fileName,
    this.fileSize,
    this.isEdited,
    this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.metadata,
    this.sender,
    this.receiver,
    this.createdAt,
    this.updatedAt,
  });

  Message.fromJson(dynamic json) {
    id = json['id'];
    conversationId = json['conversationId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    content = json['content'];
    messageType = json['messageType'];
    status = json['status'];
    mediaUrl = json['mediaUrl'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    isEdited = json['isEdited'];
    sentAt = json['sentAt'];
    deliveredAt = json['deliveredAt'];
    readAt = json['readAt'];
    metadata = json['metadata'];
    sender = json['sender'] != null ? ParticipantLite.fromJson(json['sender']) : null;
    receiver = json['receiver'] != null ? ParticipantLite.fromJson(json['receiver']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  String? id;
  String? conversationId;
  String? senderId;
  String? receiverId;
  String? content;
  String? messageType;
  String? status;
  String? mediaUrl;
  String? fileName;
  int? fileSize;
  bool? isEdited;
  String? sentAt;
  String? deliveredAt;
  String? readAt;
  dynamic metadata;
  ParticipantLite? sender;
  ParticipantLite? receiver;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['conversationId'] = conversationId;
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['content'] = content;
    map['messageType'] = messageType;
    map['status'] = status;
    map['mediaUrl'] = mediaUrl;
    map['fileName'] = fileName;
    map['fileSize'] = fileSize;
    map['isEdited'] = isEdited;
    map['sentAt'] = sentAt;
    map['deliveredAt'] = deliveredAt;
    map['readAt'] = readAt;
    map['metadata'] = metadata;
    if (sender != null) map['sender'] = sender!.toJson();
    if (receiver != null) map['receiver'] = receiver!.toJson();
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class ParticipantLite {
  ParticipantLite({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.userReference,
    this.isOnline,
    this.lastSeenAt,
    this.profilePhoto,
  });

  ParticipantLite.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    userReference = json['userReference'];
    isOnline = json['isOnline'];
    lastSeenAt = json['lastSeenAt'];
    profilePhoto = json['profilePhoto'] != null ? ProfilePhoto.fromJson(json['profilePhoto']) : null;
  }

  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? userReference;
  bool? isOnline;
  String? lastSeenAt;
  ProfilePhoto? profilePhoto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['userReference'] = userReference;
    map['isOnline'] = isOnline;
    map['lastSeenAt'] = lastSeenAt;
    if (profilePhoto != null) map['profilePhoto'] = profilePhoto!.toJson();
    return map;
  }
}

class ProfilePhoto {
  ProfilePhoto({this.url, this.visibilityStatus, this.isVerified});
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
