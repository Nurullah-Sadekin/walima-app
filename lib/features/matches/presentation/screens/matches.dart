import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/accepted_card.dart';
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
import 'package:flutter_boilerplate/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
   MatchesProvider provider = MatchesProvider();

  @override
  void initState() {
    super.initState();
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
              _body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbarSection() {
    return AnchoredAppBar(
      title: 'Matches',
      notificationCount: 26,
      context: context,
    );
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(spacing: 10, children: [

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                TabBarWidget(
                  text: 'Search',
                  isSelected: true,
                  prefixImagePath: AppImages.searchSvgIcon,
                  onTap: () {
                    // Handle tap
                  },
                ),
                TabBarWidget(
                  text: 'New',
                  onTap: () {},
                ),
                TabBarWidget(
                  text: 'Daily',
                  count: 28,
                  onTap: () {},
                ),
                TabBarWidget(
                  text: 'My Matches',
                  isSelected: false,
                  selectedBackgroundColor: AppColors.primary,
                  selectedTextColor: AppColors.white,
                  selectedBorderColor: AppColors.primary,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const AcceptedCard(
            imagePath: AppImages.demoProfile,
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
        ]),
      ),
    );
  }
}
