import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/count_down_timer.dart';
import 'package:flutter_boilerplate/core/global/components/empty_state.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/filter_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  MatchesProvider provider = MatchesProvider();
  final tabs = [
    'Search',
    'New',
    'Daily',
    'My Matches',
    'Near Me',
    'More Matches'
  ];

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
      onNotificationPressed: () => context.pushNamed(Routes.notifications),
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
            if (provider.selectedTabIndex == 0) {
              // Search tab
              context.push(Paths.searchFilter);
            } else if (provider.selectedTabIndex == 1) {
              // New tab
              context.push(Paths.newFilter);
            } else if (provider.selectedTabIndex == 3) {
              // My Matches tab -> open myMatch filter screen
              context.push(Paths.myMatchFilter);
            } else {
              _filter(context);
            }
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
          TabBarWidget(
            text: tabs[4],
            isSelected: provider.selectedTabIndex == 4,
            selectedBackgroundColor: AppColors.primary,
            onTap: () => provider.setSelectedTab(4),
          ),
          TabBarWidget(
            text: tabs[5],
            isSelected: provider.selectedTabIndex == 5,
            onTap: () => provider.setSelectedTab(5),
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
        case 4:
          return _nearMeContent();
        case 5:
          return _moreMatchesContent();
        default:
          return _searchTabContent();
      }
    });
  }

  Widget _searchTabContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(
          10,
          (index) => const Padding(
            padding: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: ProfileComprehensiveCard(
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
          ),
        ),
      ),
    );
  }

  Widget _newTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _newTabEmptyView(),
      ],
    );
  }

  Widget _newTabEmptyView() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        EmptyStateWidget(
          title: 'No Matches Yet!',
          subtitle:
              'We do not have new matches at this point. Checkout my matches to find profiles matching your preference',
          buttonText: 'My Matches',
          onTap: null,
        ),
      ],
    );
  }

  Widget _dailyTabContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        CountdownTimer(
          initialHours: 8,
          initialMinutes: 24,
          initialSeconds: 48,
        ),
        SizedBox(height: 30),
        EmptyStateWidget(
            title: 'Sorry!',
            subtitle:
                'No today’s matches found. Please try again till then, search for your partner.',
            buttonText: 'Search Now')
      ],
    );
  }

  Widget _myMatchesContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(
          10,
          (index) => const Padding(
            padding: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: ProfileComprehensiveCard(
              imagePath: AppImages.demoProfile,
              leftIconPath: AppImages.favouriteIcon,
              isPremiumConnect: true,
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
              profession: 'Software Engineer',
              maritalStatus: 'Never Married',
              religion: 'Islam',
            ),
          ),
        ),
      ),
    );
  }

  Widget _nearMeContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text('Near Me content'),
      ],
    );
  }

  Widget _moreMatchesContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text('More Matches content'),
      ],
    );
  }

  Future<void> _filter(
    BuildContext context,
  ) async {
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
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(sheetCtx).pop(),
                    child: ShowImage(
                      imagePath: AppImages.cancelSvgIcon,
                      height: TextSize.font24(sheetCtx),
                      width: TextSize.font24(sheetCtx),
                    ),
                  ),
                ],
              ),
              FilterWidget(
                title: 'Filter',
                iconPath: AppImages.filterSvgIcon,
                items: provider.sortByDataList
                    .map(
                      (item) => FilterItem(
                          name: item.name, isSelected: item.isSelected),
                    )
                    .toList(),
                onItemTap: (index) {
                  provider.sortBy(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
