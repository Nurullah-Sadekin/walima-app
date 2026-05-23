import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/camel_case_utils.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/profile_preview/data/models/profile_compare_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreferenceMatchCard extends ConsumerWidget {
  const PreferenceMatchCard({
    super.key,
    required this.data,
    this.ownerGender,
    this.matchImage,
    this.otherImage,
  });

  final ProfileCompareData data;
  final String? ownerGender;
  final String? matchImage;
  final String? otherImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userImage =
        ref.watch(globalProvider).currentUser?.profilePicture?.url ??
            matchImage;
    final items = data.audit;
    final matchedCount = data.matchedCount ?? 0;
    final totalCount = data.totalCriteria ?? items.length;
    final percentage = data.matchPercentage ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            title: 'Preferences Analysis',
            subtitle: data.verdict ?? 'Seeking a genuine connection',
          ),
          const SizedBox(height: 20),
          _MatchSummary(
            percentage: percentage,
            matchedCount: matchedCount,
            totalCount: totalCount,
            matchImage: userImage,
            otherImage: otherImage,
            ownerGender: ownerGender,
          ),
          const SizedBox(height: 18),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No comparison criteria available.'.localized(context),
                style: TextStyle(
                  fontSize: TextSize.font12(context),
                  color: AppColors.textSecondaryLight,
                ),
              ),
            )
          else
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _PreferenceInfoTile(item: item),
                )),
          Center(
            child: Text(
              data.compatibilityLevel != null
                  ? ' ${CamelCaseUtils.formatCamelCase(data.compatibilityLevel)} Compatibility'
                  : 'Compatibility level not available.'.localized(context),
              style: TextStyle(
                fontSize: TextSize.font14(context),
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppColors.primaryVariant,
            border: Border.all(color: AppColors.primaryShade300, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const ShowImage(
            imagePath: AppImages.favouriteIcon,
            fit: BoxFit.cover,
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.localized(context),
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MatchSummary extends StatelessWidget {
  const _MatchSummary({
    required this.percentage,
    required this.matchedCount,
    required this.totalCount,
    this.matchImage,
    this.otherImage,
    this.ownerGender,
  });

  final int percentage;
  final int matchedCount;
  final int totalCount;
  final String? matchImage;
  final String? otherImage;
  final String? ownerGender;

  @override
  Widget build(BuildContext context) {
    final otherFallback = (ownerGender ?? '').toLowerCase() == 'male'
        ? AppImages.manAvatar
        : AppImages.womenAvatar;
    final viewerFallback = (ownerGender ?? '').toLowerCase() == 'male'
        ? AppImages.womenAvatar
        : AppImages.manAvatar;

    return Row(
      children: [
        _AvatarBubble(
          imagePath: (otherImage != null && otherImage!.isNotEmpty)
              ? otherImage!
              : otherFallback,
          alignment: Alignment.centerLeft,
        ),
        const SizedBox(width: 10),
        const Expanded(child: _ConnectorLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ShowImage(
                    imagePath: AppImages.favouriteIcon,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: AppColors.primary,
                  ),
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: TextSize.font15(context),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${'Matched'.localized(context)} $matchedCount/$totalCount',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: _ConnectorLine()),
        const SizedBox(width: 10),
        _AvatarBubble(
          imagePath: (matchImage != null && matchImage!.isNotEmpty)
              ? matchImage!
              : viewerFallback,
          alignment: Alignment.centerRight,
        ),
      ],
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({
    required this.imagePath,
    required this.alignment,
  });

  final String imagePath;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.width * 0.15,
        padding: const EdgeInsets.all(1.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              Color(0xFFFF7AAE),
            ],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: ClipOval(
            child: ShowImage(
              imagePath: imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectorLine extends StatelessWidget {
  const _ConnectorLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.0),
            AppColors.primaryShade300,
            AppColors.primary.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

class _PreferenceInfoTile extends StatelessWidget {
  const _PreferenceInfoTile({required this.item});

  final CompareAuditItem item;

  @override
  Widget build(BuildContext context) {
    final String statusImage =
        item.isMatched ? AppImages.successCircle : AppImages.cancelCircle;
    final Color statusColor = item.isMatched
        ? AppColors.greenButtonColor.withOpacity(0.1)
        : AppColors.error.withOpacity(0.1);
    final label = item.field ?? '-';
    final preferredValue = (item.preferredValue ?? '').trim().isNotEmpty
        ? item.preferredValue!
        : '-';
    final actualValue =
        (item.actualValue ?? '').trim().isNotEmpty ? item.actualValue! : '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  CamelCaseUtils.formatCamelCase(actualValue),
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ShowImage(
                imagePath: statusImage,
                height: TextSize.font18(context),
                width: TextSize.font18(context),
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  CamelCaseUtils.formatCamelCase(preferredValue),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
