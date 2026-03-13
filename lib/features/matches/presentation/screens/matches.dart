import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/count_down_timer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/empty_state.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/info_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/message_bubble.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/remind_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/safety_first_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  late MatchesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(matchesProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
        ]),
      ),
    );
  }
}
