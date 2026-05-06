class PrivacySettings {
  final String? id;
  final String? userId;
  final String? displayNameFormat;
  final String? photoVisibility;
  final String? albumPhotoVisibility;
  final String? phoneVisibility;
  final String? emailVisibility;
  final String? dobDisplay;
  final String? incomeVisibility;
  final bool? shortlistAlert;
  final bool? allowPremiumCalls;
  final String? profilePrivacy;
  final bool? profileHidden;
  final String? hideDuration;
  final String? hiddenUntil;
  final String? deleteReason;
  final String? scheduledDeletionDate;
  final bool? showOnlineStatus;
  final bool? showLastSeen;
  final bool? showActivityStatus;
  final String? createdAt;
  final String? updatedAt;

  const PrivacySettings({
    this.id,
    this.userId,
    this.displayNameFormat,
    this.photoVisibility,
    this.albumPhotoVisibility,
    this.phoneVisibility,
    this.emailVisibility,
    this.dobDisplay,
    this.incomeVisibility,
    this.shortlistAlert,
    this.allowPremiumCalls,
    this.profilePrivacy,
    this.profileHidden,
    this.hideDuration,
    this.hiddenUntil,
    this.deleteReason,
    this.scheduledDeletionDate,
    this.showOnlineStatus,
    this.showLastSeen,
    this.showActivityStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory PrivacySettings.fromAny(dynamic data) {
    if (data is Map<String, dynamic>) {
      return PrivacySettings(
        id: data['id'] as String?,
        userId: data['userId'] as String?,
        displayNameFormat: data['displayNameFormat'] as String?,
        photoVisibility: data['photoVisibility'] as String?,
        albumPhotoVisibility: data['albumPhotoVisibility'] as String?,
        phoneVisibility: data['phoneVisibility'] as String?,
        emailVisibility: data['emailVisibility'] as String?,
        dobDisplay: data['dobDisplay'] as String?,
        incomeVisibility: data['incomeVisibility'] as String?,
        shortlistAlert: data['shortlistAlert'] as bool?,
        allowPremiumCalls: data['allowPremiumCalls'] as bool?,
        profilePrivacy: data['profilePrivacy'] as String?,
        profileHidden: data['profileHidden'] as bool?,
        hideDuration: data['hideDuration'] as String?,
        hiddenUntil: data['hiddenUntil'] as String?,
        deleteReason: data['deleteReason'] as String?,
        scheduledDeletionDate: data['scheduledDeletionDate'] as String?,
        showOnlineStatus: data['showOnlineStatus'] as bool?,
        showLastSeen: data['showLastSeen'] as bool?,
        showActivityStatus: data['showActivityStatus'] as bool?,
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
      );
    }
    return const PrivacySettings();
  }

  Map<String, dynamic> toRequestJson() {
    return {
      if (displayNameFormat != null) 'displayNameFormat': displayNameFormat,
      if (photoVisibility != null) 'photoVisibility': photoVisibility,
      if (albumPhotoVisibility != null) 'albumPhotoVisibility': albumPhotoVisibility,
      if (phoneVisibility != null) 'phoneVisibility': phoneVisibility,
      if (emailVisibility != null) 'emailVisibility': emailVisibility,
      if (dobDisplay != null) 'dobDisplay': dobDisplay,
      if (incomeVisibility != null) 'incomeVisibility': incomeVisibility,
      if (shortlistAlert != null) 'shortlistAlert': shortlistAlert,
      if (allowPremiumCalls != null) 'allowPremiumCalls': allowPremiumCalls,
      if (profilePrivacy != null) 'profilePrivacy': profilePrivacy,
      if (profileHidden != null) 'profileHidden': profileHidden,
      if (hideDuration != null) 'hideDuration': hideDuration,
      if (deleteReason != null) 'deleteReason': deleteReason,
      if (showOnlineStatus != null) 'showOnlineStatus': showOnlineStatus,
      if (showLastSeen != null) 'showLastSeen': showLastSeen,
      if (showActivityStatus != null) 'showActivityStatus': showActivityStatus,
    };
  }

  /// Returns only the specified field for single field updates
  Map<String, dynamic> toRequestJsonForKey(String key) {
    switch (key) {
      case 'displayNameFormat':
        return {'displayNameFormat': displayNameFormat};
      case 'photoVisibility':
        return {'photoVisibility': photoVisibility};
      case 'albumPhotoVisibility':
        return {'albumPhotoVisibility': albumPhotoVisibility};
      case 'phoneVisibility':
        return {'phoneVisibility': phoneVisibility};
      case 'emailVisibility':
        return {'emailVisibility': emailVisibility};
      case 'dobDisplay':
        return {'dobDisplay': dobDisplay};
      case 'incomeVisibility':
        return {'incomeVisibility': incomeVisibility};
      case 'shortlistAlert':
        return {'shortlistAlert': shortlistAlert};
      case 'allowPremiumCalls':
        return {'allowPremiumCalls': allowPremiumCalls};
      case 'profilePrivacy':
        return {'profilePrivacy': profilePrivacy};
      case 'profileHidden':
        return {'profileHidden': profileHidden};
      case 'hideDuration':
        return {'hideDuration': hideDuration};
      case 'deleteReason':
        return {'deleteReason': deleteReason};
      case 'showOnlineStatus':
        return {'showOnlineStatus': showOnlineStatus};
      case 'showLastSeen':
        return {'showLastSeen': showLastSeen};
      case 'showActivityStatus':
        return {'showActivityStatus': showActivityStatus};
      default:
        return toRequestJson();
    }
  }

  PrivacySettings copyWith({
    String? id,
    String? userId,
    String? displayNameFormat,
    String? photoVisibility,
    String? albumPhotoVisibility,
    String? phoneVisibility,
    String? emailVisibility,
    String? dobDisplay,
    String? incomeVisibility,
    bool? shortlistAlert,
    bool? allowPremiumCalls,
    String? profilePrivacy,
    bool? profileHidden,
    String? hideDuration,
    String? hiddenUntil,
    String? deleteReason,
    String? scheduledDeletionDate,
    bool? showOnlineStatus,
    bool? showLastSeen,
    bool? showActivityStatus,
    String? createdAt,
    String? updatedAt,
  }) {
    return PrivacySettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayNameFormat: displayNameFormat ?? this.displayNameFormat,
      photoVisibility: photoVisibility ?? this.photoVisibility,
      albumPhotoVisibility: albumPhotoVisibility ?? this.albumPhotoVisibility,
      phoneVisibility: phoneVisibility ?? this.phoneVisibility,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      dobDisplay: dobDisplay ?? this.dobDisplay,
      incomeVisibility: incomeVisibility ?? this.incomeVisibility,
      shortlistAlert: shortlistAlert ?? this.shortlistAlert,
      allowPremiumCalls: allowPremiumCalls ?? this.allowPremiumCalls,
      profilePrivacy: profilePrivacy ?? this.profilePrivacy,
      profileHidden: profileHidden ?? this.profileHidden,
      hideDuration: hideDuration ?? this.hideDuration,
      hiddenUntil: hiddenUntil ?? this.hiddenUntil,
      deleteReason: deleteReason ?? this.deleteReason,
      scheduledDeletionDate: scheduledDeletionDate ?? this.scheduledDeletionDate,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      showLastSeen: showLastSeen ?? this.showLastSeen,
      showActivityStatus: showActivityStatus ?? this.showActivityStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
