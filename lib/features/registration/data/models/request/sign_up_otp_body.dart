import 'dart:convert';
SignUpOtpBody signUpOtpBodyFromJson(String str) => SignUpOtpBody.fromJson(json.decode(str));
String signUpOtpBodyToJson(SignUpOtpBody data) => json.encode(data.toJson());
class SignUpOtpBody {
  SignUpOtpBody({
      this.identifier, 
      this.registrationSource,});

  SignUpOtpBody.fromJson(dynamic json) {
    identifier = json['identifier'];
    registrationSource = json['registrationSource'];
  }
  String? identifier;
  String? registrationSource;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = identifier;
    map['registrationSource'] = registrationSource;
    return map;
  }

}