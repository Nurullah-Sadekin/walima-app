import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/empty_state.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/tab_bar_widget.dart';

class InboxMoreTab extends ConsumerStatefulWidget {
  const InboxMoreTab({super.key});

  @override
  ConsumerState<InboxMoreTab> createState() => _InboxMoreTabState();
}

class _InboxMoreTabState extends ConsumerState<InboxMoreTab>
    with SingleTickerProviderStateMixin {
  late final TabController _subTabController;
  final _subTabs = const ['Blocked', 'Deleted'];

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: _subTabs.length, vsync: this)
      ..addListener(_handleSubTabChange);
  }

  void _handleSubTabChange() {
    if (!mounted || _subTabController.indexIsChanging) return;
    setState(() {});
  }

  @override
  void dispose() {
    _subTabController.removeListener(_handleSubTabChange);
    _subTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inboxProvider);

    return Column(
      children: [
        const SizedBox(height: 10),
        _header(),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _MoreTabPlaceholder(
                title: 'No Blocked Requests',
                subtitle: 'Blocked items will appear here',
              ),
              _MoreTabPlaceholder(
                title: 'No Deleted Requests',
                subtitle: 'Deleted items will appear here',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: List.generate(_subTabs.length, (index) {
          final isSelected = _subTabController.index == index;
          return TabBarWidget(
            text: _subTabs[index],
            isSelected: isSelected,
            backgroundColor: AppColors.transparent,
            selectedBackgroundColor: AppColors.primaryVariant,
            selectedTextColor: AppColors.primary,
            borderColor: isSelected ? AppColors.primary : AppColors.greyLight,
            selectedBorderColor: AppColors.primary,
            isBorder: true,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
            borderRadius: 8,
            fontSize: TextSize.font12(context),
            onTap: () => _subTabController.animateTo(index),
          );
        }),
      ),
    );
  }

  Widget _header() {
    final selectedTab = _subTabs[_subTabController.index];


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSubTabs(),
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
        ),
      ],
    );
  }

  Widget _sentFilter(InboxProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FilterWidget(
        title: 'Filter My Sent Requests',
        items: provider.filterList
            .map((item) => FilterItem(name: item.label, isSelected: item.isSelected))
            .toList(),
        onItemTap: provider.selectFilterTypeIndex,
      ),
    );
  }
}

class _MoreTabPlaceholder extends StatelessWidget {
  const _MoreTabPlaceholder({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: EmptyStateWidget(
          imagePath: AppImages.addTeam,
          title: title,
          subtitle: subtitle,
          buttonText: 'Refresh',
        ),
      ),
    );
  }
}
