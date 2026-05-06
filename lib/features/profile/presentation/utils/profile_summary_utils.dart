import 'package:intl/intl.dart';

import 'package:walima_llc/features/profile/data/model/response/dashboard_response.dart';

String resolveDisplayName(Profile? profile) {
  final displayName = profile?.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return displayName;
  }

  final name = profile?.name?.trim();
  if (name != null && name.isNotEmpty) {
    return name;
  }

  return 'Unknown User';
}

String resolveMemberId(Profile? profile) {
  final reference = profile?.userReference?.trim();
  if (reference != null && reference.isNotEmpty) {
    return reference;
  }
  return '--';
}

String resolvePlanName(Membership? membership) {
  final planName = membership?.plan?.name?.trim();
  if (planName != null && planName.isNotEmpty) {
    return planName;
  }

  final tier = membership?.membershipTier?.trim();
  if (tier != null && tier.isNotEmpty) {
    return tier;
  }

  return 'Free';
}

String formatExpiry(String? value) {
  if (value == null || value.isEmpty) {
    return 'Expires: --';
  }

  final date = DateTime.tryParse(value)?.toLocal();
  if (date == null) {
    return 'Expires: --';
  }

  return 'Expires: ${DateFormat('MMMM yyyy').format(date)}';
}
