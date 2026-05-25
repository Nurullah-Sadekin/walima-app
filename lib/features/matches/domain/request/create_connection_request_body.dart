import 'dart:convert';

CreateConnectionRequestBody createConnectionRequestBodyFromJson(String str) =>
    CreateConnectionRequestBody.fromJson(json.decode(str));
String createConnectionRequestBodyToJson(CreateConnectionRequestBody data) =>
    json.encode(data.toJson());

class CreateConnectionRequestBody {
  CreateConnectionRequestBody({
    this.receiverId,
    this.requestType,
    this.message,
    this.markAsDefaultConnectionMessage,
    this.connectMessageTemplateId,
    this.expiresAt,
    this.isPriority,
  });

  CreateConnectionRequestBody.fromJson(dynamic json) {
    receiverId = json['receiverId'];
    requestType = json['requestType'];
    message = json['message'];
    markAsDefaultConnectionMessage = json['markAsDefaultConnectionMessage'];
    connectMessageTemplateId = json['connectMessageTemplateId'];
    expiresAt = json['expiresAt'];
    isPriority = json['isPriority'];
  }
  String? receiverId;
  String? requestType;
  String? message;
  bool? markAsDefaultConnectionMessage;
  String? connectMessageTemplateId;
  String? expiresAt;
  bool? isPriority;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['receiverId'] = receiverId;
    map['requestType'] = requestType;
    map['message'] = message;
    map['markAsDefaultConnectionMessage'] = markAsDefaultConnectionMessage;
    if (connectMessageTemplateId?.trim().isNotEmpty ?? false) {
      map['connectMessageTemplateId'] = connectMessageTemplateId;
    }
    map['expiresAt'] = expiresAt;
    map['isPriority'] = isPriority;
    return map;
  }
}
