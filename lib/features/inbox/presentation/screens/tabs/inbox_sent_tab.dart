import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/empty_state.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/inbox/domain/models/menu_item_model.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';

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
          _header(provider),
          const SizedBox(height: 10),
          _body(provider),
        ],
      ),
    );
  }

  Widget _body(InboxProvider provider) {
    if (provider.isSentLoading && (provider.sentConnections?.isEmpty ?? true)) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.isSentHasError &&
        (provider.sentConnections?.isEmpty ?? true)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyStateWidget(
              imagePath: AppImages.sentMessage,
              title: 'Error Loading Sent Requests',
              subtitle: 'Unable to load your sent connection requests',
              buttonText: 'Retry',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(inboxProvider).fetchSentConnections(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.sentConnections?.isEmpty ?? true) {
      return const EmptyStateWidget(
        imagePath: AppImages.sentMessage,
        title: 'No Sent Requests',
        subtitle: 'Your sent connection requests will appear here',
        buttonText: 'Refresh',
      );
    }

    return Column(
      children: provider.sentConnections!.map((item) {
        final location = [
          item.location?.city,
          item.location?.state,
          item.location?.country,
        ]
            .whereType<String>()
            .where((value) => value.trim().isNotEmpty)
            .join(', ');
        final connectionId = item.connection?.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InboxCard(
            menuItems: [
              MenuItem(
                name: 'Cancel Request',
                onTap: () async {
                  final connectionId = item.connection?.id;
                  if (connectionId == null ||
                      provider.isDeletingSentConnection) {
                    return;
                  }

                  final success = await ref
                      .read(inboxProvider)
                      .deleteSentConnection(connectionId);

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Request cancelled successfully'
                            : provider.sentNotifyMessage ??
                                'Failed to cancel request',
                      ),
                    ),
                  );
                },
              ),
            ],
            imagePath: item.profilePhoto?.url ?? AppImages.demoProfile2,
            name: item.displayName ?? 'Unknown',
            age: '${item.age ?? ''} Yr',
            height: CamelCaseUtils.formatCamelCase(item.religion ?? ''),
            day: DateTimeUtils.onlyDate(
              DateTime.tryParse(item.connection?.createdAt ?? ''),
            ),
            location: location.isEmpty ? 'N/A' : location,
            subtitle:
                CamelCaseUtils.formatCamelCase(item.connection?.status ?? ''),
            subtitleColor: AppColors.primary,
            isVerified: item.profilePhoto?.isVerified ?? false,
            middleBottomItemIBgColor: AppColors.warning,
            middleBottomItemIcon: AppImages.notificationSvgIcon,
            middleBottomItemText: 'Remind',
            onTapMiddleBottomItem: connectionId == null
                ? null
                : () async {
                    final message = await ref
                        .read(inboxProvider)
                        .sendSentConnectionReminder(connectionId);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          message.trim().isNotEmpty
                              ? message
                              : 'Reminder request processed.',
                        ),
                      ),
                    );
                  },
            rightBottomItemIcon: AppImages.callIcon,
            rightBottomItemText: 'Contact',
            rightBottomItemBgColor: AppColors.blue,
          ),
        );
      }).toList(),
    );
  }

  Widget _header(InboxProvider provider) {
    final count = provider.sentConnections?.length ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'All Requests ($count)',
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
            .map(
              (item) =>
                  FilterItem(name: item.label, isSelected: item.isSelected),
            )
            .toList(),
        onItemTap: provider.selectFilterTypeIndex,
      ),
    );
  }
}
