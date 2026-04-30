// ignore_for_file: invalid_use_of_protected_member

part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditSavePrefillUtilsPart
    on _ProfileSectionEditScreenState {
  Map<String, dynamic>? _buildRecordPayload({
    String? id,
    required Map<String, dynamic> fields,
  }) {
    final payload = UpdateProfileSectionRequestBody(fields: fields).toJson();
    if (payload.isEmpty) {
      return null;
    }
    final normalizedId = id?.trim();
    if (normalizedId != null && normalizedId.isNotEmpty) {
      payload['id'] = normalizedId;
    }
    return payload;
  }

  String _resolveLocationType(String? value) {
    final normalized = value?.trim().toLowerCase();
    if (normalized == 'present' || normalized == 'permanent') {
      return normalized!;
    }
    return 'present';
  }

  Future<bool> _updateWithUniversal({
    required Map<String, dynamic> fields,
    required String fallbackMessage,
  }) async {
    final response = await _domainRepository.updateUniversalProfile(
      UpdateProfileSectionRequestBody(fields: fields),
    );

    if (response.isSuccess) {
      return true;
    }

    await _showError(response.message ?? fallbackMessage);
    return false;
  }

  Future<void> _showError(String message) async {
    await DialogUtils.showErrorDialog(
      context: context,
      message: message,
    );
  }

  void _prefillEnum<T extends ApiUiEnum>({
    required TextEditingController controller,
    required String? raw,
    required List<T> values,
    required String fieldKey,
  }) {
    final match = _findEnumByLabelOrValue(values, raw);
    if (match != null) {
      controller.text = match.label;
      _selectedApiValues[fieldKey] = match.apiValue;
    } else {
      controller.text = raw?.trim() ?? '';
      _selectedApiValues.remove(fieldKey);
    }
  }

  void _prefillLookup({
    required TextEditingController controller,
    required String? raw,
    required List<LookupOption> options,
    required String fieldKey,
  }) {
    final match = _findLookupOption(options, raw ?? '');
    if (match != null) {
      controller.text = match.label;
      _selectedApiValues[fieldKey] = match.key;
    } else {
      controller.text = raw?.trim() ?? '';
      _selectedApiValues.remove(fieldKey);
    }
  }

  void _prefillSingleString({
    required TextEditingController controller,
    required String? raw,
    required List<SingleStringModel> options,
    required String fieldKey,
  }) {
    final normalized = raw?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      controller.text = '';
      _selectedApiValues.remove(fieldKey);
      return;
    }
    for (final option in options) {
      final matchesName = option.name.toLowerCase() == normalized;
      final matchesValue = option.value?.toLowerCase() == normalized;
      if (matchesName || matchesValue) {
        controller.text = option.name;
        final apiValue = option.value;
        if (apiValue != null && apiValue.isNotEmpty) {
          _selectedApiValues[fieldKey] = apiValue;
        } else {
          _selectedApiValues.remove(fieldKey);
        }
        return;
      }
    }
    controller.text = raw?.trim() ?? '';
    _selectedApiValues.remove(fieldKey);
  }

  void _toggleOption(List<SingleStringModel> list, int index) {
    setState(() {
      list[index].isSelected = !list[index].isSelected;
    });
  }

  List<SingleStringModel> _cloneOptions(List<SingleStringModel> source) {
    return source
        .map((item) => item.copyWith(isSelected: false))
        .toList(growable: false);
  }

  void _setSelectedValues(
    List<SingleStringModel> options,
    List<String>? selected,
  ) {
    final normalized = selected
            ?.map((item) => item.trim().toLowerCase())
            .where((item) => item.isNotEmpty)
            .toSet() ??
        <String>{};

    for (final option in options) {
      final normalizedName = option.name.trim().toLowerCase();
      final normalizedValue = option.value?.trim().toLowerCase();
      option.isSelected = normalized.contains(normalizedName) ||
          (normalizedValue != null && normalized.contains(normalizedValue));
    }
  }

  List<String>? _selectedValues(List<SingleStringModel> options) {
    final values = options
        .where((option) => option.isSelected)
        .map((option) => option.name.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);

    if (values.isEmpty) {
      return null;
    }
    return values;
  }

  List<String>? _selectedApiValuesOrNames(List<SingleStringModel> options) {
    final values = options
        .where((option) => option.isSelected)
        .map((option) {
          final apiValue = option.value?.trim();
          if (apiValue != null && apiValue.isNotEmpty) {
            return apiValue;
          }
          return option.name.trim();
        })
        .where((value) => value.isNotEmpty)
        .toList(growable: false);

    if (values.isEmpty) {
      return null;
    }
    return values;
  }

  List<String>? _singlePreferenceList(
    TextEditingController controller, {
    String? fieldKey,
  }) {
    final tracked =
        fieldKey == null ? null : _selectedApiValues[fieldKey]?.trim();
    if (tracked != null && tracked.isNotEmpty) {
      return <String>[tracked];
    }

    final value = controller.text.trim();
    if (value.isEmpty) {
      return null;
    }
    return <String>[value];
  }

  String _selectedDisplayValues(List<SingleStringModel> options) {
    final values = options
        .where((option) => option.isSelected)
        .map((option) => option.name.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
    if (values.isEmpty) return '';
    return values.join(', ');
  }

  String _formatPreferenceHeight(int heightCm) {
    final totalInches = (heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet' $inches\"";
  }

  String? _apiValueOrText(String fieldKey, TextEditingController controller) {
    final tracked = _selectedApiValues[fieldKey]?.trim();
    if (tracked != null && tracked.isNotEmpty) {
      return tracked;
    }
    return _toTrimmedOrNull(controller);
  }

  String? _toTrimmedOrNull(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) {
      return null;
    }
    return value;
  }

  int? _toIntOrNull(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) {
      return null;
    }
    return int.tryParse(value);
  }

  List<String>? _toCsvListOrNull(TextEditingController controller) {
    final raw = controller.text.trim();
    if (raw.isEmpty) {
      return null;
    }

    final values = raw
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);

    if (values.isEmpty) {
      return null;
    }
    return values;
  }

  T? _firstOrNull<T>(List<T>? list) {
    if (list == null || list.isEmpty) {
      return null;
    }
    return list.first;
  }

  String _toCsv(List<String>? values) {
    if (values == null || values.isEmpty) {
      return '';
    }
    return values.join(', ');
  }
}

extension _ProfileSectionEditSavePrefillFormatUtilsPart
    on _ProfileSectionEditScreenState {
  List<String> get _heightDropdownItems =>
      _ProfileSectionEditScreenState._heightInchOptions
          .map((heightInches) => _formatHeightDisplay(heightInches))
          .toList(growable: false);

  void _selectHeight(String? displayValue) {
    final selectedValue = displayValue?.trim() ?? '';
    if (selectedValue.isEmpty) return;

    final heightInCm = _heightCmFromDisplay(selectedValue);
    if (heightInCm == null) return;

    _heightController.text = heightInCm.toString();
    _heightDisplayController.text = selectedValue;
  }

  void _prefillHeight(num? heightInCm) {
    if (heightInCm == null) {
      _heightController.text = '';
      _heightDisplayController.text = '';
      return;
    }
    final cmValue = heightInCm.round();
    _heightController.text = cmValue.toString();
    _heightDisplayController.text = _formatHeightDisplayFromCm(cmValue);
  }

  String _formatHeightDisplay(int totalInches) {
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return '$feet ft $inches in';
  }

  String _formatHeightDisplayFromCm(int cm) {
    final totalInches = (cm / 2.54).round();
    return _formatHeightDisplay(totalInches);
  }

  int? _heightCmFromDisplay(String displayValue) {
    final normalized = displayValue.trim().toLowerCase();
    final match = RegExp(r'^(\d+)\s*ft\s*(\d+)\s*in$').firstMatch(normalized);
    if (match == null) return null;
    final feet = int.tryParse(match.group(1)!);
    final inches = int.tryParse(match.group(2)!);
    if (feet == null || inches == null) return null;
    return (((feet * 12) + inches) * 2.54).round();
  }

  String _normalizeDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '${parsed.year}-$month-$day';
  }

  String _firstNonEmpty(String? first, String? second) {
    final normalizedFirst = first?.trim() ?? '';
    if (normalizedFirst.isNotEmpty) {
      return normalizedFirst;
    }
    return second?.trim() ?? '';
  }

  String? _resolveFamilyEconomicConditionValue(String? rawValue) {
    final selected = rawValue?.trim() ?? '';
    if (selected.isEmpty) {
      return null;
    }

    final normalized = selected.toLowerCase();
    final candidate = _ProfileSectionEditScreenState
            ._familyEconomicConditionAliases[normalized] ??
        _toSnakeCase(selected);

    for (final condition in RegistrationFamilyEconomicCondition.values) {
      if (condition.apiValue == candidate) {
        return candidate;
      }
    }

    return null;
  }

  String? _familyEconomicConditionLabel(String? apiValue) {
    final normalized = apiValue?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    for (final condition in RegistrationFamilyEconomicCondition.values) {
      if (condition.apiValue == normalized) {
        return condition.label;
      }
    }

    return null;
  }

  String _toSnakeCase(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  String ageText() {
    final txt = _dobController.text;
    if (txt.isEmpty) return '0 Year Age';

    DateTime? dob;
    try {
      dob = DateTime.tryParse(txt);
      dob ??= DateFormat('yyyy-MM-dd').parseLoose(txt);
    } catch (_) {
      dob = null;
    }

    if (dob == null) return '0 Year Age';

    final now = DateTime.now();
    int years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    if (years < 0) years = 0;
    return '$years years old'.replaceFirst('\u007f', '');
  }
}
