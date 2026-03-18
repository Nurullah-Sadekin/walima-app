import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet_widget/contacts_viewed.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/accepted_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/text_tab_bar.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/count_down_timer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/empty_state.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/image_carousel.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/info_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/message_bubble.dart';
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

class _InboxScreenState extends ConsumerState<InboxScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _tabs = const ['Accepted by Her', 'Accepted by Me'];

  MatchesProvider provider = MatchesProvider();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    provider = ref.read(matchesProvider);
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(matchesProvider);
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
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextTabBar(
            isScrollable: false,
            tabAlignment: TabAlignment.fill,
            controller: _tabController,
            onTabChange: (index) {
              //provider?.updateTab(index: index);
            },
            tabs: _tabs),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _tabBarView(),
          ),
        )
      ],
    );
  }

  Widget _tabBarView() {
    return TabBarView(
      controller: _tabController,
      physics: const ScrollPhysics(
        parent: NeverScrollableScrollPhysics(),
      ),
      children: [
        _acceptedByHer(),
        _acceptedByMe(),
      ],
    );
  }

  Widget _acceptedByHer() {
    return  SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          ContactsViewed(
            profileImage: AppImages.demoProfile,
          ),
          AcceptedCard(
            onMenuTap: () {
               _showAcceptedMenu(context,
                   imagePath: AppImages.demoProfile2,
                   name: 'Tasnova Ahmed');
            },
            imagePath: AppImages.demoProfile2,
            name: 'Tasnova Ahmed',
            age: '28 Yr',
            height: '5\' 3\'" ',
            day: 'Today',
            location: 'Gulshan, Dhaka, BD',
            isVerified: true,
          ),
      
          FilterWidget(
            title: 'Sort by',
            iconPath: AppImages.sortIcon,
            items: provider.sortByDataList.map((item) =>
                FilterItem(name: item.name, isSelected: item.isSelected),).toList(),
            onItemTap: (index) {
              provider.sortBy(index);
            },
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
      ),
    );
  }

  Widget _acceptedByMe() {
    return Container(
      color: Colors.blue,
      child: const Center(child: Text('Accepted by Me')),
    );
  }

  Future<void> _showAcceptedMenu(BuildContext context, {required String imagePath, required String name}) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShowImage(imagePath: imagePath, width: 56, height: 56, radius: BorderRadius.circular(8)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Gulshan, Dhaka, BD',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('View Profile'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  // TODO: Navigate to profile screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.message_outlined),
                title: const Text('Send Message'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  // TODO: Open chat screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Remove Match'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  // TODO: Call provider to remove match
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(sheetCtx).pop(),
                child: Center(
                  child: Text('Cancel', style: TextStyle(color: AppColors.textSecondaryLight)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
