import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/profile_avatar_with_name.dart';

class ChatListItem extends StatelessWidget {

  const ChatListItem({
    super.key,
    required this.name,
    this.imagePath,
    required this.lastMessage,
    required this.timeAgo,
    this.isVerified = false,
    this.onTap,
  });
  final String name;
  final String? imagePath;
  final String lastMessage;
  final String timeAgo;
  final bool isVerified;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ProfileAvatarWithName(
            imagePath: imagePath ?? AppImages.demoProfile2,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildNameRow(context),
                const SizedBox(height: 4),
                _buildMessageRow(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameRow(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: TextSize.font18(context),
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isVerified) ...[
          const SizedBox(width: 4),
          ShowImage(
            imagePath: AppImages.verifiedBadgeSvgIcon,
            width: TextSize.font14(context),
            height: TextSize.font14(context),
          ),
        ],
      ],
    );
  }

  Widget _buildMessageRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      spacing: 8,
      children: [
        Flexible(
          child: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: TextSize.font14(context),
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.circle,
              size: 4,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 10),
            Text(
              timeAgo,
              style: TextStyle(
                fontSize: TextSize.font14(context),
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}