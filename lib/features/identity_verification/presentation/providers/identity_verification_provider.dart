import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/identity_verification/data/models/identity_verification_models.dart';
import 'package:walima_llc/features/identity_verification/data/repository/identity_verification_repository.dart';

/// Drives the identity-verification screen. The Walima backend status is the
/// single source of truth; the app never infers final verification itself.
class IdentityVerificationProvider extends BaseChangeNotifier {
  static const _burstAttempts = 5;
  static const _burstDelay = Duration(milliseconds: 1500);

  IdentityVerificationStatusData? _statusData;
  IdentityVerificationStatusData? get statusData => _statusData;

  bool _isLoadingStatus = false;
  bool get isLoadingStatus => _isLoadingStatus;

  bool _isCreatingSession = false;
  bool get isCreatingSession => _isCreatingSession;

  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  String? _statusError;
  String? get statusError => _statusError;

  /// Whether any status has been loaded at least once.
  bool get hasLoadedStatus => _statusData != null;

  /// Display state for the current screen (guide §4).
  IdentityVerificationState get verificationState =>
      _statusData?.state ?? IdentityVerificationState.notSubmitted;

  /// The latest session, if the backend returned one.
  LatestSession? get latestSession => _statusData?.latestSession;

  bool get canStart => _statusData?.canStart ?? true;
  bool get canResume => _statusData?.canResume ?? false;
  bool get canCancel => _statusData?.canCancel ?? false;
  bool get isUnderReview => _statusData?.isUnderReview ?? false;

  /// Loads `GET /verification/status`. Use [showLoader] = false for silent
  /// refreshes.
  ///
  /// With [burst], retries up to 5 times, 1.5 s apart, while the latest
  /// session is still `Not Started` (matches the web's post-completion sync).
  /// Stops on error, on any other status, or when [keepGoing] returns false
  /// (e.g. the screen was left or the app went to background).
  ///
  /// Returns true when at least one request succeeded.
  Future<bool> loadStatus({
    bool showLoader = true,
    bool burst = false,
    bool Function()? keepGoing,
  }) async {
    if (_isLoadingStatus) return false;
    _isLoadingStatus = showLoader;
    _statusError = null;
    notifyListeners();

    var succeeded = false;
    for (var attempt = 0; attempt < (burst ? _burstAttempts : 1); attempt++) {
      if (attempt > 0) {
        if (keepGoing?.call() == false) break;
        await Future<void>.delayed(_burstDelay);
        if (keepGoing?.call() == false) break;
      }

      final response = await IdentityVerificationRepository.getStatus();
      if (!response.isSuccess || response.data == null) {
        // Keep the last known state; just surface the error.
        _statusError = response.message;
        break;
      }

      succeeded = true;
      _statusData = response.data;
      notifyListeners();

      final key = latestSession?.statusKey ?? '';
      if (key.isNotEmpty && key != 'not_started') break;
    }

    _isLoadingStatus = false;
    notifyListeners();
    return succeeded;
  }

  /// Creates (or reuses) a Didit session via `POST /verification/session`.
  ///
  /// Returns the session data (including `verificationUrl`) on success so the
  /// caller can open the hosted page, or `null` on failure (see [statusError]).
  Future<CreateVerificationSessionData?> startSession() async {
    if (_isCreatingSession) return null;
    _isCreatingSession = true;
    _statusError = null;
    notifyListeners();

    final ApiResponse<CreateVerificationSessionData> response =
        await IdentityVerificationRepository.createSession();

    CreateVerificationSessionData? result;
    if (response.isSuccess && response.data != null) {
      result = response.data;
    } else {
      _statusError = response.message;
    }

    _isCreatingSession = false;
    notifyListeners();

    return result;
  }

  /// `DELETE /verification/session`, then re-reads status even on failure
  /// (a 409 means the session advanced, e.g. into review).
  /// Returns the error message, or null on success.
  Future<String?> cancelSession() async {
    if (_isCancelling) return null;
    _isCancelling = true;
    _statusError = null;
    notifyListeners();

    final response = await IdentityVerificationRepository.cancelSession();
    final error = response.isSuccess
        ? null
        : (response.message.isNotEmpty
            ? response.message
            : 'Unable to cancel verification.');

    _isCancelling = false;
    await loadStatus(showLoader: false);
    if (error != null) {
      _statusError = error;
      notifyListeners();
    }
    return error;
  }

  void clearError() {
    if (_statusError == null) return;
    _statusError = null;
    notifyListeners();
  }
}
