import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_boilerplate/core/utils/height_utils.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/core/utils/link_opener.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/app_drawer.dart';
import 'package:flutter_boilerplate/features/home/data/model/response/recent_visitors_response.dart';
import 'package:flutter_boilerplate/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/complete_profile_section.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/profile_summery_section.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/social_media_icon.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_matches_response.dart';
import 'package:flutter_boilerplate/features/connections/presentation/widgets/view_contact_bottom_sheet.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  final Key profileImageKey = const ValueKey('home_profile_image');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).getProfile(context);
      ref.read(profileProvider).getDashboard();
      ref.read(homeProvider).ensureHomeDataLoaded();
    });
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
    return TransparentLoading(
      isLoading: ref.watch(homeProvider).screenStates ==
          HomeScreenStates.transparentLoading,
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

  Widget _topBar(BuildContext context) {
    return AnchoredAppBar(
      context: context,
      title: 'My Walima',
      onNotificationPressed: () => context.pushNamed(Routes.notifications),
    );
  }

  Widget _bodySection() {
    final provider = ref.read(homeProvider);
    return Expanded(
      child: NotificationListener<UserScrollNotification>(
        onNotification: _onBodyUserScroll,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CompleteProfileSection(),
              _premiumMatches(),
              if (provider.recentVisitors.isNotEmpty) _recentVisitors(),
              _followUpSection(),
            ],
          ),
        ),
      ),
    );
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
    final currentPlan = ref.watch(profileProvider).dashboard?.profile?.membership?.plan?.name;
    final matches = provider.premiumMatches;
    final isLoading = provider.isLoadingPremiumMatches;
    final errorText = provider.premiumMatchesError;
    final subtitleText = isLoading
        ? 'Fetching premium matches'
        : '${matches.length} Profiles Found';

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
                    'Premium Matches',
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
              if (currentPlan != 'Free')
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
                        'View All',
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (errorText != null && matches.isEmpty) {
                return Center(
                  child: Text(
                    errorText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font16(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }

              if (matches.isEmpty) {
                return Center(
                  child: Text(
                    'No premium matches available yet.',
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

                    if (currentPlan == 'Free')
                      _buildUpgradeWidget(matches.length - 2),

                    if (currentPlan != 'Free')
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
    String subText = isForVisitors == true ? 'recent visitors' : 'premium matches';
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
          const Text(
            'Upgrade Your Plan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'See $remainingCount more $subText',
            style: TextStyle(fontSize: TextSize.font14(context), color: AppColors.textSecondaryLight),
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
              child: const Text(
                'Upgrade Now',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
            context.pushNamed(Routes.profilePreview, extra: {'userId': match.id});
          },
          imagePath: imagePath ??
              (match.gender == 'female'
                  ? AppImages.womenAvatar
                  : AppImages.manAvatar),
          imageHeight: 250,
          isPremiumConnect: match.isPremium ?? true,
          isVerified: match.profilePhoto?.isVerified ?? false,
          name: match.displayName ?? 'Walima Member',
          age: '${match.age ?? 'Undefine'} Yr',
          height: HeightUtils.formatHeight(heightText),
          location: location,
          profession: profession,
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
          viewOnAccept:
              match.profilePhoto?.visibilityStatus == 'visible' ? true : false,
          religion: match.religion,
          isOnline: match.isOnline ?? false,
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
          onTapLeftButton: () {
            if (match.connection?.status == 'none') {
              ref.read(homeProvider).connect(
                    context,
                    match.id ?? '',
                    match.displayName ?? 'Unknown',
                    ConnectionRequestType.match.apiValue,
                  );
            }
            // print('Left button tapped for ${match.displayName}');
          },
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
        userName: match.displayName ?? 'Unknown',
        profileImagePath: (match.profilePhoto?.url?.isNotEmpty ?? false)
            ? match.profilePhoto!.url!
            : match.gender == 'female'
                ? AppImages.womenAvatar
                : AppImages.manAvatar,
        description: match.connection?.message,
        isDescriptionVisible: false,
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
      return 'Online';
    }
    if (match.lastSeenAt != null && match.lastSeenAt!.isNotEmpty) {
      return DateTimeUtils.formatDate(DateTime.tryParse(match.lastSeenAt!));
    }
    return 'Offline';
  }

  Widget _recentVisitors() {
    final provider = ref.watch(homeProvider);
    final visitors = provider.recentVisitors;
    final currentPlan = ref.watch(profileProvider).dashboard?.profile?.membership?.plan?.name;
    final isLoading = provider.isLoadingRecentVisitors;
    final errorText = provider.recentVisitorsError;
    final subtitleText = isLoading
        ? 'Loading recent visitors'
        : '${visitors.length} Profiles Found';

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
                    'Recent Visitors',
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
              if (currentPlan != 'Free')
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
                        'View All',
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (errorText != null && visitors.isEmpty) {
                return Center(
                  child: Text(
                    errorText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font16(context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }

              if (visitors.isEmpty) {
                return Center(
                  child: Text(
                    'No recent visitors yet.',
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
                    ...visitors.take(2).map(_buildRecentVisitorCard),

                    if (currentPlan == 'Free')
                      _buildUpgradeWidget(visitors.length - 2, isForVisitors: true),

                    if (currentPlan != 'Free')
                      ...visitors.skip(2).map(_buildRecentVisitorCard),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentVisitorCard(Data visitor) {
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
        width: 300,
        child: ProfileComprehensiveCard(
          onTapCard: () {
            context.pushNamed(Routes.profilePreview, extra: {'userId': visitor.id});
          },
          imagePath: imagePath,
          imageHeight: 250,
          isPremiumConnect: visitor.isPremium ?? false,
          isVerified: visitor.isVerified ?? false,
          name: visitor.displayName ?? 'Walima Member',
          age: '${visitor.age?.toInt() ?? 'Undefine'} Yr',
          height: HeightUtils.formatHeight(visitor.height.toString()),
          location: location,
          leftButtonColor: visitor.connection?.status == 'none'
              ? AppColors.greenButtonColor
              : AppColors.disableBackground,
          leftButtonTextColor: visitor.connection?.status == 'none'
              ? AppColors.white
              : AppColors.disableText,
          leftButtonIconColor: visitor.connection?.status == 'none'
              ? AppColors.white
              : AppColors.disableText,
          leftButtonBorderColor: visitor.connection?.status == 'none'
              ? AppColors.greenButtonColor
              : AppColors.disableBackground,
          viewOnAccept: visitor.profilePhoto?.visibilityStatus == 'visible',
          activeStatusText: _recentVisitorStatus(visitor),
          onTapRightButton: () async {
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
          onTapLeftButton: () {
            if (visitor.connection?.status == 'none') {
              ref.read(homeProvider).connect(
                    context,
                    visitor.id ?? '',
                    visitor.displayName ?? 'Unknown',
                    ConnectionRequestType.match.apiValue,
                  );
            }
          },
        ),
      ),
    );
  }

  Widget _contactVisitorBottomSheet(Data visitor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ViewContactBottomSheet(
        userId: visitor.id ?? '',
        userName: visitor.displayName ?? 'Unknown',
        profileImagePath: (visitor.profilePhoto?.url?.isNotEmpty ?? false)
            ? visitor.profilePhoto!.url!
            : visitor.gender == 'female'
                ? AppImages.womenAvatar
                : AppImages.manAvatar,
        description: visitor.connection?.message,
        isDescriptionVisible: false,
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
                'Follow Us on',
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
                'Stay inspired follow us on social media',
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
                    onTap: () => _openLink('Instagram', AppUrls.instagramUrl),
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.facebookIcon,
                    onTap: () => _openLink('Facebook', AppUrls.facebookUrl),
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.twitterIcon,
                    onTap: () => _openLink('X', AppUrls.xUrl),
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.whatsappSvgIcon,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Whatsapp link is not configured yet'),
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
