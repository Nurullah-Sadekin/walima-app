
class OtVerifyBody {
  OtVerifyBody({
      this.identifier, 
      this.otpCode, 
      this.purpose,});

  OtVerifyBody.fromJson(dynamic json) {
    identifier = json['identifier'];
    otpCode = json['otpCode'];
    purpose = json['purpose'];
  }
  String? identifier;
  String? otpCode;
  String? purpose;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = identifier;
    map['otpCode'] = otpCode;
    map['purpose'] = purpose;
    return map;
  }

}