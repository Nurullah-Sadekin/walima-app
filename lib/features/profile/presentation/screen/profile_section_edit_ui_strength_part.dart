part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditUiStrengthPart on _ProfileSectionEditScreenState {
  Widget _buildStrengthDrivenSectionBody() {
    final fields = _effectiveStrengthFields;
    if (fields.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.section == ProfileEditSection.hobbiesInterests) {
      return _buildHobbiesInterestsSectionBody();
    }

    final children = <Widget>[];
    for (final field in fields) {
      final widgetOrNull = _buildStrengthDrivenField(field);
      if (widgetOrNull != null) {
        children.add(widgetOrNull);
      }
    }

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildCard(children: children);
  }

  Widget? _buildStrengthDrivenField(ProfileStrengthField field) {
    final rawKey = field.key?.trim();
    if (rawKey == null || rawKey.isEmpty) {
      return null;
    }
    final normalized = _fieldKeyUseCase.normalize(rawKey);
    final label = field.label?.trim().isNotEmpty == true
        ? field.label!.trim()
        : _fieldKeyUseCase.humanize(rawKey);

    final preferenceBasicWidget = _buildStrengthPreferenceBasicInfoField(
      normalized: normalized,
      label: label,
    );
    if (preferenceBasicWidget != null) {
      return preferenceBasicWidget;
    }

    final preferenceEducationWidget =
        _buildStrengthPreferenceEducationCareerField(
      normalized: normalized,
      label: label,
    );
    if (preferenceEducationWidget != null) {
      return preferenceEducationWidget;
    }

    final preferenceOtherWidget = _buildStrengthPreferenceOtherField(
      normalized: normalized,
      label: label,
    );
    if (preferenceOtherWidget != null) {
      return preferenceOtherWidget;
    }

    if (widget.section == ProfileEditSection.preferenceLocationDetails &&
        normalized == 'locationpreference') {
      return _buildPreferenceLocationSectionBody();
    }

    final binding = _bindingForStrengthField(normalized, rawKey);
    if (binding == null) {
      final fallbackController = _dynamicFieldControllers[rawKey];
      if (fallbackController == null) return null;
      return _buildStrengthLookupOrTextField(
        label: label,
        rawFieldKey: rawKey,
        controller: fallbackController,
      );
    }

    if (normalized == 'languages') {
      return _multiLookupField(
        label: label,
        controller: binding.controller,
        hintText: 'Select $label',
        onTap: _openLanguagesPicker,
      );
    }

    return _buildStrengthLookupOrTextField(
      label: label,
      rawFieldKey: rawKey,
      controller: binding.controller,
      selectedApiValueKey: binding.selectedApiValueKey,
      datePicker: binding.datePicker,
      keyboardType: binding.keyboardType,
    );
  }

  Widget? _buildStrengthPreferenceBasicInfoField({
    required String normalized,
    required String label,
  }) {
    if (widget.section != ProfileEditSection.preferenceBasicInfo) {
      return null;
    }

    if (normalized == 'agerange') {
      return _rangeSelector(
        label: label,
        startValue: _prefAgeStart,
        endValue: _prefAgeEnd,
        min: _ProfileSectionEditScreenState._prefAgeMinLimit,
        max: _ProfileSectionEditScreenState._prefAgeMaxLimit,
        startLabel: '$_prefAgeStart',
        endLabel: '$_prefAgeEnd',
        onChanged: _setPreferredAgeRange,
      );
    }

    if (normalized == 'heightrange') {
      return _rangeSelector(
        label: label,
        startValue: _prefHeightStart,
        endValue: _prefHeightEnd,
        min: _ProfileSectionEditScreenState._prefHeightMinLimit,
        max: _ProfileSectionEditScreenState._prefHeightMaxLimit,
        startLabel: _formatPreferenceHeight(_prefHeightStart),
        endLabel: _formatPreferenceHeight(_prefHeightEnd),
        onChanged: _setPreferredHeightRange,
      );
    }

    if (normalized == 'maritalstatuspreference') {
      return _multiSelectField(
        label: label,
        options: _prefMaritalOptions,
        onItemTap: (index) => _toggleOption(_prefMaritalOptions, index),
      );
    }

    return null;
  }

  Widget? _buildStrengthPreferenceEducationCareerField({
    required String normalized,
    required String label,
  }) {
    if (widget.section != ProfileEditSection.preferenceEducationCareer) {
      return null;
    }

    if (normalized == 'educationpreference') {
      return _multiSelectField(
        label: label,
        options: _prefEducationOptions,
        onItemTap: (index) => _toggleOption(_prefEducationOptions, index),
      );
    }

    if (normalized == 'workingaspreference') {
      return _multiSelectField(
        label: label,
        options: _prefWorkingAsOptions,
        onItemTap: (index) => _toggleOption(_prefWorkingAsOptions, index),
      );
    }

    return null;
  }

  Widget? _buildStrengthPreferenceOtherField({
    required String normalized,
    required String label,
  }) {
    if (widget.section != ProfileEditSection.preferenceOtherDetails) {
      return null;
    }

    if (normalized == 'profilemanagedbypreference') {
      return _multiSelectField(
        label: label,
        options: _prefProfileManagedByOptions,
        onItemTap: (index) =>
            _toggleOption(_prefProfileManagedByOptions, index),
      );
    }

    if (normalized == 'dietpreference') {
      return _multiSelectField(
        label: label,
        options: _prefDietOptions,
        onItemTap: (index) => _toggleOption(_prefDietOptions, index),
      );
    }

    return null;
  }

  Widget _buildStrengthLookupOrTextField({
    required String label,
    required String rawFieldKey,
    required TextEditingController controller,
    String? selectedApiValueKey,
    bool datePicker = false,
    TextInputType? keyboardType,
  }) {
    final options =
        _dynamicFieldLookupOptions[rawFieldKey] ?? const <LookupOption>[];
    if (options.isNotEmpty) {
      return _lookupDropdown(
        label: label,
        controller: controller,
        options: options,
        popupHeader: 'Select $label',
        fieldKey: selectedApiValueKey ?? rawFieldKey,
        onSelected: (selected) {
          final key = selectedApiValueKey ?? rawFieldKey;
          if (selected != null) {
            _dynamicFieldSelectedApiValues[rawFieldKey] = selected.key;
            _selectedApiValues[key] = selected.key;
          } else {
            _dynamicFieldSelectedApiValues.remove(rawFieldKey);
            _selectedApiValues.remove(key);
          }
        },
      );
    }

    return _field(
      label: label,
      controller: controller,
      datePicker: datePicker,
      keyboardType: keyboardType,
    );
  }
}
