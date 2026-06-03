import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/icon_text_row.dart';
import 'package:walima_llc/core/global/components/popular_badge.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/features/plans/data/models/get_plans_response.dart';
import 'package:intl/intl.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({
    super.key,
    required this.packageName,
    required this.buttonOnTap,
    required this.plan,
    required this.isButtonDisabled,
    required this.buttonTitle,
  });

  static const List<String> _summaryFeatureKeys = <String>[
    'daily_profile_view',
    'daily_matches',
    'send_message',
    'reply_message',
    'receive_message_full',
  ];

  static final NumberFormat _moneyFormatter = NumberFormat('#,##0.##');

  final String packageName;
  final VoidCallback buttonOnTap;
  final Plans plan;
  final bool isButtonDisabled;
  final String buttonTitle;

  Pricings? _firstPricing() {
    final pricings = plan.pricings;
    if (pricings == null || pricings.isEmpty) {
      return null;
    }
    return pricings.first;
  }

  String _billingCycleLabel(String? billingCycle) {
    switch ((billingCycle ?? '').trim().toLowerCase()) {
      case 'monthly':
        return '1 Month';
      case 'quarterly':
        return '3 Months';
      case 'half_yearly':
      case 'half-yearly':
      case 'halfyearly':
        return '6 Months';
      case 'yearly':
      case 'annual':
      case 'annually':
        return '12 Months';
      default:
        return '1 Month';
    }
  }

  String _formatMoneyFromMinor(int? minorValue, String? currency) {
    final majorValue = (minorValue ?? 0) / 100;
    final amountText = _moneyFormatter.format(majorValue);
    final normalized = (currency ?? '').trim().toUpperCase();

    if (normalized.isEmpty || normalized == 'BDT') {
      return '\u09F3 $amountText';
    }

    return '$normalized $amountText';
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  String? _discountLabel(dynamic percentage) {
    final discount = _toDouble(percentage);
    if (discount == null || discount <= 0) {
      return null;
    }
    final formatted = discount % 1 == 0
        ? discount.toStringAsFixed(0)
        : discount.toStringAsFixed(1);
    return '$formatted% OFF';
  }

  List<Features> _summaryFeatures() {
    final features = plan.features;
    if (features == null || features.isEmpty) {
      return const <Features>[];
    }

    final sorted = List<Features>.from(features)
      ..sort(
        (a, b) =>
            (a.displayOrder ?? 1 << 20).compareTo(b.displayOrder ?? 1 << 20),
      );

    final selected = <Features>[];
    for (final key in _summaryFeatureKeys) {
      Features? found;
      for (final feature in sorted) {
        if ((feature.key ?? '').trim() == key) {
          found = feature;
          break;
        }
      }
      if (found != null) {
        selected.add(found);
      }
    }

    if (selected.isNotEmpty) {
      return selected;
    }

    return sorted.take(5).toList();
  }

  String _featureLabel(Features feature, BuildContext context) {
    final name = (feature.name ?? '').trim();
    final baseName = name.isEmpty ? 'Feature' : name;

    if (feature.included != true) {
      return baseName.localized(context);
    }

    final isCounter =
        (feature.valueType ?? '').trim().toLowerCase() == 'counter';
    if (!isCounter) {
      return baseName.localized(context);
    }

    final limit = int.tryParse((feature.limit ?? '').trim());
    final unlimited = (feature.isUnlimited ?? false) || limit == -1;

    if (unlimited) {
      return '${baseName.localized(context)} ${'Unlimited'.localized(context)}';
    }

    if (limit != null && limit > 0) {
      return '${baseName.localized(context)} ${'up to'.localized(context)} $limit';
    }

    return baseName.localized(context);
  }

  _PackagePalette _resolvePalette(String? tag) {
    final normalized = (tag ?? '').trim().toLowerCase();
    switch (normalized) {
      case 'best value':
        return const _PackagePalette(
          accentColor: Color(0xFFF43F5E),
          badgeBackgroundColor: Color(0xFFFFE4E6),
        );
      case 'recommended':
        return const _PackagePalette(
          accentColor: Color(0xFF7C3AED),
          badgeBackgroundColor: Color(0xFFEDE9FE),
        );
      case 'elite':
        return const _PackagePalette(
          accentColor: Color(0xFFF97316),
          badgeBackgroundColor: Color(0xFFFFEDD5),
        );
      case 'ultimate':
        return const _PackagePalette(
          accentColor: Color(0xFF0EA5E9),
          badgeBackgroundColor: Color(0xFFE0F2FE),
        );
      case 'popular':
      default:
        return const _PackagePalette(
          accentColor: AppColors.primary,
          badgeBackgroundColor: AppColors.primaryVariant,
        );
    }
  }

  void _showAllFeaturesDialog(BuildContext context, List<Features> allFeatures) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'All Features',
            style: TextStyle(
              fontSize: TextSize.font18(context),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: allFeatures
                  .map(
                    (feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: IconTextRow(
                        imagePath: feature.included ?? false ? AppImages.check : AppImages.cancelSvgIcon,
                        text: _featureLabel(feature, dialogContext),
                        availableOption: feature.included ?? false,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final pricing = _firstPricing();
    final palette = _resolvePalette(plan.tag);
    final displayName = (plan.name ?? packageName).trim();
    final billingCycle = _billingCycleLabel(pricing?.billingCycle);
    final originalTotal = pricing?.price;
    final discountedTotal = pricing?.actualPrice ?? pricing?.price;
    final discountedPerMonth = pricing?.actualPerMonthPrice;
    final discountText = _discountLabel(pricing?.effectiveDiscountPercentage);
    final summaryFeatures = _summaryFeatures();

    final showOriginalPrice = originalTotal != null &&
        discountedTotal != null &&
        originalTotal > discountedTotal;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: [10, 5],
            strokeWidth: 2,
            padding: const EdgeInsets.all(0),
            color: palette.accentColor,
            radius: const Radius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Column(
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$displayName / ',
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                          style: TextStyle(
                            fontSize: TextSize.font18(context),
                            fontWeight: FontWeight.w600,
                            color: palette.accentColor,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            billingCycle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: TextSize.font16(context),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (showOriginalPrice || discountText != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (showOriginalPrice)
                            Text(
                              _formatMoneyFromMinor(
                                originalTotal,
                                pricing?.currency,
                              ),
                              style: TextStyle(
                                fontSize: TextSize.font16(context),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondaryLight,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          if (showOriginalPrice && discountText != null)
                            const SizedBox(width: 8),
                          if (discountText != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F7ED),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                discountText,
                                style: TextStyle(
                                  fontSize: TextSize.font12(context),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.greenButtonColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    Text(
                      _formatMoneyFromMinor(discountedTotal, pricing?.currency),
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: TextStyle(
                        fontSize: TextSize.font36(context),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      '${_formatMoneyFromMinor(discountedPerMonth, pricing?.currency)} / ${'month'.localized(context)}',
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: TextStyle(
                        fontSize: TextSize.font16(context),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButtons(
                  buttonStyle: isButtonDisabled
                      ? ButtonsStyle.disableButton
                      : ButtonsStyle.activePrimaryButton,
                  onTap: buttonOnTap,
                  title: buttonTitle,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...summaryFeatures.take(4).map(
                          (feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: IconTextRow(
                              imagePath: feature.included ?? false ? AppImages.check : AppImages.cancelSvgIcon,
                              text: _featureLabel(feature, context),
                              availableOption: feature.included ?? false,
                            ),
                          ),
                        ),
                        if (plan.features!.length > 5)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: InkWell(
                              onTap: () => _showAllFeaturesDialog(context, plan.features!),
                              child: Text(
                                'view all features',
                                style: TextStyle(
                                  color: palette.accentColor,
                                  fontSize: TextSize.font13(context),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: -10,
          top: 22,
          child: PopularBadge(
            badgeText: plan.tag ?? 'Premium',
            badgeBackgroundColor: palette.badgeBackgroundColor,
            badgeIcon: AppImages.flagSvgIcon,
            badgeThemeColor: palette.accentColor,
          ),
        ),
      ],
    );
  }
}

class _PackagePalette {
  const _PackagePalette({
    required this.accentColor,
    required this.badgeBackgroundColor,
  });

  final Color accentColor;
  final Color badgeBackgroundColor;
}
