import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/plans/data/models/get_plans_response.dart';
import 'package:walima_llc/features/plans/data/models/upgrade_quote_response.dart';
import 'package:intl/intl.dart';

class OrderSummaryBottomSheet extends StatefulWidget {
  const OrderSummaryBottomSheet({
    super.key,
    required this.plan,
    this.upgradeQuote,
  });

  final Plans plan;
  final UpgradeQuoteData? upgradeQuote;

  @override
  State<OrderSummaryBottomSheet> createState() => _OrderSummaryBottomSheetState();
}

class _OrderSummaryBottomSheetState extends State<OrderSummaryBottomSheet> {
  static final NumberFormat _moneyFormatter = NumberFormat('#,##0.00');
  static const int _contributionAmount = 9900;

  bool _includeContribution = true;

  Pricings? get _pricing {
    final pricings = widget.plan.pricings;
    if (pricings == null || pricings.isEmpty) {
      return null;
    }
    return pricings.first;
  }

  String get _planTitle {
    final planName = (widget.plan.name ?? 'Plan').trim();
    return '$planName / ${_billingCycleLabel(_pricing?.billingCycle)}';
  }

  int get _baseAmount => _pricing?.actualPrice ?? _pricing?.price ?? 0;

  int get _quoteBaseAmount => widget.upgradeQuote?.baseTargetAmount ?? _baseAmount;

  int get _creditAmount => widget.upgradeQuote?.creditAmount ?? 0;

  bool get _isUpgradeMode => widget.upgradeQuote != null;

  int get _discountAmount {
    final original = _pricing?.price ?? 0;
    final actual = _pricing?.actualPrice ?? original;
    final discount = original - actual;
    return discount > 0 ? discount : 0;
  }

  int get _totalAmount =>
      (_isUpgradeMode
              ? widget.upgradeQuote?.payableAmount ?? _quoteBaseAmount
              : _baseAmount) +
      (_isUpgradeMode
          ? 0
          : (_includeContribution ? _contributionAmount : 0));

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

  String _formatMoney(int minorAmount, String? currency) {
    final amountText = _moneyFormatter.format(minorAmount / 100);
    final normalizedCurrency = (currency ?? '').trim().toUpperCase();

    if (normalizedCurrency.isEmpty || normalizedCurrency == 'BDT') {
      return '\u09F3 $amountText';
    }

    return '$normalizedCurrency $amountText';
  }

  @override
  Widget build(BuildContext context) {
    final pricing = _pricing;
    final currency = pricing?.currency;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.primaryVariant,
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Order Summary',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: TextSize.font20(context),
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF8E8F0),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 16, 12, bottomInset + 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SummaryAmountRow(
                  label: _planTitle,
                  amount: _formatMoney(
                    _isUpgradeMode ? _quoteBaseAmount : _baseAmount,
                    currency,
                  ),
                ),
                if (_isUpgradeMode) ...[
                  const SizedBox(height: 18),
                  _SummaryAmountRow(
                    label: 'Credit (unused days)',
                    amount: '- ${_formatMoney(_creditAmount, currency)}',
                    labelColor: const Color(0xFF008A2E),
                    amountColor: const Color(0xFF008A2E),
                  ),
                  // const SizedBox(height: 28),
                  // _SummaryAddonTile(
                  //   checked: _includeContribution,
                  //   title: 'Contribute to Walima.com',
                  //   amount: '+ ${_formatMoney(_contributionAmount, currency)}',
                  //   enabled: true,
                  //   showTopBorder: false,
                  //   onTap: () {
                  //     setState(() {
                  //       _includeContribution = !_includeContribution;
                  //     });
                  //   },
                  // ),
                ] else ...[
                  const SizedBox(height: 18),
                  _SummaryAmountRow(
                    label: 'Discount',
                    amount: '- ${_formatMoney(_discountAmount, currency)}',
                  ),
                  const SizedBox(height: 28),
                  _SummaryAddonTile(
                    checked: false,
                    title: 'Promote My Profile',
                    badge: 'ADD-ONS',
                    amount: _formatMoney(49900, currency),
                    enabled: false,
                    showTopBorder: false,
                  ),
                  _SummaryAddonTile(
                    checked: _includeContribution,
                    title: 'Contribute to Walima.com',
                    amount: '+ ${_formatMoney(_contributionAmount, currency)}',
                    enabled: true,
                    onTap: () {
                      setState(() {
                        _includeContribution = !_includeContribution;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 26),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.greyLight,
                ),
                const SizedBox(height: 22),
                _SummaryAmountRow(
                  label: 'Total Amount',
                  amount: _formatMoney(_totalAmount, currency),
                  isTotal: true,
                  amountColor:
                      _isUpgradeMode ? AppColors.primary : AppColors.textPrimaryLight,
                ),
                const SizedBox(height: 34),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButtons(
                    buttonStyle: ButtonsStyle.activePrimaryButton,
                    title: _isUpgradeMode ? 'Continue to Pay' : 'Proceed To Pay',
                    onTap: () => Navigator.of(context).pop(true),
                  ),
                ),
                // const SizedBox(height: 12),
                // Center(
                //   child: Container(
                //     width: 120,
                //     height: 5,
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFD9D9D9),
                //       borderRadius: BorderRadius.circular(99),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryAmountRow extends StatelessWidget {
  const _SummaryAmountRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.labelColor,
    this.amountColor,
  });

  final String label;
  final String amount;
  final bool isTotal;
  final Color? labelColor;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: isTotal ? TextSize.font18(context) : TextSize.font18(context),
      fontWeight: FontWeight.w500,
      height: 1.25,
      letterSpacing: -0.2,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: baseStyle.copyWith(
              color: labelColor ?? AppColors.textPrimaryLight,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          amount,
          textAlign: TextAlign.right,
          style: baseStyle.copyWith(
            color: amountColor ?? AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}

class _SummaryAddonTile extends StatelessWidget {
  const _SummaryAddonTile({
    required this.checked,
    required this.title,
    required this.amount,
    required this.enabled,
    this.showTopBorder = true,
    this.badge,
    this.onTap,
  });

  final bool checked;
  final String title;
  final String amount;
  final bool enabled;
  final bool showTopBorder;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = enabled
        ? AppColors.textPrimaryLight
        : AppColors.textSecondaryLight.withValues(alpha: 0.7);
    final amountColor = enabled
        ? AppColors.textPrimaryLight
        : AppColors.disableText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            border: Border(
              top: showTopBorder
                  ? const BorderSide(color: AppColors.greyLight, width: 1)
                  : BorderSide.none,
              bottom: const BorderSide(color: AppColors.greyLight, width: 1),
            ),
          ),
          child: Row(
            children: [
              ShowImage(
                imagePath: checked
                    ? AppImages.selectedCheckbox
                    : AppImages.unselectedCheckbox,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9E6FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            color: const Color(0xFF1D3F91),
                            fontSize: TextSize.font12(context),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amount,
                style: TextStyle(
                  color: amountColor,
                  fontSize: TextSize.font18(context),
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
