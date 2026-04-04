enum GlobalStatus {
  initial,
  loading,
  success,
  failure,
}

enum ConnectionRequestType {
  interest,
  connection,
  match,
}
// "requestType": "requestType must be one of the following values: interest, connection, ma
// I/flutter (19418): ║                  tch"

enum RegistrationMaritalStatus {
  openToAll,
  neverMarried,
  married,
  divorced,
  widowed,
  separated,
  awaitingDivorce,
  annulled,
}

extension RegistrationMaritalStatusX on RegistrationMaritalStatus {
  String get apiValue {
    switch (this) {
      case RegistrationMaritalStatus.openToAll:
        return 'open_to_all';
      case RegistrationMaritalStatus.neverMarried:
        return 'never_married';
      case RegistrationMaritalStatus.married:
        return 'married';
      case RegistrationMaritalStatus.divorced:
        return 'divorced';
      case RegistrationMaritalStatus.widowed:
        return 'widowed';
      case RegistrationMaritalStatus.separated:
        return 'separated';
      case RegistrationMaritalStatus.awaitingDivorce:
        return 'awaiting_divorce';
      case RegistrationMaritalStatus.annulled:
        return 'annulled';
    }
  }

  String get label {
    switch (this) {
      case RegistrationMaritalStatus.openToAll:
        return 'Open to All';
      case RegistrationMaritalStatus.neverMarried:
        return 'Never Married';
      case RegistrationMaritalStatus.married:
        return 'Married';
      case RegistrationMaritalStatus.divorced:
        return 'Divorced';
      case RegistrationMaritalStatus.widowed:
        return 'Widowed';
      case RegistrationMaritalStatus.separated:
        return 'Separated';
      case RegistrationMaritalStatus.awaitingDivorce:
        return 'Awaiting Divorce';
      case RegistrationMaritalStatus.annulled:
        return 'Annulled';
    }
  }
}

enum RegistrationDiet {
  vegetarian,
  nonVegetarian,
  halalOnly,
  vegan,
  jainVegetarian,
  occasionallyNonVeg,
}

extension RegistrationDietX on RegistrationDiet {
  String get apiValue {
    switch (this) {
      case RegistrationDiet.vegetarian:
        return 'vegetarian';
      case RegistrationDiet.nonVegetarian:
        return 'non_vegetarian';
      case RegistrationDiet.halalOnly:
        return 'halal_only';
      case RegistrationDiet.vegan:
        return 'vegan';
      case RegistrationDiet.jainVegetarian:
        return 'jain_vegetarian';
      case RegistrationDiet.occasionallyNonVeg:
        return 'occasionally_non_veg';
    }
  }

  String get label {
    switch (this) {
      case RegistrationDiet.vegetarian:
        return 'Vegetarian';
      case RegistrationDiet.nonVegetarian:
        return 'Non-Vegetarian';
      case RegistrationDiet.halalOnly:
        return 'Halal Only';
      case RegistrationDiet.vegan:
        return 'Vegan';
      case RegistrationDiet.jainVegetarian:
        return 'Jain Vegetarian';
      case RegistrationDiet.occasionallyNonVeg:
        return 'Occasionally Non-Veg';
    }
  }
}

enum RegistrationFamilyEconomicCondition {
  eliteClass,
  upperClass,
  middleClass,
  lowerMiddleClass,
}

extension RegistrationFamilyEconomicConditionX
    on RegistrationFamilyEconomicCondition {
  String get apiValue {
    switch (this) {
      case RegistrationFamilyEconomicCondition.eliteClass:
        return 'elite_class';
      case RegistrationFamilyEconomicCondition.upperClass:
        return 'upper_class';
      case RegistrationFamilyEconomicCondition.middleClass:
        return 'middle_class';
      case RegistrationFamilyEconomicCondition.lowerMiddleClass:
        return 'lower_middle_class';
    }
  }

  String get label {
    switch (this) {
      case RegistrationFamilyEconomicCondition.eliteClass:
        return 'Elite Class';
      case RegistrationFamilyEconomicCondition.upperClass:
        return 'Upper Class';
      case RegistrationFamilyEconomicCondition.middleClass:
        return 'Middle Class';
      case RegistrationFamilyEconomicCondition.lowerMiddleClass:
        return 'Lower Middle Class';
    }
  }
}

enum RegistrationProfileManagedBy {
  self,
  parent,
  sibling,
  relative,
  friend,
  other,
}

extension RegistrationProfileManagedByX on RegistrationProfileManagedBy {
  String get apiValue {
    switch (this) {
      case RegistrationProfileManagedBy.self:
        return 'self';
      case RegistrationProfileManagedBy.parent:
        return 'parent';
      case RegistrationProfileManagedBy.sibling:
        return 'sibling';
      case RegistrationProfileManagedBy.relative:
        return 'relative';
      case RegistrationProfileManagedBy.friend:
        return 'friend';
      case RegistrationProfileManagedBy.other:
        return 'other';
    }
  }

  String get label {
    switch (this) {
      case RegistrationProfileManagedBy.self:
        return 'Self';
      case RegistrationProfileManagedBy.parent:
        return 'Parent';
      case RegistrationProfileManagedBy.sibling:
        return 'Sibling';
      case RegistrationProfileManagedBy.relative:
        return 'Relative';
      case RegistrationProfileManagedBy.friend:
        return 'Friend';
      case RegistrationProfileManagedBy.other:
        return 'Other';
    }
  }
}
