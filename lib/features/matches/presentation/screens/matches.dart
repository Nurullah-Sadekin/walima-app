import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/accepted_card.dart';
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
  final tabs = ['Search', 'New', 'Daily', 'My Matches'];

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
              Expanded(child: _body()),
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
    return Column(spacing: 10, children: [
      _headerSection(),
      Expanded(child: _tabBarViewSection()),
    ]);
  }

  Widget _headerSection() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            // Handle filter tap
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.greyLight),
            ),
            child: ShowImage(
              imagePath: AppImages.filterSvgIcon,
              height: TextSize.font16(context),
              width: TextSize.font16(context),
            ),
          ),
        ),
        SizedBox(
          height: TextSize.font28(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: VerticalDivider(
              thickness: 1,
              color: AppColors.greyLight,
            ),
          ),
        ),
        Flexible(child: _customTabBar()),
      ],
    );
  }

  Widget _customTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          TabBarWidget(
            text: tabs[0],
            isSelected: provider.selectedTabIndex == 0,
            prefixImagePath: AppImages.searchSvgIcon,
            onTap: () => provider.setSelectedTab(0),
          ),
          TabBarWidget(
            text: tabs[1],
            isSelected: provider.selectedTabIndex == 1,
            onTap: () => provider.setSelectedTab(1),
          ),
          TabBarWidget(
            text: tabs[2],
            count: 28,
            isSelected: provider.selectedTabIndex == 2,
            onTap: () => provider.setSelectedTab(2),
          ),
          TabBarWidget(
            text: tabs[3],
            isSelected: provider.selectedTabIndex == 3,
            selectedBackgroundColor: AppColors.primary,
            selectedTextColor: AppColors.white,
            selectedBorderColor: AppColors.primary,
            onTap: () => provider.setSelectedTab(3),
          ),
        ],
      ),
    );
  }

  Widget _tabBarViewSection() {
    return Builder(builder: (context) {
      switch (provider.selectedTabIndex) {
        case 0:
          return _searchTabContent();
        case 1:
          return _newTabContent();
        case 2:
          return _dailyTabContent();
        case 3:
          return _myMatchesContent();
        default:
          return _searchTabContent();
      }
    });
  }

  Widget _searchTabContent() {
    return const ProfileComprehensiveCard(
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
    );
  }

  Widget _newTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 8),
        Text('New tab content'),
      ],
    );
  }

  Widget _dailyTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 8),
        Text('Daily tab content'),
      ],
    );
  }

  Widget _myMatchesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 8),
        Text('My Matches content'),
      ],
    );
  }
}
