import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class ProfileComprehensiveCard extends StatelessWidget {
  const ProfileComprehensiveCard({
    super.key,
    required this.imagePath,
    this.imageHeight,
    this.imageWidth,
    this.leftIconPath,
    this.rightIconPath,
    required this.name,
    this.age,
    this.height,
    this.location,
    this.maritalStatus,
    this.profession,
    this.religion,
    this.leftButtonText = 'Connect',
    this.rightButtonText = 'Shortlist',
    this.onTapLeftButton,
    this.onTapRightButton,
    this.isPremiumConnect = false,
    this.isVerified = false,
    this.leftButtonColor,
    this.rightButtonColor,
    this.leftButtonTextColor,
    this.leftButtonIconColor,
    this.rightButtonIconColor,
    this.rightButtonTextColor,
    this.leftButtonBorderColor,
    this.rightButtonBorderColor,
    this.activeStatusText,
    this.photoCount,
    this.menu,
    this.viewOnAccept = false,
    this.photoRequest = false,
    this.isSingleButton = false,
    this.onTapSingleButton,
    this.onTapCard,
    this.singleButtonColor,
    this.singleButtonTextColor,
    this.singleButtonBorderColor,
    this.singleButtonIconColor,
    this.singleButtonText = 'Connect Now',
    this.onMenuTap,
    this.noButton = false,
    this.isOnline = false,
  });

  static const _cardPadding = EdgeInsets.all(10);
  static const _topOffset = 10.0;
  static const _bottomOffset = 10.0;
  static const _imageRadius = BorderRadius.all(Radius.circular(8));
  static const _overlayRadius = BorderRadius.all(Radius.circular(10));
  static const _cardRadius = BorderRadius.all(Radius.circular(16));
  static const _greenStatusColor = Color(0XFF1FC16B);
  static const _shortlistColor = Color(0xFFE05271);
  static const _connectButtonColor = Color(0xFF42B979);
  static const _buttonBorderColor = Color(0xFFEDEDED);
  static const _textHeightBehavior = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

  final String imagePath;
  final double? imageHeight;
  final double? imageWidth;
  final String? leftIconPath;
  final String? rightIconPath;
  final String name;
  final String? age;
  final String? height;
  final String? maritalStatus;
  final String? profession;
  final String? religion;
  final String? leftButtonText;
  final String? rightButtonText;
  final String? location;

  final VoidCallback? onTapLeftButton;
  final VoidCallback? onTapRightButton;
  final Color? leftButtonColor;
  final Color? rightButtonColor;
  final Color? leftButtonTextColor;
  final Color? leftButtonIconColor;
  final Color? rightButtonIconColor;
  final Color? rightButtonTextColor;
  final Color? leftButtonBorderColor;
  final Color? rightButtonBorderColor;

  final String? activeStatusText;
  final String? photoCount;
  final bool isPremiumConnect;
  final bool isVerified;
  final bool? menu;
  final bool viewOnAccept;
  final bool photoRequest;
  final bool isSingleButton;

  final VoidCallback? onMenuTap;
  final VoidCallback? onTapCard;

  final VoidCallback? onTapSingleButton;
  final Color? singleButtonColor;
  final Color? singleButtonTextColor;
  final Color? singleButtonBorderColor;
  final Color? singleButtonIconColor;
  final String? singleButtonText;

  final bool noButton;
  final bool isOnline;

  bool get _hasAgeAndHeight => age != null && height != null;
  bool get _hasLocation => location?.isNotEmpty ?? false;
  bool get _hasMenu => menu == true;
  bool get _hasPhotoCount => photoCount != null;
  bool get _hasActionButtons => !noButton;

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    final metrics = _ProfileCardMetrics.from(context);
    final resolvedImageHeight = imageHeight ?? MediaQuery.sizeOf(context).height * 0.4;

    return GestureDetector(
      onTap: onTapCard,
      child: Container(
        width: double.infinity,
        padding: _cardPadding,
        decoration: BoxDecoration(
          borderRadius: _cardRadius,
          border: Border.all(color: AppColors.greyLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageSection(context, metrics, resolvedImageHeight),
            const SizedBox(height: 16),
            _buildProfileContent(context, metrics),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    _ProfileCardMetrics metrics,
    double resolvedImageHeight,
  ) {
    return Stack(
      children: [
        ShowImage(
          imagePath: imagePath,
          width: imageWidth ?? double.infinity,
          height: resolvedImageHeight,
          radius: _imageRadius,
          fit: BoxFit.fill,
        ),
        if (viewOnAccept) _buildViewOnAcceptOverlay(context, metrics),
        if (photoRequest) _buildPhotoRequestOverlay(context, metrics),
        if (isPremiumConnect) _buildPremiumBadge(metrics),
        if (activeStatusText != null) _buildActiveStatus(metrics),
        if (_hasPhotoCount || _hasMenu) _buildImageActions(metrics),
      ],
    );
  }

  Widget _buildViewOnAcceptOverlay(
    BuildContext context,
    _ProfileCardMetrics metrics,
  ) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: _overlayRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.disable,
              borderRadius: _overlayRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                ShowImage(
                  imagePath: AppImages.viewOnAccept,
                  width: metrics.font48,
                  height: metrics.font48,
                  radius: _imageRadius,
                  fit: BoxFit.fitWidth,
                  color: AppColors.white,
                ),
                Text(
                  'View on Accept'.localized(context),
                  style: TextStyle(
                    fontSize: metrics.font14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoRequestOverlay(
    BuildContext context,
    _ProfileCardMetrics metrics,
  ) {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.primaryVariant,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShowImage(
                  imagePath: AppImages.photoIcon,
                  width: metrics.font16,
                  height: metrics.font16,
                  fit: BoxFit.fill,
                  color: AppColors.primary,
                ),
                Text(
                  'Photo Request'.localized(context),
                  style: TextStyle(
                    fontSize: metrics.font14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBadge(_ProfileCardMetrics metrics) {
    return Positioned(
      top: _topOffset,
      left: _topOffset,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: ShowImage(
          imagePath: AppImages.premiumSvgIcon,
          width: metrics.font18,
          height: metrics.font18,
          radius: _imageRadius,
          fit: BoxFit.fitWidth,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildActiveStatus(_ProfileCardMetrics metrics) {
    return Positioned(
      bottom: _bottomOffset,
      left: _topOffset,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        decoration: const BoxDecoration(
          color: AppColors.disableDark,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          spacing: 4,
          children: [
            Container(
              width: metrics.font8,
              height: metrics.font8,
              decoration: BoxDecoration(
                color: isOnline ? _greenStatusColor : AppColors.disableBackground,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              activeStatusText ?? '',
              style: TextStyle(
                fontSize: metrics.font12,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageActions(_ProfileCardMetrics metrics) {
    return Positioned(
      top: _topOffset,
      right: _topOffset,
      child: Column(
        children: [
          if (_hasPhotoCount) _buildPhotoCount(metrics),
          if (_hasMenu && _hasPhotoCount) const SizedBox(height: 6),
          if (_hasMenu) _buildMenuButton(metrics),
        ],
      ),
    );
  }

  Widget _buildPhotoCount(_ProfileCardMetrics metrics) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: const BoxDecoration(
        color: AppColors.disableDark,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        spacing: 6,
        children: [
          ShowImage(
            imagePath: AppImages.photoIcon,
            width: metrics.font16,
            height: metrics.font16,
            radius: _imageRadius,
            fit: BoxFit.fitWidth,
            color: AppColors.white,
          ),
          Text(
            '1/$photoCount',
            style: TextStyle(
              fontSize: metrics.font10,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(_ProfileCardMetrics metrics) {
    return InkWell(
      onTap: onMenuTap ?? _noop,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: const BoxDecoration(
          color: AppColors.disableDark,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Icon(
          Icons.more_vert,
          size: metrics.font16,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    _ProfileCardMetrics metrics,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameRow(context, metrics),
        _buildDetails(context, metrics),
        if (_hasActionButtons) const SizedBox(height: 16),
        if (isSingleButton && _hasActionButtons) _buildSingleButton(),
        if (!isSingleButton && _hasActionButtons) _buildDualButtons(),
      ],
    );
  }

  Widget _buildNameRow(BuildContext context, _ProfileCardMetrics metrics) {
    return Row(
      spacing: 8,
      children: [
        Flexible(
          child: Text(
            name.localized(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textHeightBehavior: _textHeightBehavior,
            style: TextStyle(
              fontSize: metrics.font20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
        if (isVerified)
          ShowImage(
            imagePath: AppImages.verifiedBadgeSvgIcon,
            width: metrics.font20,
            height: metrics.font20,
            radius: _imageRadius,
            fit: BoxFit.fitWidth,
          ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context, _ProfileCardMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasAgeAndHeight) const SizedBox(height: 12),
        if (_hasAgeAndHeight) _buildSecondaryText('$age, $height', metrics),
        if (religion != null || maritalStatus != null) _buildReligionStatusRow(context, metrics),
        if (profession != null && _hasLocation) const SizedBox(height: 12),
        if (profession != null) _buildPrimaryText(profession ?? '', metrics),
        if (_hasLocation) _buildSecondaryText(location ?? '', metrics),
      ],
    );
  }

  Widget _buildReligionStatusRow(
    BuildContext context,
    _ProfileCardMetrics metrics,
  ) {
    final hasReligion = religion?.isNotEmpty ?? false;
    final hasMaritalStatus = maritalStatus?.isNotEmpty ?? false;
    final showFallbackStatus = hasReligion && !hasMaritalStatus;
    final statusText = showFallbackStatus ? 'Never Married' : maritalStatus;

    return Row(
      spacing: 4,
      children: [
        if (hasReligion)
          Flexible(
            child: _buildSecondaryText(religion!.localized(context), metrics),
          ),
        if (hasReligion && statusText != null)
          const Icon(
            Icons.circle,
            size: 4,
            color: AppColors.textSecondaryLight,
          ),
        if (statusText != null)
          Flexible(
            child: _buildSecondaryText(statusText.localized(context), metrics),
          ),
      ],
    );
  }

  Widget _buildPrimaryText(String text, _ProfileCardMetrics metrics) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: metrics.font16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildSecondaryText(String text, _ProfileCardMetrics metrics) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: metrics.font16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryLight,
      ),
    );
  }

  Widget _buildSingleButton() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      iconLeftPosition: true,
      bgColor: singleButtonColor ?? AppColors.white,
      onTap: onTapSingleButton ?? _noop,
      borderColor: singleButtonBorderColor ?? AppColors.primary,
      textColor: singleButtonTextColor ?? AppColors.primary,
      title: singleButtonText ?? 'Connect Now',
    );
  }

  Widget _buildDualButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: _ProfileActionButton(
              title: rightButtonText ?? 'Contact',
              iconPath: rightIconPath ?? AppImages.favouriteIcon,
              onTap: onTapRightButton ?? _noop,
              backgroundColor: rightButtonColor ?? AppColors.white,
              borderColor: rightButtonBorderColor ?? _buttonBorderColor,
              iconColor: rightButtonIconColor ?? _shortlistColor,
              textColor: rightButtonTextColor ?? AppColors.textPrimaryLight,
            ),
          ),
          Expanded(
            child: _ProfileActionButton(
              title: leftButtonText ?? 'Connect',
              iconPath: AppImages.chatSvgIcon,
              onTap: onTapLeftButton ?? _noop,
              backgroundColor: leftButtonColor ?? _connectButtonColor,
              borderColor: leftButtonBorderColor ?? _connectButtonColor,
              iconColor: leftButtonIconColor ?? AppColors.white,
              textColor: leftButtonTextColor ?? AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.title,
    required this.iconPath,
    required this.onTap,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });

  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 1),
            // boxShadow: const [
            //   BoxShadow(
            //     color: Color(0x0F000000),
            //     blurRadius: 12,
            //     offset: Offset(0, 4),
            //   ),
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowImage(
                imagePath: iconPath,
                width: TextSize.font20(context),
                height: TextSize.font20(context),
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title.localized(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: TextSize.font16(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCardMetrics {
  const _ProfileCardMetrics({
    required this.font8,
    required this.font10,
    required this.font12,
    required this.font14,
    required this.font16,
    required this.font18,
    required this.font20,
    required this.font48,
  });

  factory _ProfileCardMetrics.from(BuildContext context) {
    return _ProfileCardMetrics(
      font8: TextSize.font8(context),
      font10: TextSize.font10(context),
      font12: TextSize.font12(context),
      font14: TextSize.font14(context),
      font16: TextSize.font16(context),
      font18: TextSize.font18(context),
      font20: TextSize.font20(context),
      font48: TextSize.font48(context),
    );
  }

  final double font8;
  final double font10;
  final double font12;
  final double font14;
  final double font16;
  final double font18;
  final double font20;
  final double font48;
}
