import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
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
      context: context,
    );
  }

  Widget _body(){
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
              10,
                  (index) => const Padding(
                padding: EdgeInsets.only(
                  right: 10.0,
                ),
                child: MatchCard(
                  imagePath: AppImages.demoProfile2,
                  leftIconPath: AppImages.premiumSvgIcon,
                  isPremiumConnect: true,
                  isVerified: true,
                  name: 'Profile Name',
                  age: '28 Years',
                  height: '5 Feet 3 Inches',
                  location: 'Gulshan, Dhaka, BD',
                  activeStatusText: '1 day ago',
                ),
              )),
        ),
      ),
    );
  }


}
