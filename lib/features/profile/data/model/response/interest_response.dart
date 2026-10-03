class Interest {
  Interest({
    this.id,
    this.profileId,
    this.creativePursuits,
    this.outdoorActivities,
    this.fitnessAndSports,
    this.mediaAndLearning,
    this.foodAndCuisine,
    this.travelAndLeisure,
    this.createdAt,
    this.updatedAt,
  });

  Interest.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    creativePursuits = json['creativePursuits'] != null
        ? json['creativePursuits'].cast<String>()
        : [];
    outdoorActivities = json['outdoorActivities'] != null
        ? json['outdoorActivities'].cast<String>()
        : [];
    fitnessAndSports = json['fitnessAndSports'] != null
        ? json['fitnessAndSports'].cast<String>()
        : [];
    mediaAndLearning = json['mediaAndLearning'] != null
        ? json['mediaAndLearning'].cast<String>()
        : [];
    foodAndCuisine = json['foodAndCuisine'] != null
        ? json['foodAndCuisine'].cast<String>()
        : [];
    travelAndLeisure = json['travelAndLeisure'] != null
        ? json['travelAndLeisure'].cast<String>()
        : [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  List<String>? creativePursuits;
  List<String>? outdoorActivities;
  List<String>? fitnessAndSports;
  List<String>? mediaAndLearning;
  List<String>? foodAndCuisine;
  List<String>? travelAndLeisure;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['creativePursuits'] = creativePursuits;
    map['outdoorActivities'] = outdoorActivities;
    map['fitnessAndSports'] = fitnessAndSports;
    map['mediaAndLearning'] = mediaAndLearning;
    map['foodAndCuisine'] = foodAndCuisine;
    map['travelAndLeisure'] = travelAndLeisure;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}