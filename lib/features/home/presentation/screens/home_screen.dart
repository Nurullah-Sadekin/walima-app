import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_image_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/app_drawer.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/edit_profile.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/complete_profile_section.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/profile_summery_section.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/widgets/social_media_icon.dart';
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

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(profileProvider).getProfile();
        ref.read(profileProvider).getDashboard();
      });
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
              // const SizedBox(height: 30),
              ProfileSummerySection(),
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
    );
  }

  Widget _premiumMatches() {
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
                    horizontal: 10.0, vertical: 10.0),
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
                    )
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
                            imagePath: AppImages.demoProfile2,
                            leftIconPath: AppImages.favouriteIcon,
                            imageHeight: 250,
                            isPremiumConnect: true,
                            isVerified: true,
                            name: 'Afia Sultana',
                            age: '28 Yr',
                            height: '5\' 3\'" ',
                            religion: 'Muslim',
                            profession: 'Software Engineer',
                            location: 'Gulshan, Dhaka, BD',
                            activeStatusText: 'Online',
                            isSingleButton: true,
                          ),
                        ),
                      )),
            ),
          ),
        )
      ],
    );
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
                    horizontal: 10.0, vertical: 10.0),
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
                    )
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
                      )),
            ),
          ),
        )
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
