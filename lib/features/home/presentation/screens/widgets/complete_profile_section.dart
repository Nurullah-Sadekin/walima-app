import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/verification_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CompleteProfileSection extends ConsumerWidget {
  const CompleteProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(profileProvider);
    final completionPercentage =
        provider.profile?.profileCompletion?.percentage ?? 0;

    if (completionPercentage >= 100) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Complete Your Profile',
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font18(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Complete profiles get 2x more matches',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          VerificationTile(
            iconImagePath: AppImages.verifiedBadgeSvgIcon,
            title: 'Government ID Verify',
            statusText: 'Unverified',
            statusColor: AppColors.primary,
            statusBackgroundColor: AppColors.primaryVariant,
            onTap: () => context.pushNamed(Routes.governmentIdVerify),
          ),
          const SizedBox(height: 10),
          VerificationTile(
            iconImagePath: AppImages.verifyContact,
            title: 'Verify Phone Number',
            statusText: 'Verified',
            statusColor: AppColors.success,
            statusBackgroundColor: AppColors.success.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
  Widget _headerActions() {
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
              // context.push(Paths.editProfile);
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
              // context.push(Paths.upgradePackage);
            },
            title: 'Renew Plan',
          ),
        ),
      ],
    );
  }
}
