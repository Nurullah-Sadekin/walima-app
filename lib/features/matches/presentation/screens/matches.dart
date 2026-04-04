import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/empty_state.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_boilerplate/core/utils/height_utils.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_matches_response.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/screens/filters/more_matches.dart';
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
  final tabs = const [
    'Search',
    'New',
    'Daily',
    'My Matches',
    'Near Me',
    'More Matches',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchesProvider).loadMatchesForSelectedTab();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(matchesProvider);

    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _appbarSection(),
              Expanded(
                child: Column(
                  spacing: 10,
                  children: [
                    _headerSection(provider),
                    Expanded(child: _tabContent(provider)),
                  ],
                ),
              ),
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

  Widget _headerSection(MatchesProvider provider) {
    return Row(
      children: [
        InkWell(
          onTap: () => _openFilter(provider),
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
        Flexible(child: _customTabBar(provider)),
      ],
    );
  }

  Widget _customTabBar(MatchesProvider provider) {
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
            onTap: () => ref.read(matchesProvider).setSelectedTab(0),
          ),
          TabBarWidget(
            text: tabs[1],
            isSelected: provider.selectedTabIndex == 1,
            onTap: () => ref.read(matchesProvider).setSelectedTab(1),
          ),
          TabBarWidget(
            text: tabs[2],
            isSelected: provider.selectedTabIndex == 2,
            onTap: () => ref.read(matchesProvider).setSelectedTab(2),
          ),
          TabBarWidget(
            text: tabs[3],
            isSelected: provider.selectedTabIndex == 3,
            selectedBackgroundColor: AppColors.primary,
            selectedTextColor: AppColors.white,
            selectedBorderColor: AppColors.primary,
            onTap: () => ref.read(matchesProvider).setSelectedTab(3),
          ),
          TabBarWidget(
            text: tabs[4],
            isSelected: provider.selectedTabIndex == 4,
            selectedBackgroundColor: AppColors.primary,
            onTap: () => ref.read(matchesProvider).setSelectedTab(4),
          ),
          TabBarWidget(
            text: tabs[5],
            isSelected: provider.selectedTabIndex == 5,
            onTap: () => ref.read(matchesProvider).setSelectedTab(5),
          ),
        ],
      ),
    );
  }

  Widget _tabContent(MatchesProvider provider) {
    if (provider.isLoadingMatches && provider.matches.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.matchesError != null && provider.matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyStateWidget(
              title: '${provider.selectedTabTitle} Unavailable',
              subtitle: provider.matchesError!,
              buttonText: 'Retry',
              onTap: () => ref.read(matchesProvider).loadMatchesForSelectedTab(
                    force: true,
                  ),
            ),
            if (provider.apiError != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: TextSize.font16(context)),
                Text(
                  'Error fetching data from server:',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: TextSize.font18(context),
                  ),
                ),
                Text(
                  provider.apiError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: TextSize.font14(context),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 12),
            // ElevatedButton(
            //   onPressed: () => ref.read(matchesProvider).loadMatchesForSelectedTab(force: true,),
            //   child: const Text('Retry'),
            // ),
          ],
        ),
      );
    }

    if (provider.matches.isEmpty) {
      return EmptyStateWidget(
        title: 'No ${provider.selectedTabTitle} Matches Yet',
        subtitle:
            'We could not find any profiles for this section right now. Try changing your filters and check again.',
        buttonText: 'Refresh',
        onTap: () => ref.read(matchesProvider).loadMatchesForSelectedTab(
              force: true,
            ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(matchesProvider).loadMatchesForSelectedTab(
            force: true,
          ),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: provider.matches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final match = provider.matches[index];
          return ProfileComprehensiveCard(
            imagePath: match.profilePhoto?.url ?? AppImages.demoProfile,
            leftIconPath: AppImages.favouriteIcon,
            isPremiumConnect: match.isPremium ?? false,
            isVerified: match.profilePhoto?.isVerified ?? false,
            name: match.displayName ?? 'Unknown',
            age: match.age != null ? '${match.age} Yr' : null,
            height: HeightUtils.formatHeight(match.height.toString()),
            location: _matchLocation(match),
            activeStatusText: _activeStatusText(match),
            menu: true,
            photoRequest: false,
            photoCount: '1',
            profession: CamelCaseUtils.formatCamelCase(match.maritalStatus ?? ''),
            maritalStatus: CamelCaseUtils.formatCamelCase(match.community ?? ''),
            religion: CamelCaseUtils.formatCamelCase(match.religion ?? ''),
            noButton: false,
            onTapLeftButton: () {
              // Handle left button tap
            },
            onTapRightButton: () {
              // Handle right button tap
            },
            isOnline: match.isOnline ?? false,
            viewOnAccept: match.profilePhoto?.visibilityStatus?.toLowerCase() != 'public',
          );
        },
      ),
    );
  }

  String _activeStatusText(MatchProfile match) {
    if (match.isOnline == true) {
      return 'Online';
    }
    if (match.lastSeenAt != null && match.lastSeenAt!.isNotEmpty) {
      return DateTimeUtils.formatDate(DateTime.tryParse(match.lastSeenAt!));
    }
    return 'Offline';
  }

  String _matchLocation(MatchProfile match) {
    final parts = [
      match.location?.city,
      match.location?.state,
      match.location?.country,
    ]
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .toList();

    return parts.isEmpty ? 'N/A' : parts.join(', ');
  }

  String _matchHeight(num? height) {
    if (height == null) return 'N/A';
    return '$height';
  }

  Future<void> _openFilter(MatchesProvider provider) async {
    dynamic result;

    if (provider.selectedTabIndex == 0) {
      result = await context.push(Paths.searchFilter);
      if (result is Map<String, dynamic>) {
        await ref.read(matchesProvider).applySearchFilters(result);
      }
      return;
    }

    if (provider.selectedTabIndex == 1) {
      result = await context.push(Paths.newFilter);
      if (result is Map<String, dynamic>) {
        await ref.read(matchesProvider).applyNewFilters(result);
      }
      return;
    }

    if (provider.selectedTabIndex == 3) {
      result = await context.push(Paths.myMatchFilter);
      if (result is Map<String, dynamic>) {
        await ref.read(matchesProvider).applyMyMatchesFilters(result);
      }
      return;
    }

    if (provider.selectedTabIndex == 5) {
      result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const MoreMatchesScreen(),
        ),
      );
      if (result is Map<String, dynamic>) {
        await ref.read(matchesProvider).applyMoreMatchesFilters(result);
      }
      return;
    }

    await _sortFilterSheet(context, provider);
  }

  Future<void> _sortFilterSheet(
    BuildContext context,
    MatchesProvider provider,
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
                        name: item.name,
                        isSelected: item.isSelected,
                      ),
                    )
                    .toList(),
                onItemTap: (index) async {
                  await ref.read(matchesProvider).sortBy(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
