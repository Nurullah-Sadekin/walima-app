import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class IconTextRow extends StatelessWidget {
  const IconTextRow({
    super.key,
    required this.imagePath,
    required this.text,
    this.textColor,
    this.imageColor,
    this.textSize,
    this.imageSize,
    this.spacing = 8.0,
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.expandText = false,
    this.textStyle,
    this.availableOption,
  });

  final String imagePath;
  final String text;
  final Color? textColor;
  final Color? imageColor;
  final double? textSize;
  final double? imageSize;
  final double spacing;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool expandText;
  final TextStyle? textStyle;
  final bool? availableOption;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: spacing,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        ShowImage(
          imagePath: imagePath,
          width: imageSize ?? TextSize.font16(context),
          height: imageSize ?? TextSize.font16(context),
          color: availableOption == null
              ? AppColors.hintTextColor
              : availableOption == true
                  ? AppColors.success
                  : AppColors.primary,
        ),

          Flexible(
            child: Text(
              text,
              textAlign: textAlign,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
              style: textStyle ??
                  TextStyle(
                    fontSize: textSize ?? TextSize.font12(context),
                    fontWeight: fontWeight,
                    decoration: availableOption == false ? TextDecoration.lineThrough : null,
                    decorationColor: availableOption == false ? AppColors.hintTextColor : null,
                    decorationThickness: availableOption == false ? 1 : null,
                    color: availableOption == null
                        ? AppColors.textSecondaryLight
                        : availableOption == true
                        ? AppColors.textPrimaryLight
                        : AppColors.hintTextColor,
                  ),
            ),
          ),
      ],
    );
  }
}
