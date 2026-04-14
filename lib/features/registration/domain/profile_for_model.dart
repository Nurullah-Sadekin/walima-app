// ProfileFor Model Class
import 'package:flutter_boilerplate/core/constants/app_image.dart';

class ProfileForModel {
  ProfileForModel({
    required this.name,
    required this.emoji,
    this.isSelected = false
  });

  final String name;
  final String emoji;
  bool isSelected;

  // Optional: Add a copyWith method for easy updating
  ProfileForModel copyWith({
    String? name,
    String? emoji,
    bool? isSelected,
  }) {
    return ProfileForModel(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class GenderProfileForModel {
  GenderProfileForModel({
    required this.name,
    required this.emoji,
    this.isSelected = false
  });

  final String name;
  final String emoji;
  bool isSelected;

  // Optional: Add a copyWith method for easy updating
  GenderProfileForModel copyWith({
    String? name,
    String? emoji,
    bool? isSelected,
  }) {
    return GenderProfileForModel(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

// Your ProfileFor List
List<ProfileForModel> profileForListInserted = [
  ProfileForModel(name: 'Myself', emoji: AppImages.meIcon),
  ProfileForModel(name: 'My Son', emoji: AppImages.mySonIcon),
  ProfileForModel(name: 'My Daughter', emoji: AppImages.myDaughterIcon),
  ProfileForModel(name: 'My Brother', emoji: AppImages.maleIcon),
  ProfileForModel(name: 'My Sister', emoji: AppImages.mySisterIcon),
  ProfileForModel(name: 'My Friend', emoji: AppImages.myFriendIcon),
];

// Your ProfileFor List
List<GenderProfileForModel> genderForListInserted = [
  GenderProfileForModel(name: 'Male', emoji: AppImages.maleIcon),
  GenderProfileForModel(name: 'Female', emoji: AppImages.femaleIcon),
];