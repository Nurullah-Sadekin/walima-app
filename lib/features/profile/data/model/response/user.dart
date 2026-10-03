part of 'get_complete_profile_response.dart';

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.userReference,
    this.status,
    this.isVerified,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    userReference = json['userReference'];
    status = json['status'];
    isVerified = json['isVerified'];
  }
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? userReference;
  String? status;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['userReference'] = userReference;
    map['status'] = status;
    map['isVerified'] = isVerified;
    return map;
  }
}
