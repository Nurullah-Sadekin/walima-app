import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/match_card.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  final  _tabs = ['Search', 'New', 'Daily', 'My Matches',];

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
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

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextTabBar(
            isScrollable: false,
            tabAlignment: TabAlignment.center,
            controller: _tabController,
            onTabChange:(index){
              provider?.updateTab(index: index);
            },
            tabs: _tabs),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _tabBarView(),
          ),
        )
      ],
    );
  }
  Widget _new(){
    return Expanded(
      child: DefaultTabController(
        length: _tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TabBar wrapped so it stays under the appbar
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: TabBar(
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondaryLight,
                    labelStyle: TextStyle(
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                    unselectedLabelStyle:  TextStyle(
                      fontSize: TextSize.font14(context),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondaryLight,
                    ),
                    tabs: _tabs.map((title) {
                      return Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: AppColors.greyLight),
                          ),
                          child: Text(
                            title,
                            // Text color will be overridden by TabBar's labelColor/unselectedLabelColor
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // TabBarView content
            Expanded(
              child: TabBarView(
                children: _tabs.map((_) {
                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        10,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MatchCard(
                            imagePath: AppImages.demoProfile2,
                            leftIconPath: AppImages.favouriteIcon,
                            isPremiumConnect: true,
                            isVerified: true,
                            name: 'Tasnova Ahmed',
                            age: '28 Yr',
                            height: "5' 3\"",
                            location: 'Gulshan, Dhaka, BD',
                            activeStatusText: '1 day ago',
                            photoCount: '5',
                            menu: true,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
