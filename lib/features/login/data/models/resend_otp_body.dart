
class ResendOtpBody {
  ResendOtpBody({
      this.identifier, 
      this.purpose,});

  ResendOtpBody.fromJson(dynamic json) {
    identifier = json['identifier'];
    purpose = json['purpose'];
  }
  String? identifier;
  String? purpose;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = identifier;
    map['purpose'] = purpose;
    return map;
  }
}