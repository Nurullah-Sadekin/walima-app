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
    this.actions,
    this.title,
    this.leadingPadding = 12.0,
  });
  final Color? backgroundColor;
  final double? elevation;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? title;
  final double? leadingPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: AppBar(
        backgroundColor: backgroundColor,
        elevation: elevation,
        title: title,
        actions: actions,
        leading: Padding(
          padding: EdgeInsets.all(leadingPadding ?? 12.0),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: onBackPressed ?? () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: iconSize ?? TextSize.font16(context),
                  color: iconColor ?? AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}