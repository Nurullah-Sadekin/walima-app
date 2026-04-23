import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_boilerplate/features/connections/data/models/response/get_accepted_connection_response.dart'
    as accepted_models;
import 'package:flutter_boilerplate/features/connections/presentation/widgets/view_contact_bottom_sheet.dart';
import 'package:flutter_boilerplate/features/inbox/domain/models/menu_item_model.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_card.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_tab_shared.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/text_tab_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InboxAcceptedTab extends ConsumerStatefulWidget {
  const InboxAcceptedTab({super.key});

  @override
  ConsumerState<InboxAcceptedTab> createState() => _InboxAcceptedTabState();
}

class _InboxAcceptedTabState extends ConsumerState<InboxAcceptedTab>
    with SingleTickerProviderStateMixin {
  late final TabController _subTabController;
  final _tabs = const ['Accepted by Her', 'Accepted by Me'];

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _subTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(inboxProvider);
    final receivedItems = provider.acceptedReceivedConnections;
    final sentItems = provider.acceptedSentConnections;

    return Column(
      children: [
        TextTabBar(
          isScrollable: false,
          tabAlignment: TabAlignment.fill,
          controller: _subTabController,
          tabs: _tabs,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [

              _buildTabBody(
                context: context,
                isLoading: provider.isAcceptedLoading,
                isError: provider.isAcceptedHasError,
                errorMessage: provider.acceptedErrorMessage,
                items: sentItems,
                emptyMessage: 'No accepted-by-me requests found',
                onRetry: () => ref.read(inboxProvider).fetchAcceptedConnections(),
                isReceivedDirection: false,
              ),
              _buildTabBody(
                context: context,
                isLoading: provider.isAcceptedLoading,
                isError: provider.isAcceptedHasError,
                errorMessage: provider.acceptedErrorMessage,
                items: receivedItems,
                emptyMessage: 'No accepted-by-her requests found',
                onRetry: () => ref.read(inboxProvider).fetchAcceptedConnections(),
                isReceivedDirection: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBody({
    required BuildContext context,
    required bool isLoading,
    required bool isError,
    required String? errorMessage,
    required List<accepted_models.Data> items,
    required String emptyMessage,
    required VoidCallback onRetry,
    required bool isReceivedDirection,
  }) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError && items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage ?? 'Failed to load accepted connections',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondaryLight),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(inboxProvider).fetchAcceptedConnections(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return InboxCard(
            imagePath: item.profilePhoto?.url ?? AppImages.demoProfile2,
            name: item.displayName ?? 'Unknown',
            subtitleColor: AppColors.primary,
            day: DateTimeUtils.onlyDate(
              DateTime.tryParse(item.connection?.createdAt ?? ''),
            ),
            age: '${item.age} Yr',
            height: CamelCaseUtils.formatCamelCase(item.religion ?? ''),
            onTapWalimaChat: item.id == null
                ? null
                : () {
                    context.pushNamed(
                      Routes.chatScreen,
                      extra: {
                        'conversationId': item.connection?.conversationId,
                        'participant': {
                          'userId': item.id,
                          'displayName': item.displayName,
                          'profilePictureUrl': item.profilePhoto?.url,
                          'isOnline': item.isOnline,
                        },
                      },
                    );
                  },
            onTapMiddleBottomItem:() async{
              if (item.id != null) {
                await BottomSheetUtils.open(
                  context: context,
                  fullHeight: false,
                  child: _contactBottomSheet(item),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User information unavailable.')),
                );
              }
            },
            location: [
              item.location?.city,
              item.location?.state,
              item.location?.country,
            ]
                .whereType<String>()
                .where((value) => value.trim().isNotEmpty)
                .join(', ')
                .isEmpty
                  ? 'N/A'
                  : [
                      item.location?.city,
                      item.location?.state,
                      item.location?.country,
                    ]
                        .whereType<String>()
                        .where((value) => value.trim().isNotEmpty)
                        .join(', '),
            profession: CamelCaseUtils.formatCamelCase(
              item.maritalStatus ?? '',
            ),
            isVerified: item.profilePhoto?.isVerified ?? false,
            isBottomSection: true,
            mood: InboxCardMood.medium,
            menuItems: [
              MenuItem(
                name: isReceivedDirection ? 'Cancel Request' : 'Decline',
                onTap: () => handleMenuAction(
                  context: context,
                  action: isReceivedDirection
                      ? InboxMoreMenuAction.cancelRequest
                      : InboxMoreMenuAction.decline,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _contactBottomSheet(item) {
    final profileImagePath = (item?.profilePhoto?.url?.isNotEmpty ?? false)
        ? item!.profilePhoto!.url!
        : (item?.gender ?? '').toLowerCase() == 'female'
        ? AppImages.womenAvatar
        : AppImages.manAvatar;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ViewContactBottomSheet(
        userId: item?.id ?? '',
        userName: item?.displayName ?? 'Unknown',
        profileImagePath: profileImagePath,
        description: null,
        isDescriptionVisible: false,
      ),
    );
  }

}
