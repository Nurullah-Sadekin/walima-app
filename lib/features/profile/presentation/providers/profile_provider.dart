import 'package:flutter/cupertino.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/features/profile/data/model/response/dashboard_response.dart';
import 'package:walima_llc/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:walima_llc/features/profile/data/repository/profile_photo_upload_service.dart';
import 'package:walima_llc/features/profile/data/repository/profile_repository.dart';

class ProfileProvider extends BaseChangeNotifier {
  ProfileScreenStates screenStates = ProfileScreenStates.defaultState;
  final ProfilePhotoUploadService _profilePhotoUploadService =
      ProfilePhotoUploadService();
  ProfileScreenStates loaderState = ProfileScreenStates.defaultState;
  CompleteProfile? profile;
  DashboardData? dashboard;
  String profileImageUploadErrorMessage = '';
  String profileImageUploadStatusMessage = '';
  bool canRetryProfileImageUpload = false;
  ProfilePhotoUploadFlowState profileImageUploadFlowState =
      ProfilePhotoUploadFlowState.idle;

  Future<void> getProfile(BuildContext context) async {
    final data = await ProfileRepository.getCompleteProfile();
    if (data.code == 'SUCCESS') {
      profile = data.response;
      updateViewState();
    } else {
      if (!context.mounted) return;
      await DialogUtils.showErrorDialog(
        context: context,
        message: data.message ?? 'Failed to load profile',
      );
      profile = null;
    }
  }

  Future<void> getDashboard() async {
    final data = await ProfileRepository.getDashboard();
    if (data.code == 'SUCCESS') {
      dashboard = data.response;
      updateViewState();
    } else {
      dashboard = null;
    }
  }

  void updateViewState({
    ProfileScreenStates? screenStates,
    ProfileScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = ProfileScreenStates.defaultState;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }

  String? validateProfileImageFile(String filePath) {
    return _profilePhotoUploadService.validateProfileImageFile(filePath);
  }

  void resetProfileImageUploadFlow({bool notify = true}) {
    profileImageUploadErrorMessage = '';
    profileImageUploadStatusMessage = '';
    canRetryProfileImageUpload = false;
    profileImageUploadFlowState = ProfilePhotoUploadFlowState.idle;
    if (notify) notifyListeners();
  }

  void _handleProfilePhotoUploadProgress(
    ProfilePhotoUploadProgress progress,
  ) {
    profileImageUploadFlowState = progress.state;
    profileImageUploadStatusMessage = progress.statusMessage;
    profileImageUploadErrorMessage = progress.errorMessage;
    canRetryProfileImageUpload = progress.canRetry;
    notifyListeners();
  }

  Future<void> updateProfileImage({
    required BuildContext context,
    required String filePath,
  }) async {
    updateViewState(loadingState: ProfileScreenStates.loading);
    try {
      resetProfileImageUploadFlow(notify: false);
      final result =
          await _profilePhotoUploadService.uploadAndAttachProfileImage(
        filePath: filePath,
        caption: '',
        description: '',
        visibility: 'connections_only',
        onProgress: _handleProfilePhotoUploadProgress,
      );

      if (!context.mounted) return;

      if (!result.isSuccess) {
        await DialogUtils.showErrorDialog(
          context: context,
          message: result.errorMessage.isNotEmpty
              ? result.errorMessage
              : 'Failed to upload image.',
        );
        return;
      }

      await getProfile(context);
      await getDashboard();
    } catch (e) {
      if (!context.mounted) return;
      await DialogUtils.showErrorDialog(
        context: context,
        message: e.toString(),
      );
    } finally {
      updateViewState(loadingState: ProfileScreenStates.defaultState);
    }
  }
}

enum ProfileScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}
