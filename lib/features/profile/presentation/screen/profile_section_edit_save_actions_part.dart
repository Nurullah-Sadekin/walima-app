// ignore_for_file: invalid_use_of_protected_member

part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditSaveActionsPart on _ProfileSectionEditScreenState {
  Future<void> _handleSave() async {
    if (_isSaving) return;

    _setSaving(true);
    final success = await _saveCurrentSection();

    if (!mounted) {
      _setSaving(false);
      return;
    }
    _setSaving(false);
    if (!success) return;

    await ref.read(profileProvider).getProfile(context);
    if (!mounted) return;

    await DialogUtils.showSuccessDialog(
      context: context,
      title: 'Saved Successfully',
      message: 'Your changes have been saved successfully.',
      buttonText: 'Close',
      autoClose: true,
      autoCloseDuration: const Duration(seconds: 2),
      onClose: () {
        if (context.mounted) context.pop(true);
      },
    );
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
