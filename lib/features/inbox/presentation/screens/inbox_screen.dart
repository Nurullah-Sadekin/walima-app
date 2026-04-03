import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet_widget/contacts_viewed.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/inbox_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/text_tab_bar.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/count_down_timer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/empty_state.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/image_carousel.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/info_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/message_bubble.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/new_matches_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/remind_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/safety_first_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with TickerProviderStateMixin {
  late final TabController _primaryTabController;
  late final TabController _acceptedSubTabController;
  late final TabController _contactsSubTabController;

  final _primaryTabs = const [
    'Received',
    'Accepted',
    'Contacts',
    'Sent',
    'More'
  ];
  final _acceptedTabs = const ['Accepted by Her', 'Accepted by Me'];
  final _contactsTabs = const ['Contacts Received', 'Contacts Sent'];

  InboxProvider provider = InboxProvider();

  @override
  void initState() {
    super.initState();
    _primaryTabController =
        TabController(initialIndex: 0, length: 5, vsync: this)
          ..addListener(_handlePrimaryTabChange);
    _acceptedSubTabController =
        TabController(initialIndex: 0, length: 2, vsync: this);
    _contactsSubTabController =
        TabController(initialIndex: 0, length: 2, vsync: this);
    provider = ref.read(inboxProvider);
  }

  void _handlePrimaryTabChange() {
    if (!mounted || _primaryTabController.indexIsChanging) return;
    setState(() {});
  }

  @override
  void dispose() {
    _primaryTabController.removeListener(_handlePrimaryTabChange);
    _primaryTabController.dispose();
    _acceptedSubTabController.dispose();
    _contactsSubTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(inboxProvider);
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _appbarSection(),
              Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbarSection() {
    return AnchoredAppBar(
      title: 'Inbox',
      notificationCount: 26,
      context: context,
      onNotificationPressed: () => context.pushNamed(Routes.notifications),
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPrimaryTabs(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TabBarView(
              controller: _primaryTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _receivedTab(),
                _acceptedTab(),
                _contactsTab(),
                _sentTab(),
                _moreTab(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          TabBarWidget(
            text: _primaryTabs[0],
            isSelected: _primaryTabController.index == 0,
            onTap: () => _primaryTabController.animateTo(0),
          ),
          TabBarWidget(
            text: _primaryTabs[1],
            isSelected: _primaryTabController.index == 1,
            onTap: () => _primaryTabController.animateTo(1),
          ),
          TabBarWidget(
            text: _primaryTabs[2],
            isSelected: _primaryTabController.index == 2,
            onTap: () => _primaryTabController.animateTo(2),
          ),
          TabBarWidget(
            text: _primaryTabs[3],
            isSelected: _primaryTabController.index == 3,
            selectedBackgroundColor: AppColors.primary,
            selectedTextColor: AppColors.white,
            selectedBorderColor: AppColors.primary,
            onTap: () => _primaryTabController.animateTo(3),
          ),
          TabBarWidget(
            text: _primaryTabs[4],
            isSelected: _primaryTabController.index == 4,
            selectedBackgroundColor: AppColors.primary,
            selectedTextColor: AppColors.white,
            selectedBorderColor: AppColors.primary,
            onTap: () => _primaryTabController.animateTo(4),
          ),
        ],
      ),
    );
  }

  Widget _receivedTab() {
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
                        return _receivedFilter(
                            ref.watch(inboxProvider), context);
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
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
          const ProfileComprehensiveCard(
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
            photoRequest: false,
            onTapLeftButton: null,
            onTapRightButton: null,
            photoCount: '1',
            leftButtonText: 'Accept',
            rightButtonText: 'Reject',
            rightIconPath: AppImages.cancelSvgIcon,
          ),
        ],
      ),
    );
  }

  Widget _acceptedTab() {
    return Column(
      children: [
        TextTabBar(
          isScrollable: false,
          tabAlignment: TabAlignment.fill,
          controller: _acceptedSubTabController,
          onTabChange: (_) {},
          tabs: _acceptedTabs,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _acceptedSubTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _receivedBody(),
              _acceptedByMe(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contactsTab() {
    return Column(
      children: [
        TextTabBar(
          isScrollable: false,
          tabAlignment: TabAlignment.fill,
          controller: _contactsSubTabController,
          onTabChange: (_) {},
          tabs: _contactsTabs,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _contactsSubTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _contactsReceived(),
              _contactsSent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sentTab() {
    return _buildSimplePlaceholder(
      title: 'Sent',
      subtitle: 'All sent inbox items will appear here.',
    );
  }

  Widget _moreTab() {
    return _buildSimplePlaceholder(
      title: 'More',
      subtitle: 'More inbox options will appear here.',
    );
  }

  Widget _contactsReceived() {
    return _buildSimplePlaceholder(
      title: 'Contacts Received',
      subtitle: 'Profiles that contacted you will appear here.',
    );
  }

  Widget _contactsSent() {
    return _buildSimplePlaceholder(
      title: 'Contacts Sent',
      subtitle: 'Profiles you contacted will appear here.',
    );
  }

  Widget _buildSimplePlaceholder({
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receivedBody() {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          InboxCard(
            onMenuTap: (details) {
              _showInboxMoreMenu(
                details.globalPosition,
                imagePath: AppImages.demoProfile2,
                displayName: 'Tasnova Ahmed',
              );
            },
            imagePath: AppImages.demoProfile2,
            name: 'Tasnova Ahmed',
            age: '28 Yr',
            height: '5\' 3\'" ',
            day: 'Today',
            location: 'Gulshan, Dhaka, BD',
            profession: 'Software Engineer',
            isVerified: true,
          ),
          _dummyWidgets(),
        ],
      ),
    );
  }

  Widget _acceptedByMe() {
    return Container(
      color: Colors.blue,
      child: const Center(child: Text('Accepted by Me')),
    );
  }

  Widget _receivedFilter(
    InboxProvider provider,
    BuildContext context,
  ) {
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
            child: Divider(
              color: AppColors.greyLight,
              thickness: 1,
            ),
          ),
          FilterWidget(
            title: 'Sort by',
            iconPath: AppImages.sortIcon,
            items: provider.sortByDataList
                .map(
                  (item) =>
                      FilterItem(name: item.name, isSelected: item.isSelected),
                )
                .toList(),
            onItemTap: (index) {
              provider.sortBy(index);
            },
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Divider(
              color: AppColors.greyLight,
              thickness: 1,
            ),
          ),
          FilterWidget(
            title: 'Filter by',
            iconPath: AppImages.filterSvgIcon,
            items: provider.sortByDataList
                .map(
                  (item) =>
                      FilterItem(name: item.name, isSelected: item.isSelected),
                )
                .toList(),
            onItemTap: (index) {
              provider.sortBy(index);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showInboxMoreMenu(
    Offset tapPosition, {
    required String imagePath,
    required String displayName,
  }) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final selectedAction = await showMenu<InboxMoreMenuAction>(
      context: context,
      color: Colors.white,
      elevation: 8,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: InboxMoreMenuAction.decline,
          height: 32,
          padding: const EdgeInsets.fromLTRB(16, 10, 35, 10),
          child: Text(
            'Decline',
            style: TextStyle(
              fontSize: TextSize.font12(context),
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );

    if (selectedAction == null) return;
    _handleInboxMoreMenuAction(selectedAction, imagePath, displayName);
  }

  void _handleInboxMoreMenuAction(
    InboxMoreMenuAction action,
    String imagePath,
    String displayName,
  ) {
    switch (action) {
      case InboxMoreMenuAction.decline:
        break;
    }
  }

  Widget _dummyWidgets() {
    return Column(
      children: [
        const ContactsViewed(
          profileImage: AppImages.demoProfile,
        ),
        InboxCard(
          onMenuTap: (details) {
            _showInboxMoreMenu(
              details.globalPosition,
              imagePath: AppImages.demoProfile2,
              displayName: 'Tasnova Ahmed',
            );
          },
          imagePath: AppImages.demoProfile2,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          day: 'Today',
          location: 'Gulshan, Dhaka, BD',
          isVerified: true,
        ),
        InfoTile(
          title: 'Country Living in',
          value: 'Bangladesh',
          leadingImagePath: AppImages.favouriteIcon,
          trailingImagePath: AppImages.editWrite,
          onTap: () => print('Edit tapped'),
        ),
        SettingsSwitchTile(
          title: 'Notifications',
          subtitle: 'Receive push notifications',
          value: provider.switcherValue ?? false,
          onChanged: (newValue) {
            provider.switcherValue = newValue;
            provider.updateViewState();
          },
        ),
        SettingsSwitchTile(
          title: 'More Matches',
          value: provider.switcherValue ?? false,
          trailingImage: AppImages.cardView,
          showTrailingImage: true,
          onChanged: (newValue) {
            provider.switcherValue = newValue;
            provider.updateViewState();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const CountdownTimer(
          initialHours: 8,
          initialMinutes: 24,
          initialSeconds: 48,
        ),
        EmptyStateWidget(
          title: 'No Matches Yet!',
          imagePath: AppImages.viewOnAccept,
          subtitle:
              'We do not have new matches at this point. Checkout my matches to find profiles matching your preference',
          buttonText: 'My Matches',
          onTap: () {
            // Navigate to matches screen
          },
        ),
        const InfoCardWidget(
          title: 'Profiles Matching Your Preferences',
          description:
              'Some profiles may not match all your preferences, but you might find meaningful connections.',
        ),
        SelectionCard(
          buttonStyle: SelectionStyle.selectedCheckbox,
          onTap: () {},
          title: 'Open to All',
          isExpand: true,
        ),
        RemindCard(
          onTap: () {},
          imagePath: AppImages.demoProfile,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          location: 'Gulshan, Dhaka, BD',
          isVerified: true,
        ),
        RemindCard(
          onTap: () {},
          imagePath: AppImages.demoProfile,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          location: 'Gulshan, Dhaka, BD',
          isVerified: true,
          singleButton: false,
        ),
        const MessageBubble(
          message:
              'Hello, I have liked your profile and believe it to be a good Match. If you like my profile too, kindly accept this Invitation. Please feel free to contact me to take this conversation ahead. Warm Regards, Mehedi Hasan',
          senderName: 'Mehedi Hasan',
          showSenderName: true,
        ),
        const SafetyTipCard(),
        const ImageCarousel(
          images: [
            CarouselImage(imagePath: AppImages.demoProfile, isBlur: false),
            CarouselImage(imagePath: AppImages.demoProfile2, isBlur: true),
            CarouselImage(imagePath: AppImages.demoProfile, isBlur: true),
            CarouselImage(imagePath: AppImages.demoProfile2, isBlur: true),
            CarouselImage(imagePath: AppImages.demoProfile, isBlur: true),
            CarouselImage(imagePath: AppImages.demoProfile2, isBlur: true),
          ],
        ),
        const ProfileComprehensiveCard(
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
          photoRequest: true,
          onTapLeftButton: null,
          onTapRightButton: null,
          photoCount: '1',
          profession: 'Software Engineer',
          maritalStatus: 'Never Married',
          religion: 'Islam',
        ),
        const NewMatchesCard(
          imagePath: AppImages.demoProfile,
          isPremiumConnect: true,
          isVerified: true,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          location: 'Gulshan, Dhaka, BD',
          activeStatusText: '1 day ago',
          menu: true,
          photoRequest: false,
          photoCount: '1',
        ),
      ],
    );
  }
}

enum InboxMoreMenuAction {decline}
