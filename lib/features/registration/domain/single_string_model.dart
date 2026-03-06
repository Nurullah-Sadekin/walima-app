
class SingleStringModel {
  SingleStringModel({
    required this.name,
    this.isSelected = false
  });

  final String name;
  bool isSelected;

  // Optional: Add a copyWith method for easy updating
  SingleStringModel copyWith({
    String? name,
    bool? isSelected,
  }) {
    return SingleStringModel(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<SingleStringModel> dietDataListInserted = [
  SingleStringModel(name: 'Healthy'),
  SingleStringModel(name: 'Modern Balanced Diet'),
  SingleStringModel(name: 'Vegetarian'),
  SingleStringModel(name: 'Vegan'),
  SingleStringModel(name: 'Junk Food Lover'),
  SingleStringModel(name: 'Low Carb'),
  SingleStringModel(name: 'Low Fat'),
  SingleStringModel(name: 'Low Sodium'),
  SingleStringModel(name: 'Low Cholesterol'),
  SingleStringModel(name: 'Low Sugar'),
  SingleStringModel(name: 'Low Salt'),
  SingleStringModel(name: 'No Preferences'),
  SingleStringModel(name: 'Low Fat'),
  SingleStringModel(name: 'Low Sodium'),
  SingleStringModel(name: 'Low Cholesterol'),
  SingleStringModel(name: 'Low Sugar'),
  SingleStringModel(name: 'Low Salt'),
  SingleStringModel(name: 'No Preferences'),
];

List<SingleStringModel> incomeRangeListInserted = [
  SingleStringModel(name: 'Less than 10k'),
  SingleStringModel(name: '10k - 20k'),
  SingleStringModel(name: '20k - 50k'),
  SingleStringModel(name: '50k - 100k'),
  SingleStringModel(name: 'More than 100k'),
];

List<SingleStringModel> yourWorkListInserted = [
  SingleStringModel(name: 'Full-time'),
  SingleStringModel(name: 'Part-time'),
  SingleStringModel(name: 'Self-employed'),
  SingleStringModel(name: 'Student'),
  SingleStringModel(name: 'Unemployed'),
];

List<SingleStringModel> youWorkAsListInserted = [
  SingleStringModel(name: 'Engineer'),
  SingleStringModel(name: 'Doctor'),
  SingleStringModel(name: 'Teacher'),
  SingleStringModel(name: 'Business'),
  SingleStringModel(name: 'Other'),
];

List<SingleStringModel> creativeItemListDataInserted = [
  SingleStringModel(name: 'Writing'),
  SingleStringModel(name: 'Cooking'),
  SingleStringModel(name: 'Singing'),
  SingleStringModel(name: 'Photography'),
  SingleStringModel(name: 'Playing instruments'),
  SingleStringModel(name: 'Painting'),
  SingleStringModel(name: 'DIY crafts'),
  SingleStringModel(name: 'Dancing'),
  SingleStringModel(name: 'Acting'),
  SingleStringModel(name: 'Poetry'),
  SingleStringModel(name: 'Gardening'),
  SingleStringModel(name: 'Blogging'),
  SingleStringModel(name: 'Content creation'),
  SingleStringModel(name: 'Designing'),
  SingleStringModel(name: 'Doodling'),
];

List<SingleStringModel> funItemListDataInserted = [
  SingleStringModel(name: 'Writing'),
  SingleStringModel(name: 'Cooking'),
  SingleStringModel(name: 'Singing'),
  SingleStringModel(name: 'Photography'),
  SingleStringModel(name: 'Playing instruments'),
  SingleStringModel(name: 'Painting'),
  SingleStringModel(name: 'DIY crafts'),
  SingleStringModel(name: 'Dancing'),
  SingleStringModel(name: 'Acting'),
  SingleStringModel(name: 'Poetry'),
  SingleStringModel(name: 'Gardening'),
  SingleStringModel(name: 'Blogging'),
  SingleStringModel(name: 'Content creation'),
  SingleStringModel(name: 'Designing'),
  SingleStringModel(name: 'Doodling'),
];

List<SingleStringModel> fitnessItemListDataInserted = [
  SingleStringModel(name: 'Writing'),
  SingleStringModel(name: 'Cooking'),
  SingleStringModel(name: 'Singing'),
  SingleStringModel(name: 'Photography'),
  SingleStringModel(name: 'Playing instruments'),
  SingleStringModel(name: 'Painting'),
  SingleStringModel(name: 'DIY crafts'),
  SingleStringModel(name: 'Dancing'),
  SingleStringModel(name: 'Acting'),
  SingleStringModel(name: 'Poetry'),
  SingleStringModel(name: 'Gardening'),
  SingleStringModel(name: 'Blogging'),
  SingleStringModel(name: 'Content creation'),
  SingleStringModel(name: 'Designing'),
  SingleStringModel(name: 'Doodling'),
];

List<SingleStringModel> otherInterestsItemListDataInserted = [
  SingleStringModel(name: 'Writing'),
  SingleStringModel(name: 'Cooking'),
  SingleStringModel(name: 'Singing'),
  SingleStringModel(name: 'Photography'),
  SingleStringModel(name: 'Playing instruments'),
  SingleStringModel(name: 'Painting'),
  SingleStringModel(name: 'DIY crafts'),
  SingleStringModel(name: 'Dancing'),
  SingleStringModel(name: 'Acting'),
  SingleStringModel(name: 'Poetry'),
  SingleStringModel(name: 'Gardening'),
  SingleStringModel(name: 'Blogging'),
  SingleStringModel(name: 'Content creation'),
  SingleStringModel(name: 'Designing'),
  SingleStringModel(name: 'Doodling'),
];