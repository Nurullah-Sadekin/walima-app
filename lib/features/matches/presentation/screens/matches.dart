import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/count_down_timer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/empty_state.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/info_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/message_bubble.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/new_matches_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/remind_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/safety_first_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  late MatchesProvider provider;
  int _currentImageIndex = 0;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.greyLight, width: 1),
                ),
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'New',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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
            onTap: () {
            },
            imagePath: AppImages.demoProfile,
            name: 'Tasnova Ahmed',
            age: '28 Yr',
            height: '5\' 3\'" ',
            location: 'Gulshan, Dhaka, BD',
          ),
          const MessageBubble(
            message:
                'Hello, I have liked your profile and believe it to be a good Match. If you like my profile too, kindly accept this Invitation. Please feel free to contact me to take this conversation ahead. Warm Regards, Mehedi Hasan',
            senderName: 'Mehedi Hasan',
            showSenderName: true,
          ),
          const SafetyTipCard(),
          // Image carousel: horizontal scrollable images with dots indicator
          _imageCarousel(),
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

  Widget _imageCarousel() {
    // Replace or extend this list with the images you want to show
    final images = [
      AppImages.demoProfile,
      AppImages.demoProfile2,
      AppImages.demoProfile,
      AppImages.demoProfile2,
      AppImages.demoProfile,
      AppImages.demoProfile2,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = MediaQuery.of(context).size.height * 0.65; // responsive height based on width
        return CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final img = images[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  ShowImage(
                    imagePath: img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: height,
                  ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.disable,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.disableDark,
                            shape: BoxShape.rectangle,
                            borderRadius:
                            BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Row(
                            spacing: 4,
                            children: [
                              ShowImage(
                                imagePath: AppImages.photoIcon,
                                width: TextSize.font14(context),
                                height: TextSize.font14(context),
                                radius: BorderRadius.circular(8),
                                fit: BoxFit.fitWidth,
                                color: AppColors.white,
                              ),
                              Text(
                                '${index+1}/${images.length}',
                                style: TextStyle(
                                  fontSize: TextSize.font12(context),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) {
                        final isActive = _currentImageIndex == index;
                        final dotWidth = isActive ? 20.0 : 10.0;
                        const dotHeight = 10.0;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: dotWidth,
                          height: dotHeight,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(dotHeight / 2),
                            color: isActive ? AppColors.primary : AppColors.disable,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 1,
            height: height,
            onPageChanged: (index, reason) => setState(() => _currentImageIndex = index),
          ),
        );
      },
    );
  }
}
