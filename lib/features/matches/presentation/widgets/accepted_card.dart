import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class AcceptedCard extends StatelessWidget {
  const AcceptedCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.age,
    required this.height,
    required this.location,
    this.profession,
    this.day,
    this.onMenuTap,
    this.onTapWalimaChat,
    this.onTapPhoneCall,
    this.onTapWhatsapp,
    this.isVerified = false,
    this.isPremium = false,
  });

  final String imagePath;
  final String name;
  final String age;
  final String height;
  final String location;
  final String? profession;
  final String? day;
  final VoidCallback? onMenuTap;
  final VoidCallback? onTapWalimaChat;
  final VoidCallback? onTapPhoneCall;
  final VoidCallback? onTapWhatsapp;
  final bool isVerified;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.2;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowImage(
                imagePath: imagePath,
                width: imageSize,
                height: imageSize,
                radius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Text(
                                        name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: TextSize.font16(context),
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimaryLight,
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
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: ShowImage(
                                            imagePath: AppImages.premiumSvgIcon,
                                            width: TextSize.font12(context),
                                            height: TextSize.font12(context),
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
                                       day??'',
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
                          InkWell(
                            onTap: onMenuTap,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Icon(
                                Icons.more_vert,
                                color: AppColors.textSecondaryLight,
                                size: TextSize.font16(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$age, $height',
                        style: TextStyle(
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      Text(
                        profession ?? 'Undefined',
                        style: TextStyle(
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(
              color: AppColors.greyLight,
              thickness: 1,
              height: 0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: onTapWalimaChat,
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShowImage(
                            imagePath: AppImages.chatIcon,
                            width: TextSize.font16(context),
                            height: TextSize.font16(context),
                            radius: BorderRadius.circular(8),
                            fit: BoxFit.fitWidth,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    Text('Walima Chat',
                        style: TextStyle(
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondaryLight,
                        ))
                  ],
                ),
              ),
              InkWell(
                onTap: onTapPhoneCall,
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF335CFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShowImage(
                            imagePath: AppImages.callSvgIcon,
                            width: TextSize.font16(context),
                            height: TextSize.font16(context),
                            radius: BorderRadius.circular(8),
                            fit: BoxFit.fitWidth,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    Text('Phone Call',
                        style: TextStyle(
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondaryLight,
                        ))
                  ],
                ),
              ),
              InkWell(
                onTap: onTapWhatsapp,
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColors.greenButtonColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShowImage(
                            imagePath: AppImages.whatsappSvgIcon,
                            width: TextSize.font16(context),
                            height: TextSize.font16(context),
                            radius: BorderRadius.circular(8),
                            fit: BoxFit.fitWidth,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    Text('Whatsapp',
                        style: TextStyle(
                          fontSize: TextSize.font12(context),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondaryLight,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
