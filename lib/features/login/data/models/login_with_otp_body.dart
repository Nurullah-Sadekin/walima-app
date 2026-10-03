
class LoginWithOtpBody {
  LoginWithOtpBody({
      this.identifier,});

  LoginWithOtpBody.fromJson(dynamic json) {
    identifier = json['identifier'];
  }
  String? identifier;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = identifier;
    return map;
  }

}