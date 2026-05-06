import 'package:walima_llc/features/profile/data/model/response/contacts.dart';
import 'package:walima_llc/features/profile/data/model/response/interest_response.dart';

part 'appearance.dart';
part 'complete_profile.dart';
part 'educations.dart';
part 'family.dart';
part 'lifestyle.dart';
part 'locations.dart';
part 'preferences.dart';
part 'profession.dart';
part 'profile.dart';
part 'profile_completion.dart';
part 'profile_pictures.dart';
part 'religion.dart';
part 'statistics.dart';
part 'user.dart';

class GetCompleteProfileResponse {
  GetCompleteProfileResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  GetCompleteProfileResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    response = json['response'] != null
        ? CompleteProfile.fromJson(json['response'])
        : null;
    traceId = json['traceId'];
  }

  String? code;
  String? message;
  CompleteProfile? response;
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
