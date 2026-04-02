import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/notificaiton_provider.dart';

class NotificationIconWithBadge extends ConsumerStatefulWidget {
  const NotificationIconWithBadge({super.key, this.onNotificationPressed});
  final VoidCallback? onNotificationPressed;
  @override
  ConsumerState<NotificationIconWithBadge> createState() => _NotificationIconWithBadgeState();
}

class _NotificationIconWithBadgeState extends ConsumerState<NotificationIconWithBadge> {
  late NotificationProvider provider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = ref.read(notiProvider);
      provider.getNotificationCount();
    });
  }

  @override
  Widget build(BuildContext context) {
      provider = ref.watch(notiProvider);
      if(provider.totalUnreadCount == '0') {
        return InkWell(
          onTap: widget.onNotificationPressed,
          child:  Padding(
            padding: const EdgeInsets.all(7),
            child: ShowImage(
              imagePath: AppImages.notificationSvgIcon,
              color: AppColors.textPrimaryLight,
              height:  TextSize.font22(context),
              width:  TextSize.font24(context),
            ),
          ),
        );
      }

    return InkWell(
      onTap: widget.onNotificationPressed,
      child: Stack(
        children: [
           Padding(
            padding: const EdgeInsets.all(7),
            child: ShowImage(
              imagePath: AppImages.notificationSvgIcon,
              color: AppColors.textPrimaryLight,
              height:  TextSize.font22(context),
              width:  TextSize.font24(context),
            ),
          ),
          Positioned(
            left: 12,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(provider.totalUnreadCount,
                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TextSize.font10(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),),
        ],
      ),
    );
  }
}

















