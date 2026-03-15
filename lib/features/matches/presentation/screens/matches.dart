import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/accepted_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
   MatchesProvider provider = MatchesProvider();

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

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                TabBarWidget(
                  text: 'Search',
                  isSelected: true,
                  prefixImagePath: AppImages.searchSvgIcon,
                  onTap: () {
                    // Handle tap
                  },
                ),
                TabBarWidget(
                  text: 'New',
                  onTap: () {},
                ),
                TabBarWidget(
                  text: 'Daily',
                  count: 28,
                  onTap: () {},
                ),
                TabBarWidget(
                  text: 'My Matches',
                  isSelected: false,
                  selectedBackgroundColor: AppColors.primary,
                  selectedTextColor: AppColors.white,
                  selectedBorderColor: AppColors.primary,
                  onTap: () {},
                ),
              ],
            ),
          ),

        ]),
      ),
    );
  }
}
