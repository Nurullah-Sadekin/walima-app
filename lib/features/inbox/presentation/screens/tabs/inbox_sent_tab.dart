import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/menu_item_model.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_card.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_tab_shared.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxSentTab extends ConsumerStatefulWidget {
  const InboxSentTab({super.key});

  @override
  ConsumerState<InboxSentTab> createState() => _InboxSentTabState();
}

class _InboxSentTabState extends ConsumerState<InboxSentTab> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(inboxProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 10),
          _body(provider),
        ],
      ),
    );
  }


  Widget _body(InboxProvider provider) {
    return Column(
      children: [
        InboxCard(
          menuItems: [
            MenuItem(
              name: 'Cancel Request',
              onTap: () => handleMenuAction(
                context: context,
                action: InboxMoreMenuAction.cancelRequest,
              ),
            ),
          ],
          imagePath: AppImages.demoProfile2,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          day: 'Today',
          location: 'Gulshan, Dhaka, BD',
          subtitle: 'Supper Contact',
          subtitleColor: AppColors.primary,
          isVerified: true,
          middleBottomItemIBgColor:  AppColors.warning,
          middleBottomItemIcon: AppImages.notificationSvgIcon,
          middleBottomItemText: 'Remind',
          rightBottomItemIcon: AppImages.callIcon,
          rightBottomItemText: 'Contact',
          rightBottomItemBgColor: AppColors.blue,

        ),
      ],
    );
  }

  Widget _header(){
    return Row(
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
                  return _sentFilter(ref.watch(inboxProvider));
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
              imagePath: AppImages.filterSvgIcon,
              width: TextSize.font16(context),
              height: TextSize.font16(context),
              color: AppColors.textSecondaryLight,
            ),
          ),
        )
      ],
    );
  }

  Widget _sentFilter(InboxProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FilterWidget(
        title: 'Filter My Sent Requests',
        items: provider.sortByDataList
            .map((item) => FilterItem(name: item.name, isSelected: item.isSelected))
            .toList(),
        onItemTap: provider.sortBy,
      ),
    );
  }

}

