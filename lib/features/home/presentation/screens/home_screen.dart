import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
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
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const String _facebookUrl = 'https://www.facebook.com/WalimaApp';
  static const String _instagramUrl = 'https://www.instagram.com/walima.app';
  static const String _linkedInUrl =
      'https://www.linkedin.com/company/walima-app';
  static const String _privacyUrl = 'https://dev.walima.app/en/privacy';
  static const String _xUrl = 'https://x.com/WalimaApp';
  static const String _tikTokUrl = 'https://www.tiktok.com/@walima.app';
  static const String _helpCenterUrl =
      'https://dev.walima.app/en/account/help-desk';
  static const String _beSafeOnlineUrl =
      'https://dev.walima.app/en/be-safe-online';
  static const String _termsUrl = 'https://dev.walima.app/en/terms';

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
      isLoading: ref.watch(homeProvider).screenStates == HomeScreenStates.transparentLoading,
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
            imagePath: AppImages.homeProfileBg,/**/
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
    return Expanded(
      child: NotificationListener<UserScrollNotification>(
        onNotification: _onBodyUserScroll,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CompleteProfileSection(),
              _premiumMatches(),
              _recentVisitors(),
              _followUpSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _premiumMatches() {
    final provider = ref.watch(homeProvider);
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
              Container(
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
                  children: matches.map(_buildPremiumMatchCard).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumMatchCard(MatchProfile match) {
    final location = _formatMatchLocation(match);
    final heightText = _formatMatchHeight(match.height);
    final activeStatus = _activeStatusText(match);
    final profession = match.profession ?? match.education;
    final imagePath = (match.profilePhoto?.url?.isNotEmpty ?? false)
        ? match.profilePhoto!.url!
        : AppImages.demoProfile;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 300,
        child: ProfileComprehensiveCard(
          imagePath: imagePath,
          imageHeight: 250,
          isPremiumConnect: match.isPremium ?? true,
          isVerified: match.profilePhoto?.isVerified ?? false,
          name: match.displayName ?? 'Walima Member',
          age: match.age != null ? '${match.age} Yr' : null,
          height: heightText,
          location: location,
          profession: profession,
          leftButtonColor: match.connection?.status == 'none' ? AppColors.greenButtonColor : AppColors.disableBackground,
          leftButtonTextColor: match.connection?.status == 'none' ? AppColors.white : AppColors.disableText,
          leftButtonIconColor: match.connection?.status == 'none' ? AppColors.white : AppColors.disableText,
          leftButtonBorderColor: match.connection?.status == 'none' ? AppColors.greenButtonColor : AppColors.disableBackground,
          viewOnAccept: match.profilePhoto?.visibilityStatus != 'public',
          religion: match.religion,
          isOnline: match.isOnline ?? false,
          onTapLeftButton: () {
            ref.read(homeProvider).connect(context, match);
            // print('Left button tapped for ${match.displayName}');
          },
          activeStatusText: activeStatus,
        ),
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
              Container(
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
                  children: visitors.map(_buildRecentVisitorCard).toList(),
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
    final imagePath =
        (imageUrl?.isNotEmpty ?? false) ? imageUrl! : AppImages.demoProfile;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 300,
        child: ProfileComprehensiveCard(
          imagePath: imagePath,
          imageHeight: 250,
          isPremiumConnect: visitor.isPremium ?? false,
          isVerified: visitor.isVerified ?? false,
          name: visitor.displayName ?? 'Walima Member',
          age: visitor.age != null ? '${visitor.age?.toInt()} Yr' : null,
          height: _formatRecentVisitorHeight(visitor.height),
          location: location,
          leftButtonColor: visitor.connection?.status == 'none' ? AppColors.greenButtonColor : AppColors.disableBackground,
          leftButtonTextColor: visitor.connection?.status == 'none' ? AppColors.white : AppColors.disableText,
          leftButtonIconColor: visitor.connection?.status == 'none' ? AppColors.white : AppColors.disableText,
          leftButtonBorderColor: visitor.connection?.status == 'none' ? AppColors.greenButtonColor : AppColors.disableBackground,
          viewOnAccept: visitor.profilePhoto?.visibilityStatus != 'public',
          activeStatusText: _recentVisitorStatus(visitor),
        ),
      ),
    );
  }

  String? _formatRecentVisitorHeight(num? height) {
    if (height == null) return null;
    return '${height.toInt()} cm';
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
    final visitedAt =  DateTimeUtils.formatDate(DateTime.tryParse(visitor.visitedAt ?? ''));
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
                    onTap: () => _openLink('Instagram', _instagramUrl),
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.facebookIcon,
                    onTap: () => _openLink('Facebook', _facebookUrl),
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.twitterIcon,
                    onTap: () => _openLink('X', _xUrl),
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
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _followUpIcon(
                    label: 'LinkedIn',
                    imagePath: AppImages.workSvgIcon,
                    onTap: () => _openLink('LinkedIn', _linkedInUrl),
                  ),
                  _followUpIcon(
                    label: 'TikTok',
                    imagePath: AppImages.chatIcon,
                    onTap: () => _openLink('TikTok', _tikTokUrl),
                  ),
                  _followUpIcon(
                    label: 'Privacy',
                    imagePath: AppImages.lockPasswordSvgIcon,
                    onTap: () => _openLink('Privacy', _privacyUrl),
                  ),
                  _followUpIcon(
                    label: 'Help Center',
                    imagePath: AppImages.customerSupportSvgIcon,
                    onTap: () => _openLink('Help Center', _helpCenterUrl),
                  ),
                  _followUpIcon(
                    label: 'Be Safe Online',
                    imagePath: AppImages.safetySvgIcon,
                    onTap: () => _openLink('Be Safe Online', _beSafeOnlineUrl),
                  ),
                  _followUpIcon(
                    label: 'Terms',
                    imagePath: AppImages.documentValidationSvgIcon,
                    onTap: () => _openLink('Terms & Conditions', _termsUrl),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _followUpIcon({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SocialMediaIcon(
            imagePath: imagePath,
            onTap: onTap,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
