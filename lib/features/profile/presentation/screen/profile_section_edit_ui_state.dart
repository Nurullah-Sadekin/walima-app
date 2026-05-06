import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSectionEditUiState extends ChangeNotifier {
  bool _isSaving = false;
  bool _isLookupLoading = false;

  bool get isSaving => _isSaving;
  bool get isLookupLoading => _isLookupLoading;

  void setSaving(bool value) {
    if (_isSaving == value) return;
    _isSaving = value;
    notifyListeners();
  }

  void setLookupLoading(bool value) {
    if (_isLookupLoading == value) return;
    _isLookupLoading = value;
    notifyListeners();
  }
}

final profileSectionEditUiProvider = ChangeNotifierProvider.autoDispose
    .family<ProfileSectionEditUiState, String>((ref, key) {
  return ProfileSectionEditUiState();
});
