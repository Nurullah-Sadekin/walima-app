import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

/// Reusable profile info card used in EditProfileScreen.
/// Supports either a free-form `child` or a list of key/value pairs via `infoList`.
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    Key? key,
    required this.title,
    this.showEdit = false,
    this.onEdit,
    this.child,
    this.infoList,
  })  : assert(child != null || infoList != null,
            'Either child or infoList must be provided'),
        super(key: key);
  final String title;
  final bool showEdit;
  final VoidCallback? onEdit;
  final Widget? child;
  final List<MapEntry<String, String>>? infoList;

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
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.localized(context),
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (showEdit)
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: AppColors.greyLight),
                      ),
                      child: Row(
                        children: [
                          ShowImage(
                            imagePath: AppImages.editWrite,
                            width: TextSize.font16(context),
                            height: TextSize.font16(context),
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Edit'.localized(context),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: TextSize.font14(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.greyLight),
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
                            '${entry.key.localized(context)}:',
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
        ],
      ),
    );
  }
}
