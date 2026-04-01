import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class MessageBubble extends StatelessWidget {

  const MessageBubble({
    super.key,
    required this.message,
    this.senderName,
    this.messageStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.showSenderName = false,
    this.senderMessage = true,

  });

  final String message;
  final String? senderName;
  final TextStyle? messageStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool showSenderName;
  final bool senderMessage;


  @override
  Widget build(BuildContext context) {

    final Widget bubbleContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSenderName && senderName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              senderName!,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: TextSize.font12(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Text(
          message,
          style: messageStyle ?? TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w400,
          ),
          textAlign:  TextAlign.left,
        ),
      ],
    );

    Widget container = Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryVariant,
        borderRadius: borderRadius ?? BorderRadius.only(
          topLeft: Radius.circular(senderMessage ? 0 : 12),
          topRight: Radius.circular(senderMessage ? 12 : 0),
          bottomRight: const Radius.circular(12),
          bottomLeft: const Radius.circular(12),
        ),
        border: Border.all(
          color: borderColor ?? AppColors.transparent,
          width: borderWidth ?? 1,
        ),
      ),
      child: bubbleContent,
    );


    return container;
  }
}