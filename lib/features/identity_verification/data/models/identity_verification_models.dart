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
  unknown,
}

/// Maps a raw backend/Didit status string to an [IdentityVerificationState].
///
/// The buckets follow the current web frontend logic (guide §10). Unrecognised
/// values resolve to [IdentityVerificationState.unknown] so callers can keep the
/// last known state and show a neutral fallback.
IdentityVerificationState mapVerificationStatus(String? rawStatus) {
  final normalized = (rawStatus ?? '').trim().toLowerCase().replaceAll(' ', '_');

  if (normalized.isEmpty) return IdentityVerificationState.notSubmitted;

  const notSubmitted = {
    'unverified',
    'not_verified',
    'none',
    'not_submitted',
    'unsubmitted',
  };
  const approved = {
    'approved',
    'verified',
  };
  const pending = {
    'under_review',
    'in_review',
    'in_progress',
    'processing',
    'pending',
    'started',
    'submitted',
    'review',
    'manual_review',
    'awaiting_review',
    'not_started',
    'awaiting_user',
    'resubmitted',
  };
  const rejected = {
    'declined',
    'rejected',
    'failed',
    'expired',
    'kyc_expired',
    'abandoned',
  };

  if (notSubmitted.contains(normalized)) {
    return IdentityVerificationState.notSubmitted;
  }
  if (approved.contains(normalized)) return IdentityVerificationState.approved;
  if (rejected.contains(normalized)) return IdentityVerificationState.rejected;
  if (pending.contains(normalized)) return IdentityVerificationState.pending;

  return IdentityVerificationState.unknown;
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

  IdentityVerificationState get state => mapVerificationStatus(status);

  bool get hasOpenableUrl => (verificationUrl?.isNotEmpty ?? false);
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

  /// Overall state for the screen, combining the user-level status, the
  /// `isVerified` flag and the latest session as a fallback.
  IdentityVerificationState get state {
    if (isVerified) return IdentityVerificationState.approved;

    final fromStatus = mapVerificationStatus(identityVerificationStatus);
    if (fromStatus == IdentityVerificationState.approved ||
        fromStatus == IdentityVerificationState.rejected ||
        fromStatus == IdentityVerificationState.pending) {
      return fromStatus;
    }

    // Status was notSubmitted/unknown — consult the latest session.
    final fromSession = mapVerificationStatus(latestSession?.status);
    if (fromSession == IdentityVerificationState.approved ||
        fromSession == IdentityVerificationState.rejected ||
        fromSession == IdentityVerificationState.pending) {
      return fromSession;
    }

    if (fromStatus == IdentityVerificationState.notSubmitted) {
      return IdentityVerificationState.notSubmitted;
    }
    // Unknown user status: lean on whether any session exists.
    return latestSession == null
        ? IdentityVerificationState.notSubmitted
        : IdentityVerificationState.pending;
  }
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
