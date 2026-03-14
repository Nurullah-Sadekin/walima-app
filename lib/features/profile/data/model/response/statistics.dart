part of 'get_complete_profile_response.dart';

class Statistics {
  Statistics({
    this.totalPhotos,
  });

  Statistics.fromJson(dynamic json) {
    totalPhotos = json['totalPhotos'];
  }
  int? totalPhotos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPhotos'] = totalPhotos;
    return map;
  }
}

