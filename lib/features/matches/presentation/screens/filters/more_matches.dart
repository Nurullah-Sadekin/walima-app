import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet_widget/widgets/icon_title_card.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/info_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';

class MoreMatchesScreen extends StatelessWidget {
  const MoreMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        title: Text(
          'More Matches',
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font16(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        onBackPressed: () => Navigator.of(context).maybePop(),
      ),
      body: body(context),
      floatingActionButton: bottomAction(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SettingsSwitchTile(
            title: 'More Matches',
            value: true,
            onChanged: (value) {
              // Handle switch state change
            },
          ),
          const SizedBox(height: 10),
          const InfoCardWidget(
              title: 'Profiles Matching Your Preferences',
              description:
                  'Some profiles may not match all your preferences, but you might find meaningful connections.'),
          Column(
            children: [
              const SizedBox(height: 10,),
              ShowImage(
                imagePath: AppImages.demoProfile,
                height: 64,
                width: 64,
                radius: BorderRadius.circular(1000),
              ),
              const SizedBox(height: 8,),
              Text(
                'Sadia Sultana',
                style: TextStyle(
                  fontSize: TextSize.font18(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  'Profile Created by Self',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              Text(
                'She shares her phone number only with connected members.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconTitleCard(
                    title: 'Walima Chat',
                    imagePath: AppImages.chatIcon,
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.textSecondaryLight,
                    iconColor: AppColors.white,
                    onTap: () {
                      // Return an example result. Adjust as needed.
                      Navigator.of(context).pop({'applied': true});
                    },
                  ),
                  IconTitleCard(
                    title: 'Whatsapp',
                    imagePath: AppImages.whatsappSvgIcon,
                    backgroundColor: AppColors.greenButtonColor,
                    textColor: AppColors.textSecondaryLight,
                    iconColor: AppColors.white,
                    onTap: () {
                      // Return an example result. Adjust as needed.
                      Navigator.of(context).pop({'applied': true});
                    },
                  ),
                  IconTitleCard(
                    title: 'Call',
                    imagePath: AppImages.callSvgIcon,
                    backgroundColor: Colors.teal,
                    textColor: AppColors.textSecondaryLight,
                    iconColor: AppColors.white,
                    onTap: () {
                      // Return an example result. Adjust as needed.
                      Navigator.of(context).pop({'applied': true});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButtons(
                      buttonStyle: ButtonsStyle.iconicDynamicButton,
                      title: 'Connection Sent',
                      borderColor: AppColors.greenButtonColor,
                      textColor: AppColors.greenButtonColor,
                      svgIconPath: AppImages.favouriteIcon,
                      svgIconColor: AppColors.greenButtonColor,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButtons(
                      buttonStyle: ButtonsStyle.iconicDynamicButton,
                      borderColor: AppColors.primary,
                      bgColor: AppColors.primary,
                      textColor: AppColors.white,
                      svgIconPath: AppImages.chatIcon,
                      svgIconColor: AppColors.white,
                      title: 'Walima Chat',
                      onTap: () {
                        // Return an example result. Adjust as needed.
                        Navigator.of(context).pop({'applied': true});
                      },
                    ),
                  ),
                ],
              ),
              const Divider(
                color: AppColors.greyLight,
                thickness: 1,
                height: 30,
              ),
              Text(
                'Contact Not Viewed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget bottomAction(BuildContext context) {
    return BottomBorderedWidget(
      widget: Row(
        children: [
          Expanded(
            child: PrimaryButtons(
              buttonStyle: ButtonsStyle.cancelButton,
              title: 'Cancel',
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PrimaryButtons(
              buttonStyle: ButtonsStyle.activePrimaryButton,
              title: 'Apply',
              onTap: () {
                // Return an example result. Adjust as needed.
                Navigator.of(context).pop({'applied': true});
              },
            ),
          ),
        ],
      ),
    );
  }
}
