import 'dart:convert';
LoginBody loginBodyFromJson(String str) => LoginBody.fromJson(json.decode(str));
String loginBodyToJson(LoginBody data) => json.encode(data.toJson());
class LoginBody {
  LoginBody({
      this.identifier, 
      this.password,});

  LoginBody.fromJson(dynamic json) {
    identifier = json['identifier'];
    password = json['password'];
  }
  String? identifier;
  String? password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = identifier;
    map['password'] = password;
    return map;
  }

}