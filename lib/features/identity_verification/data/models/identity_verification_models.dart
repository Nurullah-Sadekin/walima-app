// Data models for the Walima identity-verification (Didit KYC) flow.
//
// These models intentionally mirror the Walima backend contract, not Didit's
// internal schema. Flutter never talks to Didit directly — the backend owns the
// Didit API key, session creation, polling and webhook verification.
//
// See `FLUTTER_DIDIT_IDENTITY_VERIFICATION_GUIDE.md` for the full contract.

/// High-level verification state used to drive the UI.
enum IdentityVerificationState {
  notSubmitted,
  pending,
  approved,
  rejected,

  /// Raw status not in any recognised bucket. Never shown directly; display
  /// logic falls back to the user-level status (guide §4).
  unknown,
}

/// Normalises a raw status: trim, lowercase, and collapse spaces, hyphens and
/// underscores to `_` (e.g. `"In Review"` → `in_review`).
String verificationStatusKey(String? value) => (value ?? '')
    .trim()
    .toLowerCase()
    .replaceAll(RegExp(r'[\s_-]+'), '_');

// Backend mapping (guide §4).
const _approvedStates = {'approved', 'verified'};
const _rejectedStates = {'declined', 'rejected', 'failed'};
const _notSubmittedStates = {
  'not_started',
  'expired',
  'abandoned',
  'kyc_expired',
  'cancelled',
};
const _pendingStates = {
  'in_progress',
  'in_review',
  'under_review',
  'processing',
  'pending',
  'started',
  'submitted',
  'review',
  'manual_review',
  'awaiting_review',
  'awaiting_user',
  'resubmitted',
};

// Button / sub-state checks (guide §4, current web rules).
const _resumeStates = {
  'not_started',
  'in_progress',
  'started',
  'resubmitted',
  'awaiting_user',
};
const _cancelStates = {'not_started', 'in_progress'};
const _reviewStates = {
  'under_review',
  'in_review',
  'review',
  'manual_review',
  'awaiting_review',
};

/// Maps a raw Didit session status to an [IdentityVerificationState].
/// Unrecognised (or empty) values return [IdentityVerificationState.unknown].
IdentityVerificationState mapVerificationStatus(String? rawStatus) {
  final key = verificationStatusKey(rawStatus);
  if (_approvedStates.contains(key)) return IdentityVerificationState.approved;
  if (_rejectedStates.contains(key)) return IdentityVerificationState.rejected;
  if (_notSubmittedStates.contains(key)) {
    return IdentityVerificationState.notSubmitted;
  }
  if (_pendingStates.contains(key)) return IdentityVerificationState.pending;
  return IdentityVerificationState.unknown;
}

/// Display state, matching the web: a recognised latest-session status wins;
/// otherwise the user-level enum (`approved` / `pending` / `rejected` /
/// `not_submitted`); anything invalid or missing is `notSubmitted`.
///
/// For rendering only — never treat this as authorisation.
IdentityVerificationState resolveVerificationDisplayState({
  String? sessionStatus,
  String? userStatus,
}) {
  final fromSession = mapVerificationStatus(sessionStatus);
  if (fromSession != IdentityVerificationState.unknown) return fromSession;

  return switch (verificationStatusKey(userStatus)) {
    'approved' => IdentityVerificationState.approved,
    'pending' => IdentityVerificationState.pending,
    'rejected' => IdentityVerificationState.rejected,
    _ => IdentityVerificationState.notSubmitted,
  };
}

/// Response payload of `POST /api/v1/verification/session`.
class CreateVerificationSessionData {
  const CreateVerificationSessionData({
    required this.sessionId,
    required this.status,
    required this.isExisting,
    this.verificationUrl,
  });

  factory CreateVerificationSessionData.fromJson(Map<String, dynamic> json) {
    return CreateVerificationSessionData(
      sessionId: json['sessionId']?.toString() ?? '',
      verificationUrl: _trimmedOrNull(json['verificationUrl']),
      status: json['status']?.toString() ?? '',
      isExisting: json['isExisting'] == true,
    );
  }

  final String sessionId;
  final String? verificationUrl;
  final String status;
  final bool isExisting;
}

/// A single Didit session as exposed by the Walima backend.
class LatestSession {
  const LatestSession({
    required this.sessionId,
    required this.status,
    this.verificationUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory LatestSession.fromJson(Map<String, dynamic> json) {
    return LatestSession(
      sessionId: json['sessionId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      verificationUrl: _trimmedOrNull(json['verificationUrl']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  final String sessionId;
  final String status;
  final String? verificationUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get statusKey => verificationStatusKey(status);

  bool get hasOpenableUrl => (verificationUrl?.isNotEmpty ?? false);

  /// Unfinished session the user can continue (needs a URL).
  bool get canResume => _resumeStates.contains(statusKey) && hasOpenableUrl;

  /// Backend re-checks; only `Not Started` / `In Progress` are cancellable.
  bool get canCancel => _cancelStates.contains(statusKey);

  /// Pending and waiting on review (no Resume/Cancel).
  bool get isUnderReview => _reviewStates.contains(statusKey);
}

/// Response payload of `GET /api/v1/verification/status`.
class IdentityVerificationStatusData {
  const IdentityVerificationStatusData({
    required this.identityVerificationStatus,
    required this.isVerified,
    this.latestSession,
  });

  factory IdentityVerificationStatusData.fromJson(Map<String, dynamic> json) {
    final session = json['latestSession'];
    return IdentityVerificationStatusData(
      identityVerificationStatus:
          json['identityVerificationStatus']?.toString() ?? '',
      isVerified: json['isVerified'] == true,
      latestSession: session is Map
          ? LatestSession.fromJson(Map<String, dynamic>.from(session))
          : null,
    );
  }

  final String identityVerificationStatus;
  final bool isVerified;
  final LatestSession? latestSession;

  /// Display state (guide §4): latest session status first, then the
  /// user-level status. `isVerified` is derived server-side from the user
  /// status, so it is not consulted separately.
  IdentityVerificationState get state => resolveVerificationDisplayState(
        sessionStatus: latestSession?.status,
        userStatus: identityVerificationStatus,
      );

  bool get canStart =>
      state == IdentityVerificationState.notSubmitted ||
      state == IdentityVerificationState.rejected;

  bool get canResume => latestSession?.canResume ?? false;
  bool get canCancel => latestSession?.canCancel ?? false;
  bool get isUnderReview => latestSession?.isUnderReview ?? false;
}

String? _trimmedOrNull(dynamic value) {
  if (value == null) return null;
  final str = value.toString().trim();
  return str.isEmpty ? null : str;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
