import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/profile/presentation/screen/edit_profile.dart';
import 'package:flutter_boilerplate/features/profile/data/model/response/dashboard_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    final displayName = _resolveDisplayName(profile);
    final memberId = _resolveMemberId(profile);
    final planName = _resolvePlanName(profile?.membership);
    final expiryText = _formatExpiry(profile?.membership?.membershipExpiresAt);

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImageCard(
                imagePath: profile?.profilePicture?.url ?? AppImages.demoProfile,
                imageSize: 97,
                iconSize: 20,
                showTopIcon: profile?.isVerified ?? false,
                showBottomIcon: true,
                topPositionImagePath: AppImages.verifiedBadgeSvgIcon,
                bottomPositionImagePath: AppImages.cameraSvgIcon,
                onEdit: () async {
                  await BottomSheetUtils.open(
                    context: context,
                    fullHeight: true,
                    child: const EditProfileScreen(),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _profileDetails(
                  context,
                  displayName: displayName,
                  memberId: memberId,
                  planName: planName,
                  expiryText: expiryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _headerActions(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _profileDetails(
    BuildContext context, {
    required String displayName,
    required String memberId,
    required String planName,
    required String expiryText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          _memberIdChip(context, memberId),
          _subscriptionRow(
            context,
            planName: planName,
            expiryText: expiryText,
          ),
        ],
      ),
    );
  }

  Widget _memberIdChip(BuildContext context, String memberId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ID : $memberId',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.copy_rounded,
            color: AppColors.textSecondaryLight,
            size: TextSize.font12(context),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionRow(
    BuildContext context, {
    required String planName,
    required String expiryText,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            planName,
            style: TextStyle(
              color: AppColors.white,
              fontSize: TextSize.font10(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          expiryText,
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w400,
          ),
        ),
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

  String _resolveDisplayName(Profile? profile) {
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

  String _resolveMemberId(Profile? profile) {
    final reference = profile?.userReference?.trim();
    if (reference != null && reference.isNotEmpty) {
      return reference;
    }
    return '--';
  }

  String _resolvePlanName(Membership? membership) {
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

  String _formatExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expires: --';
    }

    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) {
      return 'Expires: --';
    }

    return 'Expires: ${DateFormat('MMMM yyyy').format(date)}';
  }
}
