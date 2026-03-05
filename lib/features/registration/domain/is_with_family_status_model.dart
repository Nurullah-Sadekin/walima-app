

class IsWithFamilyModel {
  IsWithFamilyModel({
    required this.name,
    this.isSelected = false
  });

  final String name;
  bool isSelected;

  // Optional: Add a copyWith method for easy updating
  IsWithFamilyModel copyWith({
    String? name,
    bool? isSelected,
  }) {
    return IsWithFamilyModel(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<IsWithFamilyModel> isWithFamilyDataListInserted = [
  IsWithFamilyModel(name: 'Yes'),
  IsWithFamilyModel(name: 'No',),
];

List<IsWithFamilyModel> incomePeriodDataListInserted = [
  IsWithFamilyModel(name: 'Yearly'),
  IsWithFamilyModel(name: 'Monthly',),
];