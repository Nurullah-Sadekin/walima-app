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
    this.isVerified,
    this.onTap,
    this.isOnline,
    this.unReadMessage,
    this.isTyping = false,
  });
  final String name;
  final String? imagePath;
  final String lastMessage;
  final String timeAgo;
  final bool? isVerified;
  final VoidCallback? onTap;
  final bool? isOnline;
  final bool? unReadMessage;
  final bool isTyping;

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
            indicatorColor:
                isOnline == true ? AppColors.greenButtonColor : Colors.red,
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
        Expanded(
          child: Row(
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
              if (isVerified == true) ...[
                const SizedBox(width: 4),
                ShowImage(
                  imagePath: AppImages.verifiedBadgeSvgIcon,
                  width: TextSize.font14(context),
                  height: TextSize.font14(context),
                ),
              ],
            ],
          ),
        ),
        if (unReadMessage == true)
          const Icon(
            Icons.circle,
            size: 10,
            color: AppColors.primary,
          ),
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
            isTyping ? 'Typing...' : lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: TextSize.font14(context),
              color:
                  isTyping ? AppColors.primary : AppColors.textSecondaryLight,
              fontWeight: isTyping ? FontWeight.w600 : FontWeight.w400,
              fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
        if (!isTyping)
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
