import 'dart:convert';

InitiatePaymentResponse initiatePaymentResponseFromJson(String str) =>
    InitiatePaymentResponse.fromJson(json.decode(str));
String initiatePaymentResponseToJson(InitiatePaymentResponse data) =>
    json.encode(data.toJson());

class InitiatePaymentResponse {
  InitiatePaymentResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  InitiatePaymentResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? InitiatePaymentResponseContainer.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  InitiatePaymentResponseContainer? response;
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

class InitiatePaymentResponseContainer {
  InitiatePaymentResponseContainer({
    this.data,
  });

  InitiatePaymentResponseContainer.fromJson(dynamic json) {
    data = json['data'] != null
        ? InitiatePaymentData.fromJson(json['data'])
        : null;
  }

  InitiatePaymentData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class InitiatePaymentData {
  InitiatePaymentData({
    this.transactionId,
    this.redirectUrl,
    this.status,
    this.rawResponse,
  });

  InitiatePaymentData.fromJson(dynamic json) {
    transactionId = json['transactionId'];
    redirectUrl = json['redirectUrl'];
    status = json['status'];
    rawResponse = json['rawResponse'] != null
        ? InitiatePaymentRawResponse.fromJson(json['rawResponse'])
        : null;
  }

  String? transactionId;
  String? redirectUrl;
  String? status;
  InitiatePaymentRawResponse? rawResponse;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transactionId'] = transactionId;
    map['redirectUrl'] = redirectUrl;
    map['status'] = status;
    if (rawResponse != null) {
      map['rawResponse'] = rawResponse?.toJson();
    }
    return map;
  }
}

class InitiatePaymentRawResponse {
  InitiatePaymentRawResponse({
    this.sessionKey,
    this.transactionId,
  });

  InitiatePaymentRawResponse.fromJson(dynamic json) {
    sessionKey = json['sessionKey'];
    transactionId = json['transactionId'];
  }

  String? sessionKey;
  String? transactionId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionKey'] = sessionKey;
    map['transactionId'] = transactionId;
    return map;
  }
}
