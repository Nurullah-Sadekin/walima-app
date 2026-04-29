import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/empty_state.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/camel_case_utils.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_boilerplate/core/utils/height_utils.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/connections/presentation/widgets/view_contact_bottom_sheet.dart';
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
    'Today',
    'My Matches',
    'Near Me',
    'More Matches',
  ];
  final ScrollController _tabScrollController = ScrollController();
  late final List<GlobalKey> _tabKeys;
  int? _lastCenteredTabIndex;

  @override
  void initState() {
    super.initState();
    _tabKeys = List.generate(tabs.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchesProvider).loadMatchesForSelectedTab();
      _centerSelectedTab(ref.read(matchesProvider).selectedTabIndex);
    });
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(matchesProvider);

    if (_lastCenteredTabIndex != provider.selectedTabIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerSelectedTab(provider.selectedTabIndex);
      });
    }

    return TransparentLoading(
      isLoading: provider.screenStates ==
          MatchesProviderScreenStates.transParentLoading,
      child: Scaffold(
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
        if (provider.selectedTabIndex != 2 &&
            provider.selectedTabIndex != 4) ...[
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
        ],
        Flexible(child: _customTabBar(provider)),
      ],
    );
  }

  Widget _customTabBar(MatchesProvider provider) {
    return SingleChildScrollView(
      controller: _tabScrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          _buildTabItem(
            index: 0,
            provider: provider,
            prefixImagePath: AppImages.searchSvgIcon,
          ),
          _buildTabItem(index: 1, provider: provider),
          _buildTabItem(index: 2, provider: provider),
          _buildTabItem(
            index: 3,
            provider: provider,
            selectedBackgroundColor: AppColors.primary,
            selectedTextColor: AppColors.white,
            selectedBorderColor: AppColors.primary,
          ),
          _buildTabItem(
            index: 4,
            provider: provider,
            selectedBackgroundColor: AppColors.primary,
          ),
          _buildTabItem(index: 5, provider: provider),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required MatchesProvider provider,
    String? prefixImagePath,
    Color? selectedBackgroundColor,
    Color? selectedTextColor,
    Color? selectedBorderColor,
  }) {
    return Container(
      key: _tabKeys[index],
      child: TabBarWidget(
        text: tabs[index],
        isSelected: provider.selectedTabIndex == index,
        prefixImagePath: prefixImagePath,
        selectedBackgroundColor: selectedBackgroundColor,
        selectedTextColor: selectedTextColor,
        selectedBorderColor: selectedBorderColor,
        onTap: () => ref.read(matchesProvider).setSelectedTab(index),
      ),
    );
  }

  void _centerSelectedTab(int index) {
    if (!_tabScrollController.hasClients ||
        index < 0 ||
        index >= _tabKeys.length) {
      return;
    }

    final tabContext = _tabKeys[index].currentContext;
    final scrollableContext =
        _tabScrollController.position.context.storageContext;
    if (tabContext == null) return;

    final tabBox = tabContext.findRenderObject() as RenderBox?;
    final scrollBox = scrollableContext.findRenderObject() as RenderBox?;
    if (tabBox == null || scrollBox == null) return;

    final tabOffset = tabBox.localToGlobal(Offset.zero, ancestor: scrollBox).dx;
    final targetOffset = _tabScrollController.offset +
        tabOffset -
        ((scrollBox.size.width - tabBox.size.width) / 2);

    final clampedOffset = targetOffset.clamp(
      _tabScrollController.position.minScrollExtent,
      _tabScrollController.position.maxScrollExtent,
    );

    _lastCenteredTabIndex = index;
    _tabScrollController.animateTo(
      clampedOffset.toDouble(),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
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
      onRefresh: () =>
          ref.read(matchesProvider).loadMatchesForSelectedTab(force: true),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: provider.matches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final match = provider.matches[index];
          final imagePath = match.profilePhoto?.url ??
              (match.gender == 'female'
                  ? AppImages.womenAvatar
                  : AppImages.manAvatar);
          return ProfileComprehensiveCard(
              onTapCard: () {
                context.pushNamed(Routes.profilePreview, extra: {'userId': match.id});
              },
            imagePath: imagePath,
            leftIconPath: AppImages.favouriteIcon,
            isPremiumConnect: match.isPremium ?? false,
            isVerified: match.profilePhoto?.isVerified ?? false,
            name: match.displayName ?? 'Unknown',
            age: match.age != null ? '${match.age} Yr' : null,
            height: HeightUtils.formatHeight(match.height.toString()),
            location: _matchLocation(match),
            activeStatusText: _activeStatusText(match),
            menu: false,
            photoRequest: false,
            profession:
                CamelCaseUtils.formatCamelCase(match.maritalStatus ?? ''),
            maritalStatus:
                CamelCaseUtils.formatCamelCase(match.community ?? ''),
            religion: CamelCaseUtils.formatCamelCase(match.religion ?? ''),
            noButton: false,
            onTapLeftButton: () async {
              provider.updateViewState(
                screenStates: MatchesProviderScreenStates.transParentLoading,
              );
              await ref.read(homeProvider).connect(
                    context,
                    match.id ?? '',
                    match.displayName ?? 'Unknown',
                    ConnectionRequestType.match.apiValue,
                  );
              await ref
                  .read(matchesProvider)
                  .loadMatchesForSelectedTab(force: true);
            },
            leftButtonColor: match.connection?.status == 'none'
                ? AppColors.greenButtonColor
                : AppColors.disableBackground,
            leftButtonTextColor: match.connection?.status == 'none'
                ? AppColors.white
                : AppColors.disableText,
            leftButtonIconColor: match.connection?.status == 'none'
                ? AppColors.white
                : AppColors.disableText,
            leftButtonBorderColor: match.connection?.status == 'none'
                ? AppColors.greenButtonColor
                : AppColors.disableBackground,
            onTapRightButton: () async {
              final userId = match.id?.trim();
              if (userId == null || userId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User id not found')),
                );
                return;
              }

              await BottomSheetUtils.open(
                context: context,
                fullHeight: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ViewContactBottomSheet(
                    userId: userId,
                    userName: match.displayName ?? 'Walima Member',
                    profileImagePath: imagePath,
                    description: match.connection?.message,
                    isDescriptionVisible: false,
                  ),
                ),
              );
            },
            isOnline: match.isOnline ?? false,
            viewOnAccept: false
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
    ].whereType<String>().where((value) => value.trim().isNotEmpty).toList();

    return parts.isEmpty ? 'N/A' : parts.join(', ');
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
