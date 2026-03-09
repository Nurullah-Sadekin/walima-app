import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomBackAppBar({
    super.key,
    this.backgroundColor = Colors.transparent,
    this.elevation = 0,
    this.iconColor,
    this.iconSize,
    this.onBackPressed,
    this.title,
    this.leadingPadding = 12.0,
    this.isTrailing = false,
    this.trailingText,
    this.onTrailingTap,
    this.isBackButton = true,
    this.backOnTap,
    this.backCancelMood = false,
  });
  final Color? backgroundColor;
  final double? elevation;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onBackPressed;
  final Widget? title;
  final double? leadingPadding;
  final bool? isTrailing;
  final String? trailingText;
  final VoidCallback? onTrailingTap;
  final bool isBackButton;
  final VoidCallback? backOnTap;
  final bool backCancelMood;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AppBar(
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: elevation ?? 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        title: title,
        leading: isBackButton ? Padding(
          padding: EdgeInsets.all(leadingPadding ?? 12.0),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: onBackPressed ??
                    () {
                      Navigator.pop(context);
                    },
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  backCancelMood ? Icons.clear : Icons.arrow_back_ios_new_rounded,
                  size: backCancelMood== true ? TextSize.font18(context) : iconSize ??  TextSize.font16(context),
                  color: iconColor ?? AppColors.textSecondaryLight,
                ),
              ),
            ),
          ),
        ) : null,
        centerTitle: true,
        actions: isTrailing == true
            ? [
                InkWell(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: onTrailingTap,
                  child: Padding(
                    padding: EdgeInsets.all(leadingPadding ?? 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          trailingText ?? '',
                          style: TextStyle(
                            fontSize: TextSize.font14(context),
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: iconSize ?? TextSize.font14(context),
                          color: iconColor ?? AppColors.textSecondaryLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
