import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class PreferenceMatchCard extends StatelessWidget {
  const PreferenceMatchCard({super.key});

  static const List<_PreferenceItem> _items = [
    _PreferenceItem(label: 'Age', value: '25 to 28', isMatched: true),
    _PreferenceItem(
      label: 'Height',
      value: '5\' 0" (152 cm) to 5\' 6" (167 cm)',
      isMatched: true,
    ),
    _PreferenceItem(
      label: 'Religion / Community',
      value: 'Muslim, Sunni',
      isMatched: true,
    ),
    _PreferenceItem(
      label: 'Mother Tongue',
      value: 'Bengali',
      isMatched: true,
    ),
    _PreferenceItem(
      label: 'Marital Status',
      value: 'Never Married',
      isMatched: false,
    ),
    _PreferenceItem(
      label: 'Country Living In',
      value: 'Bangladesh',
      isMatched: true,
    ),
    _PreferenceItem(
      label: 'State Living In',
      value: 'Dhaka, Bangladesh',
      isMatched: true,
    ),
    _PreferenceItem(
      label: 'City / District',
      value: 'Open to All',
      isMatched: true,
    ),
    _PreferenceItem(
      label: 'Education',
      value: 'Open to All',
      isMatched: false,
    ),
    _PreferenceItem(
      label: 'Profession Area',
      value: 'Open to All',
      isMatched: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: 20),
          _MatchSummary(),
          const SizedBox(height: 18),
          ..._items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _PreferenceInfoTile(item: item),
              )),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
            border: Border.all(color: AppColors.primaryShade300, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const ShowImage(
            imagePath: AppImages.favouriteIcon,
            fit: BoxFit.cover,
            color: AppColors.primary,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Her Preferences',
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Seeking a genuine connection',
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font12(context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MatchSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _AvatarBubble(
          imagePath: AppImages.womenAvatar,
          alignment: Alignment.centerLeft,
        ),
        const SizedBox(width: 10),
        const Expanded(child: _ConnectorLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ShowImage(
                    imagePath: AppImages.favouriteIcon,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 0.2, // 20% of screen width
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: AppColors.primary,
                  ),
                  Text(
                    '92%',
                    style: TextStyle(
                      fontSize: TextSize.font15(context), // Responsive font size
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Matched 07/10',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: _ConnectorLine()),
        const SizedBox(width: 10),
        const _AvatarBubble(
          imagePath: AppImages.manAvatar,
          alignment: Alignment.centerRight,
        ),
      ],
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({
    required this.imagePath,
    required this.alignment,
  });

  final String imagePath;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.width * 0.15,
        padding: const EdgeInsets.all(1.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              Color(0xFFFF7AAE),
            ],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: ClipOval(
            child: ShowImage(
              imagePath: imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectorLine extends StatelessWidget {
  const _ConnectorLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.0),
            AppColors.primaryShade300,
            AppColors.primary.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

class _PreferenceInfoTile extends StatelessWidget {
  const _PreferenceInfoTile({required this.item});

  final _PreferenceItem item;

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        item.isMatched ? AppColors.primary : AppColors.textSecondaryLight;
    final IconData statusIcon =
        item.isMatched ? Icons.check_rounded : Icons.close_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.label}:',
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.value,
                  style: TextStyle(
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            statusIcon,
            color: statusColor,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _PreferenceItem {
  const _PreferenceItem({
    required this.label,
    required this.value,
    required this.isMatched,
  });

  final String label;
  final String value;
  final bool isMatched;
}
