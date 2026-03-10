
class SetPasswordBody {
  SetPasswordBody({
      this.identifier, 
      this.otpCode, 
      this.newPassword, 
      this.confirmPassword,});

  SetPasswordBody.fromJson(dynamic json) {
    identifier = json['identifier'];
    otpCode = json['otpCode'];
    newPassword = json['newPassword'];
    confirmPassword = json['confirmPassword'];
  }
  String? identifier;
  String? otpCode;
  String? newPassword;
  String? confirmPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = identifier;
    map['otpCode'] = otpCode;
    map['newPassword'] = newPassword;
    map['confirmPassword'] = confirmPassword;
    return map;
  }
}