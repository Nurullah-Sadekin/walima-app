import 'dart:convert';
LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
class LoginResponse {
  LoginResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,});

  LoginResponse.fromJson(dynamic json) {
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
      this.email, 
      this.userReference, 
      this.firstName, 
      this.lastName, 
      this.gender, 
      this.profilePicture, 
      this.phoneNumber, 
      this.isVerified, 
      this.isEmailVerified, 
      this.isPhoneVerified, 
      this.hasPassword, 
      this.requirePasswordChange, 
      this.roles, 
      this.permissions, 
      this.verificationType, 
      this.userDataAvailability,});

  User.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    userReference = json['userReference'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    profilePicture = json['profilePicture'];
    phoneNumber = json['phoneNumber'];
    isVerified = json['isVerified'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    hasPassword = json['hasPassword'];
    requirePasswordChange = json['requirePasswordChange'];
    if (json['roles'] != null) {
      roles = [];
      //todo check in the Future
  /*    json['roles'].forEach((v) {
        roles?.add(Dynamic.fromJson(v));
      });*/
    }
    if (json['permissions'] != null) {
      permissions = [];
      //todo check in the Future
      // json['permissions'].forEach((v) {
      //   permissions?.add(Dynamic.fromJson(v));
      // });
    }
    verificationType = json['verificationType'];
    userDataAvailability = json['userDataAvailability'] != null ? UserDataAvailability.fromJson(json['userDataAvailability']) : null;
  }
  String? id;
  String? email;
  String? userReference;
  String? firstName;
  String? lastName;
  String? gender;
  dynamic profilePicture;
  dynamic phoneNumber;
  bool? isVerified;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  bool? hasPassword;
  bool? requirePasswordChange;
  List<dynamic>? roles;
  List<dynamic>? permissions;
  String? verificationType;
  UserDataAvailability? userDataAvailability;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['userReference'] = userReference;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    map['profilePicture'] = profilePicture;
    map['phoneNumber'] = phoneNumber;
    map['isVerified'] = isVerified;
    map['isEmailVerified'] = isEmailVerified;
    map['isPhoneVerified'] = isPhoneVerified;
    map['hasPassword'] = hasPassword;
    map['requirePasswordChange'] = requirePasswordChange;
    if (roles != null) {
      map['roles'] = roles?.map((v) => v.toJson()).toList();
    }
    if (permissions != null) {
      map['permissions'] = permissions?.map((v) => v.toJson()).toList();
    }
    map['verificationType'] = verificationType;
    if (userDataAvailability != null) {
      map['userDataAvailability'] = userDataAvailability?.toJson();
    }
    return map;
  }

}

UserDataAvailability userDataAvailabilityFromJson(String str) => UserDataAvailability.fromJson(json.decode(str));
String userDataAvailabilityToJson(UserDataAvailability data) => json.encode(data.toJson());
class UserDataAvailability {
  UserDataAvailability({
      this.mandatory, 
      this.optional,});

  UserDataAvailability.fromJson(dynamic json) {
    mandatory = json['mandatory'] != null ? Mandatory.fromJson(json['mandatory']) : null;
    optional = json['optional'] != null ? Optional.fromJson(json['optional']) : null;
  }
  Mandatory? mandatory;
  Optional? optional;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (mandatory != null) {
      map['mandatory'] = mandatory?.toJson();
    }
    if (optional != null) {
      map['optional'] = optional?.toJson();
    }
    return map;
  }

}

Optional optionalFromJson(String str) => Optional.fromJson(json.decode(str));
String optionalToJson(Optional data) => json.encode(data.toJson());
class Optional {
  Optional({
      this.displayName, 
      this.nickName, 
      this.bio, 
      this.profilePicture, 
      this.motherTongue, 
      this.languages, 
      this.religionName, 
      this.countryCode, 
      this.isVerified, 
      this.appearance, 
      this.locations, 
      this.education, 
      this.profession, 
      this.family, 
      this.religion, 
      this.lifestyle, 
      this.preferences, 
      this.contacts, 
      this.photos, 
      this.interests,});

  Optional.fromJson(dynamic json) {
    displayName = json['displayName'];
    nickName = json['nickName'];
    bio = json['bio'];
    profilePicture = json['profilePicture'];
    motherTongue = json['motherTongue'];
    languages = json['languages'];
    religionName = json['religionName'];
    countryCode = json['countryCode'];
    isVerified = json['isVerified'];
    appearance = json['appearance'];
    locations = json['locations'];
    education = json['education'];
    profession = json['profession'];
    family = json['family'];
    religion = json['religion'];
    lifestyle = json['lifestyle'];
    preferences = json['preferences'];
    contacts = json['contacts'];
    photos = json['photos'];
    interests = json['interests'];
  }
  bool? displayName;
  bool? nickName;
  bool? bio;
  bool? profilePicture;
  bool? motherTongue;
  bool? languages;
  bool? religionName;
  bool? countryCode;
  bool? isVerified;
  bool? appearance;
  bool? locations;
  bool? education;
  bool? profession;
  bool? family;
  bool? religion;
  bool? lifestyle;
  bool? preferences;
  bool? contacts;
  bool? photos;
  bool? interests;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['displayName'] = displayName;
    map['nickName'] = nickName;
    map['bio'] = bio;
    map['profilePicture'] = profilePicture;
    map['motherTongue'] = motherTongue;
    map['languages'] = languages;
    map['religionName'] = religionName;
    map['countryCode'] = countryCode;
    map['isVerified'] = isVerified;
    map['appearance'] = appearance;
    map['locations'] = locations;
    map['education'] = education;
    map['profession'] = profession;
    map['family'] = family;
    map['religion'] = religion;
    map['lifestyle'] = lifestyle;
    map['preferences'] = preferences;
    map['contacts'] = contacts;
    map['photos'] = photos;
    map['interests'] = interests;
    return map;
  }

}

Mandatory mandatoryFromJson(String str) => Mandatory.fromJson(json.decode(str));
String mandatoryToJson(Mandatory data) => json.encode(data.toJson());
class Mandatory {
  Mandatory({
      this.email, 
      this.phoneNumber, 
      this.username, 
      this.profileManagedBy, 
      this.firstName, 
      this.lastName, 
      this.dateOfBirth, 
      this.gender, 
      this.maritalStatus, 
      this.religionName,});

  Mandatory.fromJson(dynamic json) {
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    username = json['username'];
    profileManagedBy = json['profileManagedBy'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    maritalStatus = json['maritalStatus'];
    religionName = json['religionName'];
  }
  bool? email;
  bool? phoneNumber;
  bool? username;
  bool? profileManagedBy;
  bool? firstName;
  bool? lastName;
  bool? dateOfBirth;
  bool? gender;
  bool? maritalStatus;
  bool? religionName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['username'] = username;
    map['profileManagedBy'] = profileManagedBy;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['dateOfBirth'] = dateOfBirth;
    map['gender'] = gender;
    map['maritalStatus'] = maritalStatus;
    map['religionName'] = religionName;
    return map;
  }

}