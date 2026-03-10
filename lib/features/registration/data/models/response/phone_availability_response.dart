import 'dart:convert';
PhoneAvailabilityResponse phoneAvailabilityResponseFromJson(String str) => PhoneAvailabilityResponse.fromJson(json.decode(str));
String phoneAvailabilityResponseToJson(PhoneAvailabilityResponse data) => json.encode(data.toJson());
class PhoneAvailabilityResponse {
  PhoneAvailabilityResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  PhoneAvailabilityResponse.fromJson(dynamic json) {
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
      this.isAvailable, 
      this.user,});

  Response.fromJson(dynamic json) {
    isAvailable = json['isAvailable'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? isAvailable;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isAvailable'] = isAvailable;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.phoneNumber, 
      this.userReference,});

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    userReference = json['userReference'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? userReference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['phoneNumber'] = phoneNumber;
    map['userReference'] = userReference;
    return map;
  }

}