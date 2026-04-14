import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/app_drawer.dart';
import 'package:flutter_boilerplate/features/notification/presentation/notification_icon_with_badge.dart';

class AnchoredAppBar extends StatelessWidget implements PreferredSizeWidget {

  const AnchoredAppBar({
    super.key,
    required this.context,
    required this.title,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onSafetyPressed,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.leadingWidth,
    this.showNotification = true,
    this.notificationCount = 0,
    this.tabIndex,
  });
  final BuildContext context;
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onSafetyPressed;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? leadingWidth;
  final bool showNotification;
  final double? notificationCount;
  final int? tabIndex;

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = iconColor ?? AppColors.textPrimaryLight;
    final defaultIconSize = iconSize ?? 20.0;
    final defaultLeadingWidth = leadingWidth ?? 40.0;

    return AppBar(
      leadingWidth: defaultLeadingWidth,
      leading: IconButton(
        icon: ShowImage(
          imagePath: AppImages.menuSvgIcon,
          color: defaultIconColor,
          height: defaultIconSize,
          width: defaultIconSize,
        ),
        onPressed: onMenuPressed ?? _openDrawerOverNav,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimaryLight,
          fontSize: TextSize.font18(context),
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        if (showNotification && tabIndex != 3)
          NotificationIconWithBadge(
            onNotificationPressed: onNotificationPressed,
         ),

        if (tabIndex != null && tabIndex == 3)
          InkWell(
            onTap: onSafetyPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ShowImage(
                imagePath: AppImages.safetySvgIcon,
                color: defaultIconColor,
                height: defaultIconSize,
                width: defaultIconSize,
              ),
            ),
          ),
      ],
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    );
  }

  void _openDrawerOverNav() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Drawer',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        // Full screen container (no SafeArea) so the drawer overlays the status/notification bar
        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context)
                .size
                .height, // full height to cover status bar
            child: const Material(
              color: Colors.transparent,
              child: AppDrawer(),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}