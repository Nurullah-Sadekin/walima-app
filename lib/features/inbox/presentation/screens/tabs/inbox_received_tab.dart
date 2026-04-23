import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/empty_state.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxReceivedTab extends ConsumerStatefulWidget {
  const InboxReceivedTab({
    super.key,
    this.onExploreAcceptedTap,
  });

  final VoidCallback? onExploreAcceptedTap;

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
          if (provider.receivedConnections != null &&
              provider.receivedConnections!.isNotEmpty)
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
             EmptyStateWidget(
              imagePath: AppImages.addTeam,
              title: 'Error Loading Requests',
              subtitle: 'Unable to load your connection requests',
              buttonText: 'Retry',
              onTap:  () {
                provider.fetchRequestedConnections();
              },
            ),

          ],
        ),
      );
    }

    // Show empty state
    if (provider.receivedConnections?.isEmpty ?? true) {
      return Center(
        child: EmptyStateWidget(
          imagePath: AppImages.addTeam,
          title: 'No Pending Requests!',
          subtitle:
              'Take the next step view your accepted matches for better connections',
          buttonText: 'Explore Accepted Matches',
          onTap: widget.onExploreAcceptedTap,
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

                final success =
                    await ref.read(inboxProvider).respondToRequestedConnection(
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

                final success =
                    await ref.read(inboxProvider).respondToRequestedConnection(
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
              rightButtonText: isUpdatingThisCard ? 'Please wait...' : 'Reject',
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
    final headerTitle = provider.receivedFilterHeaderTitle();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$headerTitle ($count)',
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
      child: FilterWidget(
        title: 'Filter Requests',
        iconPath: AppImages.filterSvgIcon,
        items: provider.receivedFilterList
            .map(
              (item) => FilterItem(name: item.label, isSelected: false),
            )
            .toList(),
        onItemTap: (index) async {
          final filterValue = provider.receivedFilterValueAt(index);
          if (filterValue == null) return;

          Navigator.of(context).pop();
          await ref.read(inboxProvider).applyReceivedFilter(filterValue);
        },
      ),
    );
  }
}
