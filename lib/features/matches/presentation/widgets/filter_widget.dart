import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class FilterWidget extends StatelessWidget {

  const FilterWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap,
    this.iconPath,
    this.customIcon,
    this.iconSize,
    this.iconColor,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.spacing,
    this.itemSpacing,
    this.padding,
    this.selectionStyleBuilder,
    this.isSelectedChecker,
    this.titleExtractor,
  });

  final String title;
  final String? iconPath;
  final Widget? customIcon;
  final double? iconSize;
  final Color? iconColor;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final List<FilterItem> items;
  final Function(int) onItemTap;
  final double? spacing;
  final double? itemSpacing;
  final EdgeInsetsGeometry? padding;
  final SelectionStyle Function(bool isSelected)? selectionStyleBuilder;
  final bool Function(FilterItem)? isSelectedChecker;
  final String Function(FilterItem)? titleExtractor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconSize = iconSize ?? TextSize.font20(context);
    final effectiveTitleColor = titleColor ?? AppColors.textPrimaryLight;
    final effectiveTitleFontSize = titleFontSize ?? TextSize.font14(context);
    final effectiveTitleFontWeight = titleFontWeight ?? FontWeight.w500;
    final effectiveSpacing = spacing ?? 8.0;
    final effectiveItemSpacing = itemSpacing ?? 16.0;
    final effectivePadding = padding ?? EdgeInsets.zero;

    return Padding(
      padding: effectivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: effectiveSpacing,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (customIcon != null)
                customIcon!
              else if (iconPath != null)
                ShowImage(
                  imagePath: iconPath!,
                  width: effectiveIconSize,
                  height: effectiveIconSize,
                  color: iconColor ?? effectiveTitleColor,
                ),
              Text(
                title,
                style: TextStyle(
                  fontSize: effectiveTitleFontSize,
                  fontWeight: effectiveTitleFontWeight,
                  color: effectiveTitleColor,
                ),
              ),
            ],
          ),

          SizedBox(height: effectiveItemSpacing),

          // Sort Items List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = isSelectedChecker?.call(item) ??
                  (item.isSelected);
              final titleText = titleExtractor?.call(item) ??
                  (item.name);

              return Padding(
                padding: EdgeInsets.only(bottom: effectiveItemSpacing),
                child: SelectionCard(
                  buttonStyle: selectionStyleBuilder?.call(isSelected) ??
                      (isSelected
                          ? SelectionStyle.selectedRadio
                          : SelectionStyle.unSelectedRadio),
                  noBorder: true,
                  radiaBackgroundColor: AppColors.transparent,
                  onTap: () => onItemTap(index),
                  isSelected: isSelected,
                  title: titleText,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FilterItem {
  const FilterItem({
    required this.name,
    this.isSelected = false,
    this.value,
  });
  final String name;
  final bool isSelected;
  final dynamic value;
}

class FilterModel<T> {

  const FilterModel({
    required this.name,
    this.isSelected = false,
    this.value,
  });
  final String name;
  final bool isSelected;
  final T? value;
}