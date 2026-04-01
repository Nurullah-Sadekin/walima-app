import 'package:flutter/cupertino.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/profile/data/model/request/update_profile_photo_request.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/dashboard_response.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/get_complete_profile_response.dart';
import 'package:flutter_boilerplate/features/profile/data/repository/profile_repository.dart';
import 'package:flutter_boilerplate/features/registration/data/models/request/upload_media_request_body.dart';
import 'package:flutter_boilerplate/features/registration/data/repository/media_repository.dart';

class ProfileProvider extends BaseChangeNotifier {
  ProfileScreenStates screenStates = ProfileScreenStates.defaultState;
  final MediaRepository _mediaRepository = MediaRepository();
  ProfileScreenStates loaderState = ProfileScreenStates.defaultState;
  CompleteProfile? profile;
  DashboardData? dashboard;

  Future<void> getProfile(BuildContext context) async {
    final data = await ProfileRepository.getCompleteProfile();
    if (data.code == 'SUCCESS') {
      profile = data.response;
      updateViewState();
    } else {
      await DialogUtils.showErrorDialog(
          context: context, message: data.message ?? 'Failed to load profile');
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

  Future<void> updateProfileImage({
    required BuildContext context,
    required String filePath,
  }) async {
    updateViewState(loadingState: ProfileScreenStates.loading);
    try {
      final uploadResponse = await _mediaRepository.uploadMedia(
        UploadMediaRequestBody(
          filePath: filePath,
          alt: 'Profile photo',
          caption: '',
          description: '',
        ),
      );

      if (uploadResponse.code != 'SUCCESS' ||
          uploadResponse.response?.data?.id == null) {
        await DialogUtils.showErrorDialog(
          context: context,
          message: uploadResponse.message ?? 'Failed to upload image.',
        );
        return;
      }

      final mediaId = uploadResponse.response!.data!.id!;
      final photoSizes = <String, String?>{};
      final originalUrl = uploadResponse.response!.data!.url;
      if (originalUrl != null && originalUrl.isNotEmpty) {
        photoSizes['original'] = originalUrl;
      }

      final photoRequest = UpdateProfilePhotoRequest(
        mediaId: mediaId,
        category: 'profile',
        isPrimary: true,
        photoOrder: 1,
        visibility: 'connections_only',
        shouldDelete: false,
        photoSizes: photoSizes.isEmpty ? null : photoSizes,
      );

      final updateResponse =
          await ProfileRepository.updateProfilePhotos([photoRequest]);
      if (updateResponse.code != 'SUCCESS') {
        await DialogUtils.showErrorDialog(
          context: context,
          message: updateResponse.message ?? 'Failed to update profile image.',
        );
        return;
      }

      await getProfile(context);
      await getDashboard();
    } catch (e) {
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
