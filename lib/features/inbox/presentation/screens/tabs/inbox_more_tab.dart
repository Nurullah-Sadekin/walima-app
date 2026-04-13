import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/empty_state.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_boilerplate/features/connections/data/models/response/get_blocked_connection_response.dart'
    as blocked_models;
import 'package:flutter_boilerplate/features/connections/data/models/response/get_sent_connection_response.dart'
    as sent_models;
import 'package:flutter_boilerplate/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_card.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = ref.read(inboxProvider);
      if ((provider.blockedConnections?.isEmpty ?? true) &&
          !provider.isBlockedLoading) {
        provider.fetchBlockedConnections();
      }
    });
  }

  void _handleSubTabChange() {
    if (!mounted || _subTabController.indexIsChanging) return;

    final provider = ref.read(inboxProvider);

    if (_subTabController.index == 0) {
      if ((provider.blockedConnections?.isEmpty ?? true) &&
          !provider.isBlockedLoading) {
        provider.fetchBlockedConnections();
      }
    }

    if (_subTabController.index == 1) {
      if ((provider.deletedConnections?.isEmpty ?? true) &&
          !provider.isDeletedLoading) {
        provider.fetchDeletedConnections();
      }
    }

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
    final provider = ref.watch(inboxProvider);

    return Column(
      children: [
        _header(provider),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildBlockedTab(provider),
              _buildDeletedTab(provider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(InboxProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubTabs(),
        const SizedBox(width: 12),
        // InkWell(
        //   onTap: () async {
        //     await BottomSheetUtils.open(
        //       context: context,
        //       fullHeight: false,
        //       child: Consumer(
        //         builder: (context, ref, _) {
        //           return _sentFilter(ref.watch(inboxProvider));
        //         },
        //       ),
        //     );
        //   },
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: AppColors.transparent,
        //       borderRadius: BorderRadius.circular(4),
        //       border: Border.all(color: AppColors.greyLight, width: 1),
        //     ),
        //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        //     child: ShowImage(
        //       imagePath: AppImages.filterSvgIcon,
        //       width: TextSize.font16(context),
        //       height: TextSize.font16(context),
        //       color: AppColors.textSecondaryLight,
        //     ),
        //   ),
        // ),
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
            selectedBackgroundColor: AppColors.primaryVariant,
            selectedTextColor: AppColors.primary,
            selectedBorderColor: AppColors.primary,
            backgroundColor:
                isSelected ? AppColors.primaryVariant : AppColors.transparent,
            isBorder: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: 8,
            fontSize: TextSize.font12(context),
            onTap: () => _subTabController.animateTo(index),
          );
        }),
      ),
    );
  }

  Widget _buildDeletedTab(InboxProvider provider) {
    if (provider.isDeletedLoading &&
        (provider.deletedConnections?.isEmpty ?? true)) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.isDeletedHasError &&
        (provider.deletedConnections?.isEmpty ?? true)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStateWidget(
              title: 'Error Loading Deleted Requests',
              subtitle: 'Unable to load your deleted connection requests',
              buttonText: 'Retry',
              onTap: () => ref.read(inboxProvider).fetchDeletedConnections(),
            ),
          ],
        ),
      );
    }

    if (provider.deletedConnections?.isEmpty ?? true) {
      return const EmptyStateWidget(
        imagePath: AppImages.delete,
        title: 'No Deleted Requests',
        subtitle: 'No deleted connection requests were found',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(inboxProvider).fetchDeletedConnections(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: provider.deletedConnections!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = provider.deletedConnections![index];
          return InboxCard(
            imagePath: item.profilePhoto?.url ?? AppImages.demoProfile2,
            name: item.displayName ?? 'Unknown',
            age: '${item.age ?? ''} Yrs',
            height: CamelCaseUtils.formatCamelCase(item.religion ?? ''),
            day: DateTimeUtils.onlyDate(
              DateTime.tryParse(item.connection?.createdAt ?? ''),
            ),
            isBottomSection: false,
            infoBottomMessage: 'Okay',
            mood: InboxCardMood.small,
            location: _locationText(item),
            subtitle:
                CamelCaseUtils.formatCamelCase(item.connection?.status ?? ''),
            subtitleColor: AppColors.primary,
            isVerified: item.profilePhoto?.isVerified ?? false,
          );
        },
      ),
    );
  }

  Widget _buildBlockedTab(InboxProvider provider) {
    if (provider.isBlockedLoading &&
        (provider.blockedConnections?.isEmpty ?? true)) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.isBlockedHasError &&
        (provider.blockedConnections?.isEmpty ?? true)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStateWidget(
              title: 'Error Loading Blocked Users',
              subtitle: 'Unable to load your blocked users right now',
              buttonText: 'Retry',
              onTap: () => ref.read(inboxProvider).fetchBlockedConnections(),
            ),
          ],
        ),
      );
    }

    if (provider.blockedConnections?.isEmpty ?? true) {
      return const EmptyStateWidget(
        title: 'No Blocked Users',
        subtitle: 'Blocked users will appear here',
        showButton: false,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(inboxProvider).fetchBlockedConnections(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: provider.blockedConnections!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = provider.blockedConnections![index];
          return InboxCard(
            imagePath: item.profilePhoto?.url ?? AppImages.manAvatar,
            name: item.displayName ?? 'Unknown',
            age: '${item.age ?? ''} Yr',
            height: CamelCaseUtils.formatCamelCase(item.religion ?? ''),
            day: DateTimeUtils.onlyDate(
              DateTime.tryParse(item.connection?.createdAt ?? ''),
            ),
            location: _blockedLocationText(item),
            infoBottomMessage: item.connection?.message ?? '',
            mood: InboxCardMood.small,
            subtitleColor: AppColors.primary,
            isVerified: item.profilePhoto?.isVerified ?? false,
          );
        },
      ),
    );
  }

  String _locationText(sent_models.Data item) {
    final location = [
      item.location?.city,
      item.location?.state,
      item.location?.country,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(', ');

    return location.isEmpty ? 'N/A' : location;
  }

  String _blockedLocationText(blocked_models.BlockedConnectionData item) {
    final location = [
      item.location?.city,
      item.location?.state,
      item.location?.country,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(', ');

    return location.isEmpty ? 'N/A' : location;
  }

  // Widget _sentFilter(InboxProvider provider) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //     child: FilterWidget(
  //       title: 'Filter My Sent Requests',
  //       items: provider.filterList
  //           .map(
  //             (item) =>
  //                 FilterItem(name: item.label, isSelected: item.isSelected),
  //           )
  //           .toList(),
  //       onItemTap: provider.selectFilterTypeIndex,
  //     ),
  //   );
  // }
}
