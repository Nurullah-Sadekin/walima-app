// ProfileFor Model Class
import 'package:flutter_boilerplate/core/constants/app_image.dart';

class ProfileFor {
  ProfileFor({
    required this.name,
    required this.emoji,
    this.isSelected = false
  });

  final String name;
  final String emoji;
  bool isSelected;

  // Optional: Add a copyWith method for easy updating
  ProfileFor copyWith({
    String? name,
    String? emoji,
    bool? isSelected,
  }) {
    return ProfileFor(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class GenderProfileFor {
  GenderProfileFor({
    required this.name,
    required this.emoji,
    this.isSelected = false
  });

  final String name;
  final String emoji;
  bool isSelected;

  // Optional: Add a copyWith method for easy updating
  GenderProfileFor copyWith({
    String? name,
    String? emoji,
    bool? isSelected,
  }) {
    return GenderProfileFor(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

// Your ProfileFor List
List<ProfileFor> profileForListInserted = [
  ProfileFor(name: 'Myself', emoji: AppImages.meIcon),
  ProfileFor(name: 'My Son', emoji: AppImages.mySonIcon),
  ProfileFor(name: 'My Daughter', emoji: AppImages.myDaughterIcon),
  ProfileFor(name: 'My Brother', emoji: AppImages.maleIcon),
  ProfileFor(name: 'My Sister', emoji: AppImages.mySisterIcon),
  ProfileFor(name: 'My Friend', emoji: AppImages.myFriendIcon),
];

// Your ProfileFor List
List<ProfileFor> genderForListInserted = [
  ProfileFor(name: 'Male', emoji: AppImages.maleIcon),
  ProfileFor(name: 'Female', emoji: AppImages.femaleIcon),
];