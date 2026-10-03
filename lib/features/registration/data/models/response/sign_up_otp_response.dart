import 'dart:convert';

SignUpOtpResponse signUpOtpResponseFromJson(String str) =>
    SignUpOtpResponse.fromJson(json.decode(str));
String signUpOtpResponseToJson(SignUpOtpResponse data) =>
    json.encode(data.toJson());

class SignUpOtpResponse {
  SignUpOtpResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  SignUpOtpResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
    traceId = json['traceId'];
  }
  String? code;
  String? message;
  Response? response;
  String? traceId;

  bool get isAccountExistsError {
    final error = '${code ?? ''} ${message ?? ''}'
        .toLowerCase()
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
    final indicatesMissingAccount = RegExp(
      r'\bno account\b.*\bexist|'
      r'\baccount\b.*\b(?:does|do|did) not exist|'
      r'\baccount\b.*\bnot exist|'
      r"\baccount\b.*\bdoesn't exist",
    ).hasMatch(error);

    return !indicatesMissingAccount &&
        RegExp(r'\baccount\b.*\bexist(?:s|ed|ing)?\b').hasMatch(error);
  }

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

Response responseFromJson(String str) => Response.fromJson(json.decode(str));
String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  Response({
    this.userId,
    this.verificationType,
    this.identifier,
  });

  Response.fromJson(dynamic json) {
    userId = json['userId'];
    verificationType = json['verificationType'];
    identifier = json['identifier'];
  }
  String? userId;
  String? verificationType;
  String? identifier;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['verificationType'] = verificationType;
    map['identifier'] = identifier;
    return map;
  }
}
