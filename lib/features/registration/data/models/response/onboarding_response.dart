class OnboardingResponse {
  OnboardingResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  OnboardingResponse.fromJson(dynamic json) {
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
}

class Response {
  Response({
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  Response.fromJson(dynamic json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? accessToken;
  String? refreshToken;
  User? user;
}

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
    this.permissions,
  });

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
      // json['permissions'].forEach((v) {
      //   permissions?.add(Dynamic.fromJson(v));
      // });
    }
  }
  String? id;
  String? firstName;
  String? lastName;
  String? gender;
  String? profilePicture;
  String? email;
  String? userReference;
  String? phoneNumber;
  bool? isVerified;
  String? verificationType;
  bool? requirePasswordChange;
  List<String>? roles;
  List<dynamic>? permissions;
}
