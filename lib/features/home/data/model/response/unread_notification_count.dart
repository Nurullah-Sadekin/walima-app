import 'dart:convert';
UnreadNotificationCount unreadNotificationCountFromJson(String str) => UnreadNotificationCount.fromJson(json.decode(str));
String unreadNotificationCountToJson(UnreadNotificationCount data) => json.encode(data.toJson());
class UnreadNotificationCount {
  UnreadNotificationCount({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  UnreadNotificationCount.fromJson(dynamic json) {
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
      this.data,});

  Response.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.unreadCount,});

  Data.fromJson(dynamic json) {
    unreadCount = json['unreadCount'];
  }
  num? unreadCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unreadCount'] = unreadCount;
    return map;
  }

}