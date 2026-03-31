import 'dart:convert';
LogoutResponse logoutResponseFromJson(String str) => LogoutResponse.fromJson(json.decode(str));
String logoutResponseToJson(LogoutResponse data) => json.encode(data.toJson());
class LogoutResponse {
  LogoutResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  LogoutResponse.fromJson(dynamic json) {
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
      this.message,});

  Response.fromJson(dynamic json) {
    message = json['message'];
  }
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }

}