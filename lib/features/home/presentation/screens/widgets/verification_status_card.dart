import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

enum VerificationCardStatus { verified, pending, unverified }

/// Bordered row card: leading icon, title, status chip and a chevron.
/// Used by the home "Complete Your Profile" section, drawer and settings.
class VerificationStatusCard extends StatelessWidget {
  const VerificationStatusCard({
    super.key,
    required this.leading,
    required this.title,
    required this.status,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final VerificationCardStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (label, color, background) = switch (status) {
      VerificationCardStatus.verified => (
          'Verified',
          AppColors.greenButtonColor,
          AppColors.greenButtonColor.withValues(alpha: 0.1),
        ),
      VerificationCardStatus.pending => (
          'In Review',
          const Color(0xFFD97706),
          const Color(0xFFFFFBEB),
        ),
      VerificationCardStatus.unverified => (
          'Unverified',
          AppColors.primary,
          AppColors.primaryVariant,
        ),
    };

    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.greyLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              SizedBox.square(dimension: 36, child: Center(child: leading)),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        title.localized(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        label.localized(context),
                        style: TextStyle(
                          color: color,
                          fontSize: TextSize.font10(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: TextSize.font16(context),
                  color: AppColors.hintTextColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
