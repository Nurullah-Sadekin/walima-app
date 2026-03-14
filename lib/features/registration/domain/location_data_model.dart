class CountryLocationModel {
  CountryLocationModel({
    required this.code2,
    required this.code3,
    required this.name,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.states,
  });

  factory CountryLocationModel.fromJson(Map<String, dynamic> json) {
    final statesJson = json['states'];
    final parsedStates = <CountryStateModel>[];

    if (statesJson is List) {
      for (final state in statesJson) {
        if (state is Map<String, dynamic>) {
          parsedStates.add(CountryStateModel.fromJson(state));
        } else if (state is Map) {
          parsedStates.add(
            CountryStateModel.fromJson(Map<String, dynamic>.from(state)),
          );
        }
      }
    }

    return CountryLocationModel(
      code2: (json['code2'] ?? json['iso2'] ?? '').toString(),
      code3: (json['code3'] ?? json['iso3'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      capital: (json['capital'] ?? '').toString(),
      region: (json['region'] ?? '').toString(),
      subregion: (json['subregion'] ?? '').toString(),
      states: parsedStates,
    );
  }

  final String code2;
  final String code3;
  final String name;
  final String capital;
  final String region;
  final String subregion;
  final List<CountryStateModel> states;

  List<String> cityNames({bool includeCapitalWhenEmpty = true}) {
    final result = <String>[];
    final seen = <String>{};

    void addUnique(String value) {
      final cleaned = value.trim();
      if (cleaned.isEmpty) return;

      final marker = cleaned.toLowerCase();
      if (seen.add(marker)) {
        result.add(cleaned);
      }
    }

    for (final state in states) {
      addUnique(state.name);
    }

    if (result.isEmpty && includeCapitalWhenEmpty) {
      addUnique(capital);
    }

    return result;
  }
}

class CountryStateModel {
  CountryStateModel({
    required this.code,
    required this.name,
    this.subdivision,
  });

  factory CountryStateModel.fromJson(Map<String, dynamic> json) {
    return CountryStateModel(
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      subdivision: json['subdivision']?.toString(),
    );
  }

  final String code;
  final String name;
  final String? subdivision;
}

class ResidencyStatusOptionModel {
  ResidencyStatusOptionModel({
    required this.name,
    required this.value,
  });

  factory ResidencyStatusOptionModel.fromJson(Map<String, dynamic> json) {
    return ResidencyStatusOptionModel(
      name: (json['name'] ?? '').toString(),
      value: (json['value'] ?? '').toString(),
    );
  }

  final String name;
  final String value;
}
