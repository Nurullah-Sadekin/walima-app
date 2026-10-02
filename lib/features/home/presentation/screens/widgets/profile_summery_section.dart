import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/profile_summary_card.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/utils/picker_dialog.dart';
import 'package:walima_llc/features/identity_verification/data/models/identity_verification_models.dart';
import 'package:walima_llc/features/profile/presentation/utils/profile_summary_utils.dart';
import 'package:walima_llc/features/profile/data/model/response/dashboard_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileSummerySection extends ConsumerWidget {
  const ProfileSummerySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(profileProvider);
    final DashboardData? dashboard = provider.dashboard;

    if (dashboard == null) {
      return const SizedBox.shrink();
    }

    final profile = dashboard.profile;
    final displayName = resolveDisplayName(profile);
    final memberId = resolveMemberId(profile);
    final planName = resolvePlanName(profile?.membership);
    final expiryText = formatExpiry(profile?.membership?.membershipExpiresAt);
    final gender = ref.read(globalProvider).currentUser?.gender;
    // Verified badge = identity approved per GET /verification/status.
    final isIdentityVerified = ref.watch(
      identityVerificationProvider.select(
        (p) => p.statusData?.state == IdentityVerificationState.approved,
      ),
    );

    return Column(
      children: [
        ProfileSummaryCard(
          displayName: displayName,
          memberId: memberId,
          planName: planName,
          expiryText: expiryText,
          profileImagePath: profile?.profilePicture?.url ?? (gender == 'female' ? AppImages.womenAvatar : AppImages.manAvatar),
          showTopIcon: isIdentityVerified,
          showBottomIcon: true,
          topIconPath: AppImages.verifiedBadgeSvgIcon,
          bottomIconPath: AppImages.cameraSvgIcon,
          onTapImage: () async {
            await DialogUtils.showFullScreenImage(context: context, imagePath: profile?.profilePicture?.url ?? (gender == 'female' ? AppImages.womenAvatar : AppImages.manAvatar));
          },
          onBottomIconPressed: () async {
            final String? imagePath = await PickerDialog().imagePicker(context);
            if (!context.mounted) return;
            if (imagePath != null) {
              await provider.updateProfileImage(
                context: context,
                filePath: imagePath,
              );
              await ref
                  .read(homeProvider)
                  .invalidateAndRefreshProfileStrength();
            }
          },
        ),
        const SizedBox(height: 16),
        _headerActions(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _headerActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            textColor: AppColors.textSecondaryLight,
            bgColor: AppColors.white,
            borderColor: AppColors.greyLight,
            svgIconPath: AppImages.editProfileSvgIcon,
            svgIconColor: AppColors.textSecondaryLight,
            iconLeftPosition: false,
            onTap: () {
              context.pushNamed(Routes.editProfile);
            },
            title: 'Edit Profile',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            textColor: AppColors.white,
            bgColor: AppColors.primary,
            svgIconPath: AppImages.premiumSvgIcon,
            iconLeftPosition: false,
            onTap: () {
              context.pushNamed(
                Routes.upgradePackage,
                extra: Routes.anchor,
              );
            },
            title: 'Upgrade Plan',
          ),
        ),
      ],
    );
  }
}
