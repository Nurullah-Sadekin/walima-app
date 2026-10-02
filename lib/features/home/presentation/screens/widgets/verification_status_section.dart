import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/account_setting/presentation/screens/widgets/phone_verification_status_tile.dart';
import 'package:walima_llc/features/identity_verification/data/models/identity_verification_models.dart';

/// Home "Complete Your Profile" block with the Government ID and phone
/// verification cards. Each card hides once verified; the whole section
/// hides once both are.
class VerificationStatusSection extends ConsumerWidget {
  const VerificationStatusSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(globalProvider.select((p) => p.currentUser));
    if (user == null) return const SizedBox.shrink();

    final isIdVerified =
        watchIdentityDisplayState(ref) == IdentityVerificationState.approved;
    final isPhoneVerified = user.isPhoneVerified ?? false;
    if (isIdVerified && isPhoneVerified) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                'Complete Your Profile'.localized(context),
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Complete profiles get 2x more matches'.localized(context),
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font10(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          // Only unverified items are shown (avoids empty gaps in `spacing`).
          if (!isIdVerified) const GovernmentIdVerificationStatusTile(),
          if (!isPhoneVerified) const PhoneVerificationStatusTile(),
        ],
      ),
    );
  }
}
