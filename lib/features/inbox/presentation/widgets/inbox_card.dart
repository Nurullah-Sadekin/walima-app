import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/bottom_sheet_widget/widgets/icon_title_card.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/inbox/domain/models/menu_item_model.dart';

class InboxCard extends StatelessWidget {
  const InboxCard({
    super.key,

    // Primary
    required this.imagePath,
    required this.name,
    this.isVerified = false,
    this.isPremium = false,
    this.day,
    this.menuItems,
    this.showMenu = true,

    this.subtitle,
    this.subtitleColor,

    this.isBottomSection = true,
    this.onTapWalimaChat,
    this.onTapMiddleBottomItem,
    this.onTapRightBottomItem,
    this.middleBottomItemText,
    this.rightBottomItemText,
    this.middleBottomItemIcon,
    this.rightBottomItemIcon,
    this.middleBottomItemIBgColor,
    this.rightBottomItemBgColor,

    this.infoBottomMessage,

    this.mood = InboxCardMood.medium,

    // for medium & small
    this.age,
    this.height,
    this.location,
    this.profession,

    // for large
    this.contact,
    this.email,
    this.sendSMS,
    this.viewSMS,
    this.onTapSendSMS,
    this.onTapViewSMS,
    this.contactUnavailable = false,
  });

  // Primary
  final String imagePath;
  final String name;
  final bool isVerified;
  final bool isPremium;
  final String? day;
  final List<MenuItem>? menuItems;
  final bool showMenu;

  final String? subtitle;
  final Color? subtitleColor;

  final bool isBottomSection;
  final VoidCallback? onTapWalimaChat;
  final VoidCallback? onTapMiddleBottomItem;
  final VoidCallback? onTapRightBottomItem;
  final String? middleBottomItemText;
  final String? rightBottomItemText;
  final String? middleBottomItemIcon;
  final String? rightBottomItemIcon;
  final Color? middleBottomItemIBgColor;
  final Color? rightBottomItemBgColor;

  final String? infoBottomMessage;

  final InboxCardMood mood;

  // for medium & small
  final String? age;
  final String? height;
  final String? location;
  final String? profession;

  // for large card
  final String? contact;
  final String? email;
  final String? sendSMS;
  final String? viewSMS;
  final VoidCallback? onTapSendSMS;
  final VoidCallback? onTapViewSMS;
  final bool contactUnavailable;

  @override
  Widget build(BuildContext context) {
    final double imageSize = switch (mood) {
      InboxCardMood.small => MediaQuery.of(context).size.width * 0.15,
      InboxCardMood.medium => MediaQuery.of(context).size.width * 0.2,
      InboxCardMood.large => MediaQuery.of(context).size.width * 0.25,
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Row -> Image + Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _cardImage(imageSize),
              const SizedBox(width: 12),
              // Expanded details column
              Expanded(
                child: SizedBox(
                  height: imageSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _cardHeader(context),
                      if (mood != InboxCardMood.large)
                        Expanded(
                            child: _cardDetails(
                          context,
                        )),
                      if (mood == InboxCardMood.large)
                        _cardDetailsForLarge(context,),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom action section
          if (isBottomSection) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: AppColors.greyLight,
                thickness: 1,
                height: 0,
              ),
            ),
            if (infoBottomMessage != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 8.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  spacing: 6,
                  children: [
                    ShowImage(
                      imagePath: AppImages.alertSvgIcon,
                      width: TextSize.font14(context),
                      height: TextSize.font14(context),
                      color: AppColors.primary,
                    ),
                    Text(
                      infoBottomMessage!,
                      style: TextStyle(
                        fontSize: TextSize.font12(context),
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            if (infoBottomMessage == null)
            _cardActions(context),
          ],
        ],
      ),
    );
  }

  Widget _cardImage(double imageSize) {
    return ShowImage(
      imagePath: imagePath,
      width: imageSize,
      height: imageSize,
      radius: BorderRadius.circular(8),
    );
  }

  Widget _cardHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: TextSize.font16(context),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 4),
                          ShowImage(
                            imagePath: AppImages.verifiedBadgeSvgIcon,
                            width: TextSize.font14(context),
                            height: TextSize.font14(context),
                          )
                        ],
                        if (isPremium) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: ShowImage(
                              imagePath: AppImages.premiumSvgIcon,
                              width: TextSize.font10(context),
                              height: TextSize.font10(context),
                              color: AppColors.white,
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                  if (day != null) ...[
                    Row(
                      children: [
                        SizedBox(
                          height: TextSize.font12(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: VerticalDivider(
                              color: AppColors.hintTextColor,
                              thickness: 1,
                            ),
                          ),
                        ),
                        Text(
                          day!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: TextSize.font10(context),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    )
                  ],
                ],
              ),
            ),
            if (showMenu && menuItems != null && menuItems!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: SizedBox(
                  width: TextSize.font16(context), // Force exact icon size
                  height: TextSize.font16(context),
                  child: PopupMenuButton<int>(
                    onSelected: (index) {
                      if (index >= 0 && index < menuItems!.length) {
                        menuItems![index].onTap();
                      }
                    },
                    padding: EdgeInsets.zero,
                    position: PopupMenuPosition.under,
                    popUpAnimationStyle: AnimationStyle.noAnimation,
                    color: Colors.white,
                    iconSize: TextSize.font16(context),
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.textSecondaryLight,
                      size: TextSize.font16(context),
                    ),
                    itemBuilder: (context) => menuItems!
                        .asMap()
                        .entries
                        .map(
                          (entry) => PopupMenuItem<int>(
                            value: entry.key,
                            height: 28,
                            padding: const EdgeInsets.fromLTRB(16, 6, 35, 6),
                            child: Text(
                              entry.value.name,
                              style: TextStyle(
                                fontSize: TextSize.font12(context),
                                color: AppColors.textPrimaryLight,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: TextSize.font10(context),
              fontWeight: FontWeight.w400,
              color: subtitleColor ?? AppColors.textSecondaryLight,
            ),
          ),
      ],
    );
  }

  Widget _cardDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (age != null && height != null)
          Text(
            '$age, $height',
            style: TextStyle(
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
        if (location != null)
          Text(
            location!,
            style: TextStyle(
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
        if (profession != null && mood == InboxCardMood.medium)
          Text(
            profession!,
            style: TextStyle(
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
      ],
    );
  }

  Widget _cardDetailsForLarge(BuildContext context) {
    return contactUnavailable
        ? Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(top: 8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.disableBackground,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Contact not available',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Profile has been deactivated',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          )
        : Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (contact != null)
                  detailsRow(context, contact!, AppImages.callSvgIcon),
                if (email != null)
                  detailsRow(context, email!, AppImages.emailSvgIcon),
                if (sendSMS != null && viewSMS == null)
                  detailsRow(context, sendSMS!, AppImages.chatSvgIcon),
                if (viewSMS != null && sendSMS == null)
                  InkWell(
                    onTap: onTapViewSMS,
                    child: Text(
                      viewSMS!,
                      style: TextStyle(
                        fontSize: TextSize.font12(context),
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
        );
  }

  Widget detailsRow(BuildContext context, String label, String imagePath) {
    return Row(
      spacing: 8,
      children: [
        ShowImage(
          imagePath: imagePath,
          width: TextSize.font14(context),
          height: TextSize.font14(context),
          color: AppColors.textSecondaryLight,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _cardActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 8,
      children: [
        if (onTapWalimaChat != null)
          Expanded(
            child: PrimaryButtons(
                buttonStyle: ButtonsStyle.iconicDynamicButton,
                verticalPadding: 6,
                onTap: () {
                  onTapWalimaChat!();
                },
                title: 'Walima Chat',
                svgIconPath: AppImages.chatIcon,
                bgColor: AppColors.primary,
                textColor: AppColors.white,
                svgIconColor: AppColors.white,
            ),
          ),

        Expanded(
          child: PrimaryButtons(
            buttonStyle: ButtonsStyle.iconicDynamicButton,
            verticalPadding: 6,
            onTap: () {
              if (onTapMiddleBottomItem != null) {
                onTapMiddleBottomItem!();
              }
            },
            title: middleBottomItemText ?? 'Contact',
            svgIconPath: middleBottomItemIcon ?? AppImages.contactSvgIcon,
            bgColor: (onTapMiddleBottomItem == null ? middleBottomItemIBgColor?.withOpacity(0.5) : middleBottomItemIBgColor) ?? (onTapMiddleBottomItem == null ? AppColors.blue.withOpacity(0.5) : AppColors.blue),
            textColor: onTapMiddleBottomItem == null ? AppColors.disableText : AppColors.white,
            svgIconColor: AppColors.white,
          ),
        ),

        if (onTapRightBottomItem != null)
        IconTitleCard(
          title: rightBottomItemText ?? 'Whatsapp',
          imagePath: rightBottomItemIcon ?? AppImages.whatsappSvgIcon,
          backgroundColor: (onTapRightBottomItem == null ? rightBottomItemBgColor?.withOpacity(0.5) : rightBottomItemBgColor) ?? (onTapRightBottomItem == null ? AppColors.greenButtonColor.withOpacity(0.5) : AppColors.greenButtonColor),
          textColor: onTapRightBottomItem == null ? AppColors.disableText : AppColors.textSecondaryLight,
          iconColor: AppColors.white,
          onTap: onTapRightBottomItem,
          mood: IconTitleCardMood.horizontal,
        ),
      ],
    );
  }
}

enum InboxCardMood {
  small,
  medium,
  large,
}
