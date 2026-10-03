import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';

class GetPublicMatchesResponse {
  GetPublicMatchesResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
    this.statusCode,
  });

  GetPublicMatchesResponse.fromJson(dynamic json, {this.statusCode}) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? PublicMatchesResult.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  PublicMatchesResult? response;
  String? traceId;
  int? statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['traceId'] = traceId;
    map['statusCode'] = statusCode;
    return map;
  }
}

class PublicMatchesResult {
  PublicMatchesResult({
    this.data,
    this.pagination,
  });

  PublicMatchesResult.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(MatchProfile.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? MatchesPagination.fromJson(json['pagination'])
        : null;
  }

  List<MatchProfile>? data;
  MatchesPagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }
}
