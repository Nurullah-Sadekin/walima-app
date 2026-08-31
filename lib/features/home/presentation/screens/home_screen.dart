import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/bottom_sheet.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/date_time_utils.dart';
import 'package:walima_llc/core/utils/height_utils.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/link_opener.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/anchor_point/achore_appbar.dart';
import 'package:walima_llc/features/drawer/presentation/app_drawer.dart';
import 'package:walima_llc/features/home/data/model/response/recent_visitors_response.dart';
import 'package:walima_llc/features/home/presentation/providers/home_provider.dart';
import 'package:walima_llc/features/home/presentation/screens/widgets/complete_profile_section.dart';
import 'package:walima_llc/features/home/presentation/screens/widgets/profile_summery_section.dart';
import 'package:walima_llc/features/home/presentation/screens/widgets/social_media_icon.dart';
import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';
import 'package:walima_llc/features/connections/presentation/widgets/view_contact_bottom_sheet.dart';
import 'package:walima_llc/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:walima_llc/features/profile/data/model/response/dashboard_response.dart';
import 'package:walima_llc/features/profile/presentation/providers/profile_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Key profileImageKey = const ValueKey('home_profile_image');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProviderSubscription<String>? _userSubscription;
  bool _showProfileSummary = true;

  Future<void> _openLink(String title, String url) {
    return LinkOpener.open(
      context,
      title: title,
      url: url,
    );
  }

  @override
  void initState() {
    super.initState();
    _userSubscription = ref.listenManual<String>(
      globalProvider.select((provider) => provider.currentUserId),
      (previous, next) {
        final home = ref.read(homeProvider);
        home.setAuthenticatedUser(next);
        if (next.isNotEmpty) {
          unawaited(home.ensureHomeDataLoaded());
        }
      },
      fireImmediately: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).getProfile(context);
      ref.read(profileProvider).getDashboard();
      ref.read(homeProvider).ensureHomeDataLoaded();
    });
  }

  @override
  void dispose() {
    _userSubscription?.close();
    super.dispose();
  }

  bool _onBodyUserScroll(UserScrollNotification notification) {
    if (notification.depth != 0 || notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification.direction == ScrollDirection.reverse &&
        _showProfileSummary) {
      setState(() => _showProfileSummary = false);
    } else if (notification.direction == ScrollDirection.forward &&
        !_showProfileSummary) {
      setState(() => _showProfileSummary = true);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isHomeLoading = ref.watch(homeProvider).screenStates ==
        HomeScreenStates.transparentLoading;
    final isProfileImageUploading =
        ref.watch(profileProvider).loaderState == ProfileScreenStates.loading;

    return TransparentLoading(
      isLoading: isHomeLoading || isProfileImageUploading,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        body: Column(
          children: [
            _headerSection(context),
            _bodySection(),
          ],
        ),
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: ShowImage(
            imagePath: AppImages.homeProfileBg,
            /**/
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _topBar(context),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: _showProfileSummary
                    ? const ProfileSummerySection(
                        key: ValueKey('profile-summary-visible'),
                      )
                    : const SizedBox(
                        key: ValueKey('profile-summary-hidden'),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String resolvePlanName(Membership? membership) {
    final planName = membership?.plan?.name?.trim();
    if (planName != null && planName.isNotEmpty) {
      return planName.toLowerCase();
    }

    final tier = membership?.membershipTier?.trim();
    if (tier != null && tier.isNotEmpty) {
      return tier.toLowerCase();
    }

    return 'free';
  }

  Widget _topBar(BuildContext context) {
    return AnchoredAppBar(
      context: context,
      title: 'My Walima'.localized(context),
      onNotificationPressed: () => context.pushNamed(Routes.notifications),
    );
  }

  Widget _bodySection() {
    ref.watch(homeProvider);
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refreshHome,
        color: AppColors.primary,
        child: NotificationListener<UserScrollNotification>(
          onNotification: _onBodyUserScroll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const CompleteProfileSection(),
                _premiumMatches(),
                _recentlyViewed(),
                _recentVisitors(),
                _followUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshHome() async {
    await Future.wait<void>([
      ref.read(homeProvider).loadProfileStrength(force: true),
      ref.read(homeProvider).loadPremiumMatches(force: true),
      ref.read(homeProvider).loadRecentVisitors(force: true),
      ref.read(homeProvider).loadRecentlyViewed(force: true),
      ref.read(profileProvider).getProfile(context),
      ref.read(profileProvider).getDashboard(),
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(homeProvider).ensureHomeDataLoaded();
    });
  }

  Widget _premiumMatches() {
    final provider = ref.watch(homeProvider);
    final currentPlan = resolvePlanName(
      ref.watch(profileProvider).dashboard?.profile?.membership,
    );
    final matches = provider.premiumMatches;
    final isLoading = provider.isLoadingPremiumMatches;
    final errorText = provider.premiumMatchesError;
    final subtitleText = isLoading
        ? 'Fetching premium matches'.localized(context)
        : '${provider.premiumMatchesTotal} ${'Profiles Found'.localized(context)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    'Premium Matches'.localized(context),
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font18(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitleText,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (currentPlan != 'free')
                InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => context.pushNamed(Routes.premiumMatches),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppColors.greyLight),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'View All'.localized(context),
                          style: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: TextSize.font14(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.textSecondaryLight,
                          size: TextSize.font12(context),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Builder(
            builder: (_) {
              if (isLoading) {
                return _matchSectionSkeleton();
              }

              if (errorText != null && matches.isEmpty) {
                return _sectionError(
                  errorText,
                  () => ref.read(homeProvider).loadPremiumMatches(force: true),
                );
              }

              if (matches.isEmpty) {
                return Center(
                  child: Text(
                    'No premium matches available yet.'.localized(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font16(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...matches.take(2).map(_buildPremiumMatchCard),
                    if (currentPlan == 'free')
                      _buildUpgradeWidget(matches.length - 2),
                    if (currentPlan != 'free')
                      ...matches.skip(2).map(_buildPremiumMatchCard),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpgradeWidget(int remainingCount, {bool? isForVisitors}) {
    String subText = isForVisitors == true
        ? 'recent visitors'.localized(context)
        : 'premium matches'.localized(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ShowImage(
            imagePath: AppImages.premiumSvgIcon,
            width: 80,
            height: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Upgrade Your Plan'.localized(context),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${'See'.localized(context)} $remainingCount ${'more'.localized(context)} $subText',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => context.pushNamed(
              Routes.upgradePackage,
              extra: Routes.anchor,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Upgrade Now'.localized(context),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumMatchCard(MatchProfile match) {
    final location = _formatMatchLocation(match);
    final heightText = _formatMatchHeight(match.height);
    final activeStatus = _activeStatusText(match);
    final profession = match.profession ?? match.education;
    final imagePath = match.profilePhoto?.url;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 300,
        child: ProfileComprehensiveCard(
          onTapCard: () {
            context.pushNamed(
              Routes.profilePreview,
              extra: {'userId': match.userReference ?? match.id},
            );
          },
          imagePath: imagePath ??
              (match.gender == 'female'
                  ? AppImages.womenAvatar
                  : AppImages.manAvatar),
          imageHeight: 250,
          isPremiumConnect: match.isPremium == true,
          isVerified: match.profilePhoto?.isVerified ?? false,
          name: match.displayName ?? 'Walima Member'.localized(context),
          age:
              '${match.age ?? 'Undefine'.localized(context)} ${'Yr'.localized(context)}',
          height: HeightUtils.formatHeight(heightText),
          location: location?.localized(context),
          profession: profession?.localized(context),
          leftButtonColor: match.canConnect
              ? AppColors.greenButtonColor
              : AppColors.disableBackground,
          leftButtonTextColor:
              match.canConnect ? AppColors.white : AppColors.disableText,
          leftButtonIconColor:
              match.canConnect ? AppColors.white : AppColors.disableText,
          leftButtonBorderColor: match.canConnect
              ? AppColors.greenButtonColor
              : AppColors.disableBackground,
          viewOnAccept:
              match.profilePhoto?.visibilityStatus == 'visible' ? true : false,
          religion: match.religion?.localized(context),
          isOnline: match.isOnline ?? false,
          showLeftButton: match.canConnect,
          onTapRightButton: () async {
            await BottomSheetUtils.open(
              context: context,
              fullHeight: false,
              child: Consumer(
                builder: (context, ref, _) {
                  return _contactPremiumBottomSheet(match);
                },
              ),
            );
          },
          onTapLeftButton: match.canConnect
              ? () {
                  ref.read(homeProvider).connect(
                        context,
                        match.id ?? '',
                        match.displayName ?? 'Unknown'.localized(context),
                        ConnectionRequestType.match.apiValue,
                      );
                }
              : null,
          activeStatusText: activeStatus,
        ),
      ),
    );
  }

  Widget _contactPremiumBottomSheet(MatchProfile match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ViewContactBottomSheet(
        userId: match.id ?? '',
        userName: match.displayName ?? 'Unknown'.localized(context),
        profileImagePath: (match.profilePhoto?.url?.isNotEmpty ?? false)
            ? match.profilePhoto!.url!
            : match.gender == 'female'
                ? AppImages.womenAvatar
                : AppImages.manAvatar,
        description: match.connection?.message,
        isDescriptionVisible: false,
        onWalimaChatPressed: match.id == null
            ? null
            : () {
                context.pushNamed(
                  Routes.chatScreen,
                  extra: {
                    'conversationId': match.connection?.conversationId,
                    'participant': {
                      'userId': match.id,
                      'displayName': match.displayName,
                      'profilePictureUrl': match.profilePhoto?.url,
                      'isOnline': match.isOnline,
                    },
                  },
                );
              },
      ),
    );
  }

  String? _formatMatchHeight(num? height) {
    if (height == null) return null;
    final doubleValue = height.toDouble();
    if (doubleValue % 1 == 0) {
      return doubleValue.toInt().toString();
    }
    return doubleValue.toStringAsFixed(1);
  }

  String? _formatMatchLocation(MatchProfile match) {
    final location = match.location;
    final parts = [
      location?.city,
      location?.state,
      location?.country,
    ]
        .where((value) => value != null && value.trim().isNotEmpty)
        .map((value) => value!.trim())
        .toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  String _activeStatusText(MatchProfile match) {
    if (match.isOnline == true) {
      return 'Online'.localized(context);
    }
    if (match.lastSeenAt != null && match.lastSeenAt!.isNotEmpty) {
      return DateTimeUtils.formatDate(DateTime.tryParse(match.lastSeenAt!));
    }
    return 'Offline'.localized(context);
  }

  Widget _recentVisitors() {
    final provider = ref.watch(homeProvider);
    final visitors = provider.recentVisitors;
    final isLoading = provider.isLoadingRecentVisitors;
    final errorText = provider.recentVisitorsError;
    final subtitleText = isLoading
        ? 'Loading recent visitors'.localized(context)
        : '${provider.recentVisitorsTotal} ${'Profiles Found'.localized(context)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    'Recent Visitors'.localized(context),
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font18(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitleText,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (!isLoading)
                InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => context.pushNamed(Routes.recentVisitors),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppColors.greyLight),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'View All'.localized(context),
                          style: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: TextSize.font14(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.textSecondaryLight,
                          size: TextSize.font12(context),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Builder(
            builder: (_) {
              if (isLoading) {
                return _matchSectionSkeleton();
              }

              if (errorText != null && visitors.isEmpty) {
                return _sectionError(
                  errorText,
                  () => ref.read(homeProvider).loadRecentVisitors(force: true),
                );
              }

              if (visitors.isEmpty) {
                return Center(
                  child: Text(
                    'No recent visitors yet.'.localized(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font16(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var index = 0; index < visitors.length; index++)
                      _buildRecentVisitorCard(
                        visitors[index],
                        isLocked: provider.isRecentVisitorLockedAt(index),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentVisitorCard(
    Data visitor, {
    bool isLocked = false,
    bool recentlyViewed = false,
  }) {
    final location = _formatRecentVisitorLocation(visitor.location);
    final imageUrl = visitor.profilePhoto?.url?.toString();
    final imagePath = (imageUrl?.isNotEmpty ?? false)
        ? imageUrl!
        : (visitor.gender == 'female'
            ? AppImages.womenAvatar
            : AppImages.manAvatar);

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        key: ValueKey(visitor.id ?? visitor.userReference),
        width: 300,
        child: ProfileComprehensiveCard(
          onTapCard: () {
            if (isLocked) {
              context.pushNamed(Routes.upgradePackage, extra: Routes.anchor);
            } else {
              context.pushNamed(
                Routes.profilePreview,
                extra: {'userId': visitor.userReference ?? visitor.id},
              );
            }
          },
          imagePath: imagePath,
          imageHeight: 250,
          isPremiumConnect: visitor.isPremium ?? false,
          isVerified: visitor.isVerified ?? false,
          name: visitor.displayName ?? 'Walima Member'.localized(context),
          age:
              '${visitor.age?.toInt() ?? 'Undefine'.localized(context)} ${'Yr'.localized(context)}',
          height: visitor.height == null
              ? null
              : HeightUtils.formatHeight(visitor.height.toString()),
          location: location,
          leftButtonColor: visitor.canConnect
              ? AppColors.greenButtonColor
              : AppColors.disableBackground,
          leftButtonTextColor:
              visitor.canConnect ? AppColors.white : AppColors.disableText,
          leftButtonIconColor:
              visitor.canConnect ? AppColors.white : AppColors.disableText,
          leftButtonBorderColor: visitor.canConnect
              ? AppColors.greenButtonColor
              : AppColors.disableBackground,
          viewOnAccept: visitor.profilePhoto?.visibilityStatus == 'visible',
          activeStatusText: recentlyViewed
              ? _recentlyViewedStatus(visitor)
              : _recentVisitorStatus(visitor),
          isLocked: isLocked,
          showLeftButton: visitor.canConnect,
          onTapRightButton: isLocked
              ? null
              : () async {
                  await BottomSheetUtils.open(
                    context: context,
                    fullHeight: false,
                    child: Consumer(
                      builder: (context, ref, _) {
                        return _contactVisitorBottomSheet(visitor);
                      },
                    ),
                  );
                },
          onTapLeftButton: !isLocked && visitor.canConnect
              ? () {
                  ref.read(homeProvider).connect(
                        context,
                        visitor.id ?? '',
                        visitor.displayName ?? 'Unknown'.localized(context),
                        ConnectionRequestType.match.apiValue,
                      );
                }
              : null,
        ),
      ),
    );
  }

  Widget _contactVisitorBottomSheet(Data visitor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ViewContactBottomSheet(
        userId: visitor.id ?? '',
        userName: visitor.displayName ?? 'Unknown'.localized(context),
        profileImagePath: (visitor.profilePhoto?.url?.isNotEmpty ?? false)
            ? visitor.profilePhoto!.url!
            : visitor.gender == 'female'
                ? AppImages.womenAvatar
                : AppImages.manAvatar,
        description: visitor.connection?.message,
        isDescriptionVisible: false,
        onWalimaChatPressed: visitor.id == null
            ? null
            : () {
                context.pushNamed(
                  Routes.chatScreen,
                  extra: {
                    'conversationId': visitor.connection?.conversationId,
                    'participant': {
                      'userId': visitor.id,
                      'displayName': visitor.displayName,
                      'profilePictureUrl': visitor.profilePhoto?.url,
                      'isOnline': visitor.isOnline,
                    },
                  },
                );
              },
      ),
    );
  }

  String? _formatRecentVisitorLocation(Location? location) {
    final parts = [
      location?.city,
      location?.state?.toString(),
      location?.country,
    ]
        .where((value) => value != null && value.trim().isNotEmpty)
        .map((value) => value!.trim())
        .toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  String _recentVisitorStatus(Data visitor) {
    final visitedAt =
        DateTimeUtils.formatDate(DateTime.tryParse(visitor.visitedAt ?? ''));
    return visitedAt;
  }

  String _recentlyViewedStatus(Data visitor) {
    return DateTimeUtils.formatDate(
      DateTime.tryParse(visitor.viewedAt ?? ''),
    );
  }

  Widget _recentlyViewed() {
    final provider = ref.watch(homeProvider);
    final profiles = provider.recentlyViewed;
    final isLoading = provider.isLoadingRecentlyViewed;
    final errorText = provider.recentlyViewedError;
    final subtitle = isLoading
        ? 'Loading recently viewed profiles'.localized(context)
        : '${provider.recentlyViewedTotal} ${'Profiles Found'.localized(context)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recently Viewed'.localized(context),
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: TextSize.font18(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: TextSize.font14(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Builder(
              builder: (_) {
                if (isLoading) {
                  return _matchSectionSkeleton();
                }
                if (errorText != null && profiles.isEmpty) {
                  return _sectionError(
                    errorText,
                    () =>
                        ref.read(homeProvider).loadRecentlyViewed(force: true),
                  );
                }
                if (profiles.isEmpty) {
                  return Center(
                    child: Text(
                      'No recently viewed profiles yet.'.localized(context),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: profiles
                        .map(
                          (profile) => _buildRecentVisitorCard(
                            profile,
                            recentlyViewed: true,
                          ),
                        )
                        .toList(growable: false),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _matchSectionSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.disableBackground,
      highlightColor: AppColors.white,
      child: Row(
        children: List.generate(
          2,
          (index) => Container(
            width: 300,
            height: 380,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionError(String message, VoidCallback retry) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font16(context),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: retry, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _followUpSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Follow Us on'.localized(context),
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font18(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                'Stay inspired follow us on social media'.localized(context),
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                spacing: 12,
                children: [
                  SocialMediaIcon(
                    imagePath: AppImages.instagramIcon,
                    onTap: () => _openLink(
                      'Instagram'.localized(context),
                      AppUrls.instagramUrl,
                    ),
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.facebookIcon,
                    onTap: () => _openLink(
                      'Facebook'.localized(context),
                      AppUrls.facebookUrl,
                    ),
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.twitterIcon,
                    onTap: () => _openLink(
                      'X'.localized(context),
                      AppUrls.xUrl,
                    ),
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.whatsappSvgIcon,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Whatsapp link is not configured yet'
                                .localized(context),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
