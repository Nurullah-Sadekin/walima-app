import 'dart:convert';
OnboardingResponse onboardingResponseFromJson(String str) => OnboardingResponse.fromJson(json.decode(str));
String onboardingResponseToJson(OnboardingResponse data) => json.encode(data.toJson());
class OnboardingResponse {
  OnboardingResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  OnboardingResponse.fromJson(dynamic json) {
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
      this.accessToken, 
      this.refreshToken, 
      this.user,});

  Response.fromJson(dynamic json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? accessToken;
  String? refreshToken;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accessToken'] = accessToken;
    map['refreshToken'] = refreshToken;
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
      this.gender, 
      this.profilePicture, 
      this.email, 
      this.userReference, 
      this.phoneNumber, 
      this.isVerified, 
      this.verificationType, 
      this.requirePasswordChange, 
      this.roles, 
      this.permissions,});

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    profilePicture = json['profilePicture'];
    email = json['email'];
    userReference = json['userReference'];
    phoneNumber = json['phoneNumber'];
    isVerified = json['isVerified'];
    verificationType = json['verificationType'];
    requirePasswordChange = json['requirePasswordChange'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    if (json['permissions'] != null) {
      permissions = [];
      json['permissions'].forEach((v) {
        permissions?.add(Dynamic.fromJson(v));
      });
    }
  }
  String? id;
  dynamic firstName;
  dynamic lastName;
  String? gender;
  String? profilePicture;
  dynamic email;
  String? userReference;
  String? phoneNumber;
  bool? isVerified;
  String? verificationType;
  bool? requirePasswordChange;
  List<String>? roles;
  List<dynamic>? permissions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    map['profilePicture'] = profilePicture;
    map['email'] = email;
    map['userReference'] = userReference;
    map['phoneNumber'] = phoneNumber;
    map['isVerified'] = isVerified;
    map['verificationType'] = verificationType;
    map['requirePasswordChange'] = requirePasswordChange;
    map['roles'] = roles;
    if (permissions != null) {
      map['permissions'] = permissions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}