class EmailAvailAbilityResponse {
  EmailAvailAbilityResponse({
      this.code, 
      this.message, 
      this.response, 
      this.traceId,
  });

  EmailAvailAbilityResponse.fromJson(dynamic json) {
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

class Response {
  Response({this.isAvailable,});

  Response.fromJson(dynamic json) {
    isAvailable = json['isAvailable'];
  }
  bool? isAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isAvailable'] = isAvailable;
    return map;
  }

}