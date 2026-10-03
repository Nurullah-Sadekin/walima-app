
class RegisterBody {
  RegisterBody({
    this.identifier,
    this.password,
    this.confirmPassword,
    this.registrationSource,
  });

  RegisterBody.fromJson(dynamic json) {
    identifier = json['identifier'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    registrationSource = json['registrationSource'];
  }
  
  String? identifier;
  String? password;
  String? confirmPassword;
  String? registrationSource;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = identifier;
    map['password'] = password;
    map['confirmPassword'] = confirmPassword;
    map['registrationSource'] = registrationSource;
    return map;
  }
}
