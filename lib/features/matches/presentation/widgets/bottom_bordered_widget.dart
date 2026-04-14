
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
class BottomBorderedWidget extends StatelessWidget {

  const BottomBorderedWidget({
    super.key,
    required this.widget,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.borderRadius,
  });


  final Widget widget;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: padding ?? const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 8.0,
        top: 16.0,
      ),
      decoration:  BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        border: Border(
          top: BorderSide(
            color: borderColor ?? AppColors.greyLight,
            width: borderWidth ?? 1,
          ),
        ),
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [widget],
      ),
    );

    return container;
  }
}