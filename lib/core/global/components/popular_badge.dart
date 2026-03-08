import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class PopularBadge extends StatelessWidget {
  const PopularBadge({
    super.key,
    this.badgeText,
    this.badgeBackgroundColor,
    this.badgeIcon,
    this.badgeThemeColor,
  });

  final String? badgeText;
  final Color? badgeBackgroundColor;
  final String? badgeIcon;
  final Color? badgeThemeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: badgeBackgroundColor ?? AppColors.primaryVariant,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(2),
              bottomRight: Radius.circular(2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShowImage(
                imagePath: badgeIcon ?? AppImages.matchSvgIcon,
                height: TextSize.font12(context),
                width: TextSize.font12(context),
                color: badgeThemeColor ?? AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                badgeText ?? 'Recommended',
                style: TextStyle(
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w500,
                  color: badgeThemeColor ?? AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
        /// Triangle ribbon
        CustomPaint(
          size: const Size(10, 10),
          painter: TrianglePainter(
            color: badgeThemeColor ?? const Color(0xffD1D5DB),
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({this.color = const Color(0xffD1D5DB)});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}