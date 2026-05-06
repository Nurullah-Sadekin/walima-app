import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:walima_llc/features/registration/domain/religion_option_model.dart';
import 'package:walima_llc/features/registration/domain/repository/religion_data_repository.dart';

class ReligionDataRepositoryImpl implements ReligionDataRepository {
  static const String _assetPath =
      'lib/features/registration/domain/json/religion_name_options.json';

  List<ReligionOptionModel>? _cachedOptions;

  @override
  Future<List<ReligionOptionModel>> getReligionOptions() async {
    if (_cachedOptions != null) {
      return _cachedOptions!;
    }

    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      _cachedOptions = <ReligionOptionModel>[];
      return _cachedOptions!;
    }

    final options = <ReligionOptionModel>[];
    for (final item in decoded) {
      if (item is Map<String, dynamic>) {
        options.add(ReligionOptionModel.fromJson(item));
      } else if (item is Map) {
        options
            .add(ReligionOptionModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    _cachedOptions = options;
    return _cachedOptions!;
  }

  @override
  Future<List<String>> getReligionNames() async {
    final options = await getReligionOptions();
    return options.map((item) => item.name).toList(growable: false);
  }

  @override
  Future<List<String>> getCommunityOptions({
    required String religion,
    bool flattenNested = true,
    bool includeCategoryKeys = false,
  }) async {
    final normalized = religion.trim().toLowerCase();
    if (normalized.isEmpty) {
      return <String>[];
    }

    final options = await getReligionOptions();
    ReligionOptionModel? selected;

    for (final option in options) {
      final byName = option.name.toLowerCase() == normalized;
      final byValue = option.value.toLowerCase() == normalized;
      if (byName || byValue) {
        selected = option;
        break;
      }
    }

    if (selected == null) {
      return <String>[];
    }

    final values = flattenNested
        ? selected.community
            .flattenCommunityLabels(includeCategoryKeys: includeCategoryKeys)
        : selected.community.topLevelLabels();

    return _dedupe(values);
  }

  List<String> _dedupe(List<String> values) {
    final uniqueValues = <String>[];
    final seen = <String>{};

    for (final value in values) {
      final cleaned = value.trim();
      if (cleaned.isEmpty) continue;

      final marker = cleaned.toLowerCase();
      if (seen.add(marker)) {
        uniqueValues.add(cleaned);
      }
    }

    return uniqueValues;
  }
}
