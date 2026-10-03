
class SignUpOtpBody {
  SignUpOtpBody({
      this.identifier, 
      this.registrationSource,
      this.firstName,
      this.lastName,
  });

  SignUpOtpBody.fromJson(dynamic json) {
    identifier = json['identifier'];
    registrationSource = json['registrationSource'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }
  String? identifier;
  String? registrationSource;
  String? firstName;
  String? lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = identifier;
    map['registrationSource'] = registrationSource;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    return map;
  }
}