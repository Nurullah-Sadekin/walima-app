import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/identity_verification/data/models/identity_verification_models.dart';
import 'package:walima_llc/features/identity_verification/data/repository/identity_verification_repository.dart';

/// Drives the identity-verification screen. The Walima backend status is the
/// single source of truth; the app never infers final verification itself.
class IdentityVerificationProvider extends BaseChangeNotifier {
  IdentityVerificationStatusData? _statusData;
  IdentityVerificationStatusData? get statusData => _statusData;

  bool _isLoadingStatus = false;
  bool get isLoadingStatus => _isLoadingStatus;

  bool _isCreatingSession = false;
  bool get isCreatingSession => _isCreatingSession;

  String? _statusError;
  String? get statusError => _statusError;

  /// Whether any status has been loaded at least once.
  bool get hasLoadedStatus => _statusData != null;

  /// Overall state for the current screen.
  IdentityVerificationState get verificationState =>
      _statusData?.state ?? IdentityVerificationState.notSubmitted;

  /// The latest session, if the backend returned one.
  LatestSession? get latestSession => _statusData?.latestSession;

  /// True when there is an active session the user can reopen instead of
  /// creating a new one.
  bool get canResumeSession =>
      verificationState == IdentityVerificationState.pending &&
      (latestSession?.hasOpenableUrl ?? false);

  /// Loads `GET /verification/status`. Use [showLoader] = false for silent
  /// refreshes (e.g. right after returning from the hosted flow).
  Future<void> loadStatus({bool showLoader = true}) async {
    if (showLoader) {
      _isLoadingStatus = true;
    }
    _statusError = null;
    notifyListeners();

    final response = await IdentityVerificationRepository.getStatus();

    if (response.isSuccess && response.data != null) {
      _statusData = response.data;
    } else {
      _statusError = response.message;
    }

    _isLoadingStatus = false;
    notifyListeners();
  }

  /// Creates (or resumes) a Didit session via `POST /verification/session`.
  ///
  /// Returns the session data (including `verificationUrl`) on success so the
  /// caller can open the hosted page, or `null` on failure (see [statusError]).
  Future<CreateVerificationSessionData?> startSession() async {
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

  void clearError() {
    if (_statusError == null) return;
    _statusError = null;
    notifyListeners();
  }
}
