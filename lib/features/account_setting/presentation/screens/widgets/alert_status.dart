import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/account_setting/presentation/screens/widgets/card_border.dart';

class AlertStatus extends StatelessWidget {

  const AlertStatus({
    super.key,
    required this.alertStatusList,
    this.title,
    this.imagePath,
    this.onStatusTap,
  });

  final List<AlertStatusItem> alertStatusList;
  final String? title;
  final String? imagePath;
  final Function(int index)? onStatusTap;

  @override
  Widget build(BuildContext context) {
    return CardBorder(
      widget: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Row(
              spacing: 8,
              children: [
                 CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryVariant,
                  child: ShowImage(
                    imagePath: imagePath ?? AppImages.emailSvgIcon,
                    width: TextSize.font18(context),
                    height: TextSize.font18(context),
                    color: AppColors.primary,
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ??  'Premium Visitors Email',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: TextSize.font15(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: alertStatusList.asMap().entries.map((entry) {
                int index = entry.key;
                AlertStatusItem item = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SelectionCard(
                    buttonStyle: item.isSelected == true ? SelectionStyle.selectedRadio : SelectionStyle.unSelectedRadio ,
                    noBorder: true,
                    radiaBackgroundColor: AppColors.transparent,
                    onTap: () {
                      if (onStatusTap != null) {
                        onStatusTap!(index);
                      }
                    },
                    isSelected: item.isSelected ?? false,
                    title: item.label,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for alert status item
class AlertStatusItem {

  AlertStatusItem({
    required this.label,
    this.isSelected = false,
  });
  final String label;
  final bool? isSelected;
}