part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditUiDropdownHelpersPart
    on _ProfileSectionEditScreenState {
  Widget _enumDropdown<T extends ApiUiEnum>({
    required String label,
    required TextEditingController controller,
    required List<T> values,
    required String popupHeader,
    required String fieldKey,
  }) {
    final items = values.map((value) => value.label).toList(growable: false);
    return DropDownField(
      headLine: label,
      hintText: 'Select $label',
      popUpHeader: popupHeader,
      items: items,
      controller: controller,
      isSearch: false,
      onConfirm: (value) {
        final selected = value?.toString() ?? '';
        final match = _findEnumByLabelOrValue(values, selected);
        if (match != null) {
          _selectedApiValues[fieldKey] = match.apiValue;
        } else {
          _selectedApiValues.remove(fieldKey);
        }
      },
    );
  }

  Widget _lookupDropdown({
    required String label,
    required TextEditingController controller,
    required List<LookupOption> options,
    required String popupHeader,
    required String fieldKey,
    FutureOr<void> Function()? onTap,
    ValueChanged<LookupOption?>? onSelected,
  }) {
    final items = options.map((o) => o.label).toList(growable: false);
    return DropDownField(
      headLine: label,
      hintText: 'Select $label',
      popUpHeader: popupHeader,
      items: items,
      controller: controller,
      isSearch: true,
      onTap: onTap,
      onConfirm: (value) {
        final selected = value?.toString() ?? '';
        final match = _findLookupOption(options, selected);
        if (match != null) {
          _selectedApiValues[fieldKey] = match.key;
        } else {
          _selectedApiValues.remove(fieldKey);
        }
        onSelected?.call(match);
      },
    );
  }

  Widget _singleStringDropdown({
    required String label,
    required TextEditingController controller,
    required List<SingleStringModel> options,
    required String popupHeader,
    required String fieldKey,
  }) {
    final items = options.map((o) => o.name).toList(growable: false);
    return DropDownField(
      headLine: label,
      hintText: 'Select $label',
      popUpHeader: popupHeader,
      items: items,
      controller: controller,
      isSearch: false,
      onConfirm: (value) {
        final selected = value?.toString() ?? '';
        final match = options.firstWhere(
          (o) => o.name.toLowerCase() == selected.toLowerCase(),
          orElse: () => SingleStringModel(name: selected),
        );
        final apiValue = match.value;
        if (apiValue != null && apiValue.isNotEmpty) {
          _selectedApiValues[fieldKey] = apiValue;
        } else {
          _selectedApiValues.remove(fieldKey);
        }
      },
    );
  }

  LookupOption? _findLookupOption(List<LookupOption> options, String input) {
    final normalized = input.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    for (final option in options) {
      if (option.label.toLowerCase() == normalized ||
          option.key.toLowerCase() == normalized) {
        return option;
      }
    }
    return null;
  }

  String? _resolveLookupKey(List<LookupOption> options, String? input) {
    if (input == null) return null;
    return _findLookupOption(options, input)?.key;
  }

  T? _findEnumByLabelOrValue<T extends ApiUiEnum>(
    List<T> values,
    String? input,
  ) {
    final normalized = input?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) return null;
    for (final value in values) {
      if (value.apiValue.toLowerCase() == normalized ||
          value.label.toLowerCase() == normalized) {
        return value;
      }
    }
    return null;
  }
}
