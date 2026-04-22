import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/profile_preview/data/models/profile_preview_response.dart';
import 'package:flutter_boilerplate/features/profile_preview/data/repository/profile_preview_repository.dart';

class ProfilePreviewProvider extends BaseChangeNotifier {
  bool isLoading = false;
  String? error;
  ProfilePreviewData? preview;
  String? _loadedUserId;

  Future<void> loadPreview(String userId, {bool force = false}) async {
    if (userId.isEmpty) {
      error = 'Invalid profile';
      preview = null;
      notifyListeners();
      return;
    }
    if (!force && _loadedUserId == userId && preview != null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    final response = await ProfilePreviewRepository.getProfilePreview(userId);

    if (response.isSuccess) {
      preview = response.data;
      _loadedUserId = userId;
      error = null;
    } else {
      preview = null;
      error = response.message ?? 'Unable to load profile';
    }

    isLoading = false;
    notifyListeners();
  }

  void reset() {
    isLoading = false;
    error = null;
    preview = null;
    _loadedUserId = null;
    notifyListeners();
  }
}
