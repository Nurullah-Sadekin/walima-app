import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/utils/clipboard_utils.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';

/// Reusable profile info card used in EditProfileScreen.
/// Supports either a free-form `child` or a list of key/value pairs via `infoList`.
class ProfileViewCard extends StatelessWidget {
  const ProfileViewCard({
    super.key,
    required this.title,
    this.subtitle,
    this.iconPath,
    this.userId,
    this.copyUserIdOnTap,
    this.profileManageStatus,
    this.child,
    this.infoList,
    this.itemList,
  }) : assert(child != null || infoList != null || itemList != null,
            'Either child or infoList must be provided');

  final String title;
  final String? subtitle;
  final String? iconPath;
  final String? userId;
  final VoidCallback? copyUserIdOnTap;
  final String? profileManageStatus;
  final Widget? child;
  final List<MapEntry<String, String>>? infoList;
  final List<String>? itemList;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: userId == null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: AppColors.primaryVariant,
                          border: Border.all(
                              color: AppColors.primaryShade300, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ShowImage(
                          imagePath: iconPath ?? AppImages.profileSvgIcon,
                          color: AppColors.primary,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: TextSize.font14(context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            subtitle ?? '',
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: TextSize.font12(context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: TextSize.font14(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: copyUserIdOnTap ??
                                ((userId == null || userId!.isEmpty)
                                    ? null
                                    : () => ClipboardUtils.copyWithSnack(
                                        context, userId)),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.greyLight, width: 1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              child: Row(
                                spacing: 4,
                                children: [
                                  Text(
                                    'ID: $userId',
                                    style: TextStyle(
                                      color: AppColors.textSecondaryLight,
                                      fontSize: TextSize.font12(context),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  ShowImage(
                                    imagePath: AppImages.copy,
                                    width: TextSize.font14(context),
                                    height: TextSize.font14(context),
                                    color: AppColors.textSecondaryLight,
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (profileManageStatus != null)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.greyLight, width: 1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              child: Text(
                                profileManageStatus ?? '',
                                style: TextStyle(
                                  color: AppColors.textSecondaryLight,
                                  fontSize: TextSize.font12(context),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
          ),
          if (child != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: child,
            )
          else if (infoList != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: infoList!.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${entry.key}:',
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: TextSize.font12(context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            entry.value,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: TextSize.font12(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
           if (itemList != null)
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
               child: Wrap(
                 spacing: 8,
                 runSpacing: 8,
                 alignment: WrapAlignment.start,
                 crossAxisAlignment: WrapCrossAlignment.start,
                 children: itemList!.map((item) {
                   return Container(
                     decoration: BoxDecoration(
                       border: Border.all(color: AppColors.greyLight, width: 1),
                       borderRadius: BorderRadius.circular(100),
                     ),
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                     child: Text(
                       item,
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                         color: AppColors.textPrimaryLight,
                         fontSize: TextSize.font12(context),
                         fontWeight: FontWeight.w500,
                       ),
                     ),
                   );
                 }).toList(),
               ),
             )
        ],
      ),
    );
  }
}
