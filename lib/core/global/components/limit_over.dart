import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class LimitOver extends StatefulWidget {
  const LimitOver({
    super.key,
    this.memberName = 'Member',
    this.memberLocation = 'Barista',
    this.memberImagePath = AppImages.demoProfile,
    this.usedCount = 1,
    this.limitCount = 1,
    this.remainingCount = 0,
    this.resetOnText = 'Apr 3, 2026',
    this.onExtendPlan,
    this.onMaybeLater,
    this.onClose,
  });

  final String memberName;
  final String memberLocation;
  final String memberImagePath;
  final int usedCount;
  final int limitCount;
  final int remainingCount;
  final String resetOnText;
  final VoidCallback? onExtendPlan;
  final VoidCallback? onMaybeLater;
  final VoidCallback? onClose;

  @override
  State<LimitOver> createState() => _LimitOverState();
}

class _LimitOverState extends State<LimitOver> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _titleSection(),
            const SizedBox(height: 18),
            _memberCard(),
            const SizedBox(height: 16),
            _statsCard(),
            const SizedBox(height: 20),
            _promoPill(),
            const SizedBox(height: 16),
            _extendButton(),
            const SizedBox(height: 10),
            _maybeLaterButton(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Spacer(),
        InkWell(
          onTap: widget.onClose ?? () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.textSecondaryLight,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleSection() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF4FA1), AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33FD297B),
                blurRadius: 8,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.workspace_premium_outlined,
            color: AppColors.white,
            size: TextSize.font30(context),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Connection Request Limit Reached',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font22(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "You've used all your connection requests for this period. Extend your plan to keep connecting with new profiles.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _memberCard() {
    return Column(
      children: [
        ClipOval(
          child: ShowImage(
            imagePath: widget.memberImagePath,
            width: TextSize.font36(context) * 2,
            height: TextSize.font36(context) * 2,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.memberName,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font16(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.memberLocation,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font13(context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statsCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _metricTile(
                  title: 'Used',
                  value: widget.usedCount.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _metricTile(
                  title: 'Limit',
                  value: widget.limitCount.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _metricTile(
                  title: 'Remaining',
                  value: widget.remainingCount.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Resets on ',
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: widget.resetOnText,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricTile({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.hintTextColor,
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoPill() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F7),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              color: AppColors.primary,
              size: TextSize.font14(context),
            ),
            const SizedBox(width: 8),
            Text(
              'Save upto 55% on Premium Plans!',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _extendButton() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      onTap: widget.onExtendPlan ?? () {},
      title: 'Extend Plan',
      svgIconPath: AppImages.premiumSvgIcon,
      svgIconColor: AppColors.white,
      titleSize: TextSize.font14(context),
      textColor: AppColors.white,
      bgColor: AppColors.primary,
    );
  }

  Widget _maybeLaterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: widget.onMaybeLater ?? () => Navigator.of(context).pop(),
          child: Text(
            'Maybe later',
            style: TextStyle(
              color: AppColors.hintTextColor,
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
