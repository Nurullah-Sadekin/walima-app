import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/app_drawer.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/complete_profile_section.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/profile_summery_section.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/social_media_icon.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_matches_response.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Key profileImageKey = const ValueKey('home_profile_image');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showProfileSummary = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).getProfile(context);
      ref.read(profileProvider).getDashboard();
      ref.read(homeProvider).loadPremiumMatches();
    });
  }

  bool _onBodyUserScroll(UserScrollNotification notification) {
    if (notification.depth != 0 || notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification.direction == ScrollDirection.reverse && _showProfileSummary) {
      setState(() => _showProfileSummary = false);
    } else if (notification.direction == ScrollDirection.forward && !_showProfileSummary) {
      setState(() => _showProfileSummary = true);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          _headerSection(context),
          _bodySection(),
        ],
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: ShowImage(
            imagePath: AppImages.homeProfileBg,
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
    return AnchoredAppBar(context: context, title: 'My Walima');
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
              if(matches.length > 2)
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
          child: SizedBox(
            height: 360,
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
          religion: match.religion,
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
      return match.lastSeenAt!;
    }
    return 'Offline';
  }

  Widget _recentVisitors() {
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
                    '26 Profiles Found',
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                10,
                (index) => const Padding(
                  padding: EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: SizedBox(
                    width: 300,
                    child: ProfileComprehensiveCard(
                      imagePath: AppImages.demoProfile,
                      imageHeight: 250,
                      isPremiumConnect: true,
                      name: 'Tasnim Akter',
                      age: '28 Yr',
                      height: '5\' 3\'" ',
                      location: 'Gulshan, Dhaka, BD',
                      viewOnAccept: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
                    onTap: () {
                      // print('Facebook tapped');
                    },
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.facebookIcon,
                    onTap: () {
                      // print('Facebook tapped');
                    },
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.twitterIcon,
                    onTap: () {
                      // print('Facebook tapped');
                    },
                  ),
                  SocialMediaIcon(
                    imagePath: AppImages.youtubeIcon,
                    onTap: () {
                      // print('Facebook tapped');
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
