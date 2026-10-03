part of 'get_complete_profile_response.dart';

class Lifestyle {
  Lifestyle({
    this.id,
    this.profileId,
    this.dietType,
    this.foodHabits,
    this.drinkingHabits,
    this.smokingHabits,
    this.exerciseHabits,
    this.travelFrequency,
    this.socialMediaUsage,
    this.lifestyleDescription,
    this.weekendActivities,
    this.fashionStyle,
    this.createdAt,
    this.updatedAt,
  });

  Lifestyle.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    dietType = json['dietType'];
    foodHabits = json['foodHabits'];
    drinkingHabits = json['drinkingHabits'];
    smokingHabits = json['smokingHabits'];
    exerciseHabits = json['exerciseHabits'];
    travelFrequency = json['travelFrequency'];
    socialMediaUsage = json['socialMediaUsage'];
    lifestyleDescription = json['lifestyleDescription'];
    weekendActivities = json['weekendActivities'];
    fashionStyle = json['fashionStyle'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? profileId;
  String? dietType;
  dynamic foodHabits;
  dynamic drinkingHabits;
  dynamic smokingHabits;
  dynamic exerciseHabits;
  dynamic travelFrequency;
  dynamic socialMediaUsage;
  dynamic lifestyleDescription;
  dynamic weekendActivities;
  dynamic fashionStyle;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['dietType'] = dietType;
    map['foodHabits'] = foodHabits;
    map['drinkingHabits'] = drinkingHabits;
    map['smokingHabits'] = smokingHabits;
    map['exerciseHabits'] = exerciseHabits;
    map['travelFrequency'] = travelFrequency;
    map['socialMediaUsage'] = socialMediaUsage;
    map['lifestyleDescription'] = lifestyleDescription;
    map['weekendActivities'] = weekendActivities;
    map['fashionStyle'] = fashionStyle;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

