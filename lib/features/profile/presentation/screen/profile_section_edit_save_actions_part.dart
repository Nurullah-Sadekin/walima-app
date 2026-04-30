// ignore_for_file: invalid_use_of_protected_member

part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditSaveActionsPart on _ProfileSectionEditScreenState {
  Future<void> _handleSave() async {
    if (_isSaving) {
      return;
    }

    _setSaving(true);

    final success = await _saveCurrentSection();

    if (!mounted) {
      _setSaving(false);
      return;
    }

    _setSaving(false);

    if (!success) {
      return;
    }

    final didSaveUnknownStrengthFields = await _saveUnknownStrengthFields();
    if (!mounted || !didSaveUnknownStrengthFields) {
      return;
    }

    await ref.read(profileProvider).getProfile(context);
    if (!mounted) {
      return;
    }

    await DialogUtils.showSuccessDialog(
      context: context,
      title: 'Saved Successfully',
      message: 'Your changes have been saved successfully.',
      buttonText: 'Close',
      autoClose: true,
      autoCloseDuration: const Duration(seconds: 2),
      onClose: () {
        if (context.mounted) {
          context.pop(true);
        }
      },
    );
  }

  Future<bool> _saveUnknownStrengthFields() async {
    if (!_isStrengthDrivenMode) {
      return true;
    }

    final knownKeys = _knownFieldKeysForSection(widget.section);
    final unknownPayload = <String, dynamic>{};
    for (final field in _effectiveStrengthFields) {
      final rawKey = field.key?.trim();
      if (rawKey == null || rawKey.isEmpty) continue;
      final normalized = _fieldKeyUseCase.normalize(rawKey);
      if (knownKeys.contains(normalized)) {
        continue;
      }

      final controller = _dynamicFieldControllers[rawKey];
      if (controller == null) {
        continue;
      }

      final selectedLookupValue =
          _dynamicFieldSelectedApiValues[rawKey]?.trim();
      if (selectedLookupValue != null && selectedLookupValue.isNotEmpty) {
        unknownPayload[rawKey] = selectedLookupValue;
        continue;
      }

      final value = controller.text.trim();
      if (value.isNotEmpty) {
        unknownPayload[rawKey] = value;
      }
    }

    if (unknownPayload.isEmpty) {
      return true;
    }

    final profileSnapshot = ref.read(profileProvider).profile;
    final primaryLocation = _firstOrNull(profileSnapshot?.locations);
    final primaryEducation = _firstOrNull(profileSnapshot?.educations);
    final primaryProfession = _firstOrNull(profileSnapshot?.profession);
    final sectionKey = widget.strengthSectionKey?.trim().toLowerCase();

    Map<String, dynamic> fields;
    switch (sectionKey) {
      case 'basic_profile':
        fields = <String, dynamic>{'profile': unknownPayload};
        break;
      case 'religion':
        fields = <String, dynamic>{'religion': unknownPayload};
        break;
      case 'family':
        fields = <String, dynamic>{'family': unknownPayload};
        break;
      case 'education':
        fields = <String, dynamic>{
          'educations': <Map<String, dynamic>>[
            _buildRecordPayload(
                    id: primaryEducation?.id, fields: unknownPayload) ??
                unknownPayload,
          ],
        };
        break;
      case 'profession':
        fields = <String, dynamic>{
          'professions': <Map<String, dynamic>>[
            _buildRecordPayload(
                    id: primaryProfession?.id, fields: unknownPayload) ??
                unknownPayload,
          ],
        };
        break;
      case 'location':
        fields = <String, dynamic>{
          'locations': <Map<String, dynamic>>[
            _buildRecordPayload(
                  id: primaryLocation?.id,
                  fields: <String, dynamic>{
                    'locationType':
                        _resolveLocationType(primaryLocation?.locationType),
                    ...unknownPayload,
                  },
                ) ??
                unknownPayload,
          ],
        };
        break;
      case 'appearance':
        fields = <String, dynamic>{'appearance': unknownPayload};
        break;
      case 'lifestyle':
        fields = <String, dynamic>{'lifestyle': unknownPayload};
        break;
      case 'preferences':
        fields = <String, dynamic>{'preferences': unknownPayload};
        break;
      case 'interests':
      case 'interest':
        fields = <String, dynamic>{'interests': unknownPayload};
        break;
      default:
        fields = _unknownPayloadFallbackBySection(unknownPayload);
        break;
    }

    return _updateWithUniversal(
      fields: fields,
      fallbackMessage: 'Failed to update fields',
    );
  }

  Map<String, dynamic> _unknownPayloadFallbackBySection(
    Map<String, dynamic> unknownPayload,
  ) {
    switch (widget.section) {
      case ProfileEditSection.aboutYourself:
      case ProfileEditSection.basicDetails:
        return <String, dynamic>{'profile': unknownPayload};
      case ProfileEditSection.religiousBackground:
        return <String, dynamic>{'religion': unknownPayload};
      case ProfileEditSection.familyDetails:
        return <String, dynamic>{'family': unknownPayload};
      case ProfileEditSection.educationCareer:
        return <String, dynamic>{
          'educations': <Map<String, dynamic>>[unknownPayload],
        };
      case ProfileEditSection.location:
        return <String, dynamic>{
          'locations': <Map<String, dynamic>>[unknownPayload],
        };
      case ProfileEditSection.hobbiesInterests:
        return <String, dynamic>{'interests': unknownPayload};
      case ProfileEditSection.preferenceBasicInfo:
      case ProfileEditSection.preferenceLocationDetails:
      case ProfileEditSection.preferenceEducationCareer:
      case ProfileEditSection.preferenceOtherDetails:
        return <String, dynamic>{'preferences': unknownPayload};
    }
  }

  Future<bool> _saveCurrentSection() {
    switch (widget.section) {
      case ProfileEditSection.aboutYourself:
        return _saveAboutYourselfSection();
      case ProfileEditSection.basicDetails:
        return _saveBasicDetailsSection();
      case ProfileEditSection.religiousBackground:
        return _saveReligiousBackgroundSection();
      case ProfileEditSection.familyDetails:
        return _saveFamilyDetailsSection();
      case ProfileEditSection.educationCareer:
        return _saveEducationCareerSection();
      case ProfileEditSection.location:
        return _saveLocationSection();
      case ProfileEditSection.hobbiesInterests:
        return _saveHobbiesInterestsSection();
      case ProfileEditSection.preferenceBasicInfo:
        return _savePreferenceBasicInfoSection();
      case ProfileEditSection.preferenceLocationDetails:
        return _savePreferenceLocationDetailsSection();
      case ProfileEditSection.preferenceEducationCareer:
        return _savePreferenceEducationCareerSection();
      case ProfileEditSection.preferenceOtherDetails:
        return _savePreferenceOtherDetailsSection();
    }
  }
}
