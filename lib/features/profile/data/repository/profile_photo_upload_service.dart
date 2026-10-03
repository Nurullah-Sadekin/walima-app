import 'dart:io';

import 'package:walima_llc/features/profile/data/model/request/update_profile_photo_request.dart';
import 'package:walima_llc/features/profile/data/repository/profile_repository.dart';
import 'package:walima_llc/features/registration/data/models/request/upload_media_request_body.dart';
import 'package:walima_llc/features/registration/data/models/response/upload_media_response.dart';
import 'package:walima_llc/features/registration/data/repository/media_repository.dart';

typedef ProfilePhotoUploadProgressCallback = void Function(
  ProfilePhotoUploadProgress progress,
);

class ProfilePhotoUploadService {
  ProfilePhotoUploadService({MediaRepository? mediaRepository})
      : _mediaRepository = mediaRepository ?? MediaRepository();

  final MediaRepository _mediaRepository;

  static const int _profilePhotoMaxBytes = 5 * 1024 * 1024;
  static const List<Duration> _temporaryUploadRetryDelays = <Duration>[
    Duration(seconds: 5),
    Duration(seconds: 15),
  ];
  static const Set<String> _allowedProfilePhotoExtensions = <String>{
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
    'avif',
    'heic',
    'heif',
  };

  String? validateProfileImageFile(String filePath) {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      return 'Please select an image to upload.';
    }

    final extension = normalizedPath.contains('.')
        ? normalizedPath.split('.').last.toLowerCase()
        : '';
    if (!_allowedProfilePhotoExtensions.contains(extension)) {
      return 'Unsupported image format. Please use JPG, PNG, WEBP, GIF, AVIF, HEIC, or HEIF.';
    }

    final file = File(normalizedPath);
    if (!file.existsSync()) {
      return 'Selected image could not be found. Please choose it again.';
    }

    final int fileSizeInBytes;
    try {
      fileSizeInBytes = file.lengthSync();
    } catch (_) {
      return 'Selected image could not be read. Please choose it again.';
    }
    if (fileSizeInBytes > _profilePhotoMaxBytes) {
      return 'This image is too large. Please use a photo under 5 MB.';
    }

    return null;
  }

  Future<ProfilePhotoUploadResult> uploadAndAttachProfileImage({
    required String filePath,
    String alt = 'Profile photo',
    String caption = 'Profile photo',
    String description = 'This is my profile photo',
    bool isPrimary = true,
    String visibility = 'public',
    ProfilePhotoUploadProgressCallback? onProgress,
  }) async {
    final normalizedPath = filePath.trim();
    final validationError = validateProfileImageFile(normalizedPath);
    if (validationError != null) {
      _emitProgress(
        onProgress,
        ProfilePhotoUploadFlowState.failed,
        errorMessage: validationError,
      );
      return ProfilePhotoUploadResult.failure(
        errorMessage: validationError,
        state: ProfilePhotoUploadFlowState.failed,
      );
    }

    final requestBody = UploadMediaRequestBody(
      filePath: normalizedPath,
      alt: alt,
      caption: caption,
      description: description,
      isPrimary: isPrimary,
      resourceType: 'UserProfile',
      resource: isPrimary ? 'profile_photo' : 'gallery_photo',
    );

    final uploadResponse = await _uploadProfileMediaWithRetry(
      requestBody,
      onProgress,
    );
    final uploadedData = uploadResponse.response?.data;
    final isSuccess = _isSuccessfulUploadResponse(uploadResponse);

    if (!isSuccess) {
      final mappedMessage =
          _mapProfileImageUploadMessage(uploadResponse.message);
      final failureState = _isAiRejectedProfileImage(uploadResponse.message)
          ? ProfilePhotoUploadFlowState.aiRejected
          : ProfilePhotoUploadFlowState.failed;
      final canRetry = _isTemporaryProfileImageFailure(uploadResponse.message);

      _emitProgress(
        onProgress,
        failureState,
        errorMessage: mappedMessage,
        canRetry: canRetry,
      );
      return ProfilePhotoUploadResult.failure(
        errorMessage: mappedMessage,
        state: failureState,
        canRetry: canRetry,
      );
    }

    _emitProgress(
      onProgress,
      ProfilePhotoUploadFlowState.mediaUploaded,
      statusMessage: 'Photo accepted. Attaching it to your profile...',
    );

    final originalUrl = uploadedData?.url?.trim();
    final photoSizes = <String, String?>{};
    if (originalUrl != null && originalUrl.isNotEmpty) {
      photoSizes['original'] = originalUrl;
    }

    final attachRequest = UpdateProfilePhotoRequest(
      mediaId: uploadedData!.id!.trim(),
      category: isPrimary ? 'profile' : 'gallery',
      isPrimary: isPrimary,
      photoOrder: isPrimary ? 1 : null,
      visibility: visibility,
      shouldDelete: false,
      photoSizes: photoSizes.isEmpty ? null : photoSizes,
    );

    _emitProgress(
      onProgress,
      ProfilePhotoUploadFlowState.attachingToProfile,
      statusMessage: 'Updating your profile photo...',
    );

    final attachResponse = await ProfileRepository.updateProfilePhotos(
      <UpdateProfilePhotoRequest>[attachRequest],
    );
    final attachSucceeded =
        (attachResponse.code ?? '').toUpperCase() == 'SUCCESS';

    if (!attachSucceeded) {
      final errorMessage =
          attachResponse.message ?? 'Failed to attach photo to your profile.';
      _emitProgress(
        onProgress,
        ProfilePhotoUploadFlowState.failed,
        errorMessage: errorMessage,
      );
      return ProfilePhotoUploadResult.failure(
        errorMessage: errorMessage,
        state: ProfilePhotoUploadFlowState.failed,
      );
    }

    _emitProgress(
      onProgress,
      ProfilePhotoUploadFlowState.completed,
      statusMessage: 'Photo uploaded successfully.',
    );
    return ProfilePhotoUploadResult.success(uploadedData: uploadedData);
  }

  Future<UploadMediaResponse> _uploadProfileMediaWithRetry(
    UploadMediaRequestBody requestBody,
    ProfilePhotoUploadProgressCallback? onProgress,
  ) async {
    for (var attempt = 0;
        attempt <= _temporaryUploadRetryDelays.length;
        attempt++) {
      _emitProgress(
        onProgress,
        ProfilePhotoUploadFlowState.uploadingForAiCheck,
        statusMessage: 'Checking your photo before upload...',
      );

      final response = await _mediaRepository.uploadMedia(requestBody);
      if (_isSuccessfulUploadResponse(response)) {
        return response;
      }

      if (!_isTemporaryProfileImageFailure(response.message) ||
          attempt == _temporaryUploadRetryDelays.length) {
        return response;
      }

      final retryDelay = _temporaryUploadRetryDelays[attempt];
      _emitProgress(
        onProgress,
        ProfilePhotoUploadFlowState.uploadingForAiCheck,
        statusMessage:
            'Photo verification is busy. Retrying in ${retryDelay.inSeconds} seconds...',
      );
      await Future<void>.delayed(retryDelay);
    }

    return UploadMediaResponse(
      code: 'FAILED',
      message:
          'Photo verification is temporarily busy. Please wait a moment and try again.',
    );
  }

  void _emitProgress(
    ProfilePhotoUploadProgressCallback? callback,
    ProfilePhotoUploadFlowState state, {
    String statusMessage = '',
    String errorMessage = '',
    bool canRetry = false,
  }) {
    callback?.call(
      ProfilePhotoUploadProgress(
        state: state,
        statusMessage: statusMessage,
        errorMessage: errorMessage,
        canRetry: canRetry,
      ),
    );
  }

  bool _isSuccessfulUploadResponse(UploadMediaResponse response) {
    final code = (response.code ?? '').toUpperCase();
    return code == 'SUCCESS' &&
        response.response?.data != null &&
        (response.response?.data?.id?.trim().isNotEmpty ?? false);
  }

  String _mapProfileImageUploadMessage(String? rawMessage) {
    final message = rawMessage?.trim();
    if (message == null || message.isEmpty) {
      return 'Failed to upload profile image.';
    }

    final lower = message.toLowerCase();
    if (lower.contains('ai-generated photos are not allowed')) {
      return 'This photo looks AI-generated. Please upload a real recent photo.';
    }
    if (lower.contains('reused from public websites')) {
      return 'This looks like a publicly reused image. Upload your own photo.';
    }
    if (lower.contains('front-facing photo')) {
      return 'Please upload a clear front-facing photo.';
    }
    if (lower.contains('temporarily busy')) {
      return 'Photo verification is temporarily busy. Please wait a moment and try again.';
    }
    if (lower.contains('too large') || lower.contains('5mb')) {
      return 'This image is too large. Please use a photo under 5 MB.';
    }
    return message;
  }

  bool _isTemporaryProfileImageFailure(String? rawMessage) {
    final lower = rawMessage?.toLowerCase() ?? '';
    return lower.contains('temporarily busy') ||
        lower.contains('please wait a minute and try again') ||
        lower.contains('status code: 429') ||
        lower.contains('status code: 502');
  }

  bool _isAiRejectedProfileImage(String? rawMessage) {
    final lower = rawMessage?.toLowerCase() ?? '';
    return lower.contains('ai-generated photos are not allowed') ||
        lower.contains('reused from public websites') ||
        lower.contains('front-facing photo');
  }
}

class ProfilePhotoUploadProgress {
  const ProfilePhotoUploadProgress({
    required this.state,
    this.statusMessage = '',
    this.errorMessage = '',
    this.canRetry = false,
  });

  final ProfilePhotoUploadFlowState state;
  final String statusMessage;
  final String errorMessage;
  final bool canRetry;
}

class ProfilePhotoUploadResult {
  const ProfilePhotoUploadResult({
    required this.isSuccess,
    required this.state,
    this.uploadedData,
    this.errorMessage = '',
    this.canRetry = false,
  });

  factory ProfilePhotoUploadResult.success({
    required UploadMediaData uploadedData,
  }) {
    return ProfilePhotoUploadResult(
      isSuccess: true,
      state: ProfilePhotoUploadFlowState.completed,
      uploadedData: uploadedData,
    );
  }

  factory ProfilePhotoUploadResult.failure({
    required String errorMessage,
    required ProfilePhotoUploadFlowState state,
    bool canRetry = false,
  }) {
    return ProfilePhotoUploadResult(
      isSuccess: false,
      state: state,
      errorMessage: errorMessage,
      canRetry: canRetry,
    );
  }

  final bool isSuccess;
  final ProfilePhotoUploadFlowState state;
  final UploadMediaData? uploadedData;
  final String errorMessage;
  final bool canRetry;
}

enum ProfilePhotoUploadFlowState {
  idle,
  uploadingForAiCheck,
  aiRejected,
  mediaUploaded,
  attachingToProfile,
  completed,
  failed,
}
