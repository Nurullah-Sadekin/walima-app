class UpdateInterestsResponse {
  final String? code;
  final String? message;
  final UpdateInterestsResponseBody? response;
  final String? traceId;

  UpdateInterestsResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  factory UpdateInterestsResponse.fromJson(Map<String, dynamic> json) {
    return UpdateInterestsResponse(
      code: json['code'] as String?,
      message: json['message'] as String?,
      response: json['response'] != null
          ? UpdateInterestsResponseBody.fromJson(
              json['response'] as Map<String, dynamic>)
          : null,
      traceId: json['traceId'] as String?,
    );
  }
}

class UpdateInterestsResponseBody {
  final bool? success;
  final UpdateInterestsData? data;

  UpdateInterestsResponseBody({
    this.success,
    this.data,
  });

  factory UpdateInterestsResponseBody.fromJson(Map<String, dynamic> json) {
    return UpdateInterestsResponseBody(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? UpdateInterestsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UpdateInterestsData {
  final String id;
  final String profileId;
  final List<String> creativePursuits;
  final List<String> outdoorActivities;
  final List<String> fitnessAndSports;
  final List<String> mediaAndLearning;
  final List<String> foodAndCuisine;
  final List<String> travelAndLeisure;
  final String? createdAt;
  final String? updatedAt;

  UpdateInterestsData({
    required this.id,
    required this.profileId,
    required this.creativePursuits,
    required this.outdoorActivities,
    required this.fitnessAndSports,
    required this.mediaAndLearning,
    required this.foodAndCuisine,
    required this.travelAndLeisure,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdateInterestsData.fromJson(Map<String, dynamic> json) {
    return UpdateInterestsData(
      id: json['id'] as String? ?? '',
      profileId: json['profileId'] as String? ?? '',
      creativePursuits:
          _parseStringList(json['creativePursuits'] as List<dynamic>?),
      outdoorActivities:
          _parseStringList(json['outdoorActivities'] as List<dynamic>?),
      fitnessAndSports:
          _parseStringList(json['fitnessAndSports'] as List<dynamic>?),
      mediaAndLearning:
          _parseStringList(json['mediaAndLearning'] as List<dynamic>?),
      foodAndCuisine:
          _parseStringList(json['foodAndCuisine'] as List<dynamic>?),
      travelAndLeisure:
          _parseStringList(json['travelAndLeisure'] as List<dynamic>?),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  static List<String> _parseStringList(List<dynamic>? list) {
    if (list == null) return [];
    return list.whereType<String>().toList();
  }
}
