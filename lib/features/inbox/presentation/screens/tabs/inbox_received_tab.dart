

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxReceivedTab extends ConsumerStatefulWidget {
  const InboxReceivedTab({super.key});

  @override
  ConsumerState<InboxReceivedTab> createState() => _InboxReceivedTabState();
}

class _InboxReceivedTabState extends ConsumerState<InboxReceivedTab> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(inboxProvider);

    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Requests (26)',
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () async {
                  await BottomSheetUtils.open(
                    context: context,
                    fullHeight: false,
                    child: Consumer(
                      builder: (context, ref, _) {
                        return _receivedFilter(ref.watch(inboxProvider));
                      },
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.greyLight, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  child: ShowImage(
                    imagePath: AppImages.sortFilter,
                    width: TextSize.font16(context),
                    height: TextSize.font16(context),
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              )
            ],
          ),
          _body(provider),
        ],
      ),
    );
  }

  Widget _receivedFilter(InboxProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSwitchTile(
            title: 'Enable Card View',
            value: provider.switcherValue ?? false,
            trailingImage: AppImages.cardView,
            showTrailingImage: true,
            onChanged: (newValue) {
              provider.switcherValue = newValue;
              provider.updateViewState();
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8.0, 0, 16.0),
            child: Divider(color: AppColors.greyLight, thickness: 1),
          ),
          FilterWidget(
            title: 'Sort by',
            iconPath: AppImages.sortIcon,
            items: provider.sortByDataList
                .map((item) => FilterItem(name: item.name, isSelected: item.isSelected))
                .toList(),
            onItemTap: provider.sortBy,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Divider(color: AppColors.greyLight, thickness: 1),
          ),
          FilterWidget(
            title: 'Filter by',
            iconPath: AppImages.filterSvgIcon,
            items: provider.sortByDataList
                .map((item) => FilterItem(name: item.name, isSelected: item.isSelected))
                .toList(),
            onItemTap: provider.sortBy,
          ),
        ],
      ),
    );
  }

  Widget _body(InboxProvider provider) {
    return const Column(
      children: [
        ProfileComprehensiveCard(
          imagePath: AppImages.demoProfile,
          leftIconPath: AppImages.favouriteIcon,
          isPremiumConnect: false,
          isVerified: true,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          location: 'Gulshan, Dhaka, BD',
          activeStatusText: '1 day ago',
          menu: true,
          onTapLeftButton: null,
          onTapRightButton: null,
          photoCount: '1',
          leftButtonText: 'Accept',
          rightButtonText: 'Reject',
          rightIconPath: AppImages.cancelSvgIcon,
        ),
      ],
    );
  }
}

