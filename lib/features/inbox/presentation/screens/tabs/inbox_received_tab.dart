import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/empty_state.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
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
        children: [
          _header(provider),
          if (provider.screenStates == InboxScreenStates.loading ||
              provider.loaderState == InboxScreenStates.transparentLoading)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: LinearProgressIndicator(
                minHeight: 2,
                color: AppColors.primary,
                backgroundColor: AppColors.greyLight,
              ),
            ),
          const SizedBox(height: 10),
          _body(provider),
        ],
      ),
    );
  }

  Widget _body(InboxProvider provider) {
    // Show loading state
    if (provider.isLoading && (provider.receivedConnections?.isEmpty ?? true)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show error state
    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyStateWidget(
              imagePath: AppImages.addTeam,
              title: 'Error Loading Requests',
              subtitle: 'Unable to load your connection requests',
              buttonText: 'Retry',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.fetchRequestedConnections();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (provider.receivedConnections?.isEmpty ?? true) {
      return const Center(
        child: EmptyStateWidget(
          imagePath: AppImages.addTeam,
          title: 'No Pending Requests!',
          subtitle:
              'Take the next step view your accepted matches for better connections',
          buttonText: 'Explore Accepted Matches',
        ),
      );
    }

    // Show list of received connections
    return Column(
      children: [
        ...provider.receivedConnections!.map((connection) {
          final connectionId = connection.connection?.id ?? '';
          final isUpdatingThisCard = provider.isUpdatingReceivedConnection &&
              provider.updatingReceivedConnectionId == connectionId;
          final age = connection.age.toString();
          final name = connection.displayName ?? 'Unknown';
          final city = connection.location?.city ?? '';
          final state = connection.location?.state ?? '';
          final locationText =
              [city, state].where((s) => s.isNotEmpty).join(', ');
          final location =
              locationText.isNotEmpty ? locationText : 'Location: Undefine';
          final profilePhotoUrl =
              connection.profilePhoto?.url ?? AppImages.demoProfile;
          final isVerified = connection.profilePhoto?.isVerified ?? false;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProfileComprehensiveCard(
              imagePath: profilePhotoUrl,
              leftIconPath: AppImages.favouriteIcon,
              isVerified: isVerified,
              name: name,
              viewOnAccept:
                  connection.profilePhoto?.visibilityStatus == 'visible'
                      ? false
                      : true,
              age: '$age Yr',
              height: CamelCaseUtils.formatCamelCase(
                connection.maritalStatus ?? '',
              ),
              location: location,
              activeStatusText: DateTimeUtils.formatDate(
                DateTime.tryParse(connection.lastSeenAt ?? ''),
              ),
              isOnline: connection.isOnline ?? false,
              menu: false,
              onTapLeftButton: () async {
                if (isUpdatingThisCard) return;

                final success = await ref
                    .read(inboxProvider)
                    .respondToRequestedConnection(
                      connection: connection,
                      status: 'accept',
                    );

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Connection accepted successfully'
                          : provider.receivedActionErrorMessage ??
                              'Failed to accept connection',
                    ),
                  ),
                );
              },
              onTapRightButton: () async {
                if (isUpdatingThisCard) return;

                final success = await ref
                    .read(inboxProvider)
                    .respondToRequestedConnection(
                      connection: connection,
                      status: 'reject',
                    );

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Connection request removed successfully'
                          : provider.receivedActionErrorMessage ??
                              'Failed to remove connection request',
                    ),
                  ),
                );
              },
              leftButtonText: 'Accept',
              rightButtonText:
                  isUpdatingThisCard ? 'Please wait...' : 'Reject',
              rightIconPath: AppImages.cancelSvgIcon,
            ),
          );
        }),
      ],
    );
  }

  Widget _header(InboxProvider provider) {
    final count = provider.totalItems! > 0
        ? provider.totalItems
        : provider.receivedConnections?.length ?? 0;
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
        ),
      ],
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
              provider.switcherStatusUpdate();
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 8.0, 0, 16.0),
            child: Divider(color: AppColors.greyLight, thickness: 1),
          ),
          FilterWidget(
            title: 'Sort by',
            iconPath: AppImages.sortIcon,
            items: provider.sortList
                .map(
                  (item) => FilterItem(
                    name: item.label,
                    isSelected: item.isSelected,
                  ),
                )
                .toList(),
            onItemTap: provider.selectSortOrderIndex,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Divider(color: AppColors.greyLight, thickness: 1),
          ),
          FilterWidget(
            title: 'Filter by',
            iconPath: AppImages.filterSvgIcon,
            items: provider.filterList
                .map(
                  (item) => FilterItem(
                    name: item.label,
                    isSelected: item.isSelected,
                  ),
                )
                .toList(),
            onItemTap: provider.selectFilterTypeIndex,
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: PrimaryButtons(
                  buttonStyle: ButtonsStyle.cancelButton,
                  onTap: () {},
                  title: 'Reset',
                ),
              ),
              Expanded(
                child: PrimaryButtons(
                  buttonStyle: ButtonsStyle.activePrimaryButton,
                  onTap: () {},
                  title: 'Apply',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
