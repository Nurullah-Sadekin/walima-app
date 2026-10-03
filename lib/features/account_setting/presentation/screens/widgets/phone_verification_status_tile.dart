import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/account_setting/presentation/screens/account_setting_screen.dart';
import 'package:walima_llc/features/home/presentation/screens/widgets/verification_status_card.dart';
import 'package:walima_llc/features/identity_verification/data/models/identity_verification_models.dart';

/// Account-level phone verification card; opens My Contact Settings.
/// Shown only while the phone is unverified.
///
/// Always driven by `GET /auth/me` → `user.isPhoneVerified` (held in
/// [globalProvider]); never inferred from contact entries or `isVerified`.
class PhoneVerificationStatusTile extends ConsumerWidget {
  const PhoneVerificationStatusTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVerified = ref.watch(
      globalProvider.select((p) => p.currentUser?.isPhoneVerified),
    );
    // Hide until /auth/me (or its cached snapshot) has loaded, and once
    // verified — the card is only a call to action.
    if (isVerified != false) return const SizedBox.shrink();

    return VerificationStatusCard(
      leading: const CircleAvatar(
        radius: 10,
        backgroundColor: AppColors.primary,
        child: ShowImage(
          imagePath: AppImages.callIcon,
          width: 10,
          height: 10,
          color: AppColors.white,
        ),
      ),
      title: 'Verify Phone Number',
      status: VerificationCardStatus.unverified,
      onTap: () => context.pushNamed(
        Routes.accountSetting,
        extra: AccountSettingStep.myContactSettings,
      ),
    );
  }
}

/// Government ID display state, using the guide's web rule (latest Didit
/// session status first, then the user status). Prefers
/// `GET /verification/status` once loaded; until then falls back to
/// `/auth/me` → `identityVerificationStatus`. Null while nothing is loaded.
IdentityVerificationState? watchIdentityDisplayState(WidgetRef ref) {
  final statusData = ref.watch(identityVerificationProvider.select((p) => p.statusData));
  if (statusData != null) return statusData.state;

  final user = ref.watch(globalProvider.select((p) => p.currentUser));
  if (user == null) return null;
  return resolveVerificationDisplayState(
    userStatus: user.identityVerificationStatus,
  );
}

/// Government ID card. Shown only until the ID is approved.
class GovernmentIdVerificationStatusTile extends ConsumerWidget {
  const GovernmentIdVerificationStatusTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = watchIdentityDisplayState(ref);
    if (state == null || state == IdentityVerificationState.approved) {
      return const SizedBox.shrink();
    }

    return VerificationStatusCard(
      leading: const ShowImage(
        imagePath: AppImages.verifiedBadgeSvgIcon,
        width: 20,
        height: 20,
      ),
      title: 'Government ID Verify',
      status: state == IdentityVerificationState.pending ? VerificationCardStatus.pending : VerificationCardStatus.unverified,
      // The verification screen refreshes status and /auth/me itself.
      onTap: () => context.pushNamed(Routes.identityVerification),
    );
  }
}
