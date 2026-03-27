import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/contact_allow_bottom_sheet.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/contact_bottom_sheet.dart';
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

          ContactBottomSheet(
            userName: 'Sadia Sultana',
            profileImagePath: AppImages.demoProfile,
            profileType: 'Profile Created by Self',
            description: 'She shares her phone number only with connected members.',
            isDescriptionVisible: false,
            onWalimaChatPressed: () {},
            onWhatsappPressed: () {},
            onCallPressed: () {},
            onConnectionSentPressed: () {},
            onWalimaChatButtonPressed: () {},
          ),

          ContactAllowBottomSheet(
            userName: 'Sadia Sultana',
            profileImagePath: AppImages.demoProfile,
            profileType: 'Profile Created by Self',
            onCallPressed: () {},
            onMessagePressed: () {},
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
