import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/contact_whatsapp_call_bottom_sheet.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/contact_bottom_sheet.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/info_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/premium_contact_bottom_sheet.dart';
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
            onChanged: (value) {},
          ),
          const SizedBox(height: 10),
          const InfoCardWidget(
              title: 'Profiles Matching Your Preferences',
              description:
                  'Some profiles may not match all your preferences, but you might find meaningful connections.'),
          dummyWidgetForTest(context),
          const SizedBox(height: 80)
        ],
      ),
    );
  }

  Widget dummyWidgetForTest(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          spacing: 20,
          children: [
            ContactBottomSheet(
              userName: 'Sadia Sultana',
              profileImagePath: AppImages.demoProfile,
              profileType: 'Profile Created by Self',
              description:
                  'She shares her phone number only with connected members.',
              isDescriptionVisible: false,
              onWalimaChatPressed: () {},
              onWhatsappPressed: () {},
              onCallPressed: () {},
              onConnectionSentPressed: () {},
              onWalimaChatButtonPressed: () {},
            ),
            ContactWhatsappCallBottomSheet(
              userName: 'Sadia Sultana',
              profileImagePath: AppImages.demoProfile,
              profileType: 'Profile Created by Self',
              onPressedPrimary: () {},
              onMessagePressed: () {},
              isWhatsappContact: true,
            ),
            const InboxCard(
              imagePath: AppImages.demoProfile,
              name: 'name',
              subtitle: 'Profile Created by Self',
              subtitleColor: AppColors.primary,
              isPremium: true,
              age: 'age',
              height: 'height',
              day: 'day',
              location: 'location',
              isBottomSection: true,
              mood: InboxCardMood.medium,
            ),
            const InboxCard(
              imagePath: AppImages.demoProfile,
              name: 'Tanjid Amran',
              subtitle: 'Profile Created by Self',
              isPremium: true,
              day: 'Today',
              profession: 'profession',
              contact: '+8801568975645',
              email: 'tanjid470@gmail.com',
              isBottomSection: true,
              viewSMS: 'View SMS',
              mood: InboxCardMood.large,
              middleBottomItemIBgColor: AppColors.warning,
              middleBottomItemIcon: AppImages.notificationSvgIcon,
              middleBottomItemText: 'Remind',
              rightBottomItemBgColor: AppColors.blue,
              rightBottomItemIcon: AppImages.callSvgIcon,
              rightBottomItemText: 'Contact',
            ),
            const PremiumContactBottomSheet(
              imagePath: AppImages.demoProfile,
              name: 'Tanjid Amran',
              contact: '02392839283923',
              email: 'tanjid@gmail.com',
              topIconPath: AppImages.premiumSvgIcon,
            ),
            const InboxCard(
              imagePath: AppImages.demoProfile,
              name: 'Tanjid Amran',
              day: 'day',
              isVerified: true,
              isBottomSection: true,
              viewSMS: 'View SMS',
              mood: InboxCardMood.large,
              contactUnavailable: true,
              infoBottomMessage: 'She declined your request',
              showMenu: false,
            ),
          ],
        ),
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
