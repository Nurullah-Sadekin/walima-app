
class DietModel {
  DietModel({
    required this.name,
    this.isSelected = false
  });

  final String name;
  bool isSelected;

  // Optional: Add a copyWith method for easy updating
  DietModel copyWith({
    String? name,
    bool? isSelected,
  }) {
    return DietModel(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<DietModel> dietDataListInserted = [
  DietModel(name: 'Healthy'),
  DietModel(name: 'Modern Balanced Diet'),
  DietModel(name: 'Vegetarian'),
  DietModel(name: 'Vegan'),
  DietModel(name: 'Junk Food Lover'),
  DietModel(name: 'Low Carb'),
  DietModel(name: 'Low Fat'),
  DietModel(name: 'Low Sodium'),
  DietModel(name: 'Low Cholesterol'),
  DietModel(name: 'Low Sugar'),
  DietModel(name: 'Low Salt'),
  DietModel(name: 'No Preferences'),
];