import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/match_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            value: true,
            onChanged: (newValue) {},
          ),
          const MatchCard(
            imagePath: AppImages.demoProfile2,
            leftIconPath: AppImages.favouriteIcon,
            isPremiumConnect: true,
            isVerified: true,
            name: 'Tasnova Ahmed',
            age: '28 Yr',
            height: '5\' 3\'" ',
            location: 'Gulshan, Dhaka, BD',
            activeStatusText: '1 day ago',
            photoCount: '5',
            menu: true,
          ),
        ]),
      ),
    );
  }
}
