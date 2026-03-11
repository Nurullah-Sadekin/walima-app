import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_boilerplate/features/matches/presentation/screens/matches.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Current tab provider
final currentTabProvider = StateProvider<int>((ref) => 0);

class AnchorPointScreen extends ConsumerWidget {
  const AnchorPointScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);

    final screens = [
      const HomeScreen(),
      const MatchesScreen(),
      Container(),
      Container(),
      Container(),
    ];
    return WillPopScope(
      onWillPop: () async {
        final shouldClose = await DialogUtils.showAppCloseDiaLog(context);
        if (shouldClose) {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        body: IndexedStack(index: currentTab, children: screens),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: AppImages.home,
                    isActive: currentTab == 0,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 0,
                  ),
                  _buildNavItem(
                    icon: AppImages.matches,
                    isActive: currentTab == 1,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 1,
                  ),
                  _buildNavItem(
                    icon: AppImages.inbox,
                    isActive: currentTab == 2,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 2,
                  ),
                  _buildNavItem(
                    icon: AppImages.chat,
                    isActive: currentTab == 3,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 3,
                  ),
                  _buildNavItem(
                    icon: AppImages.premium,
                    isActive: currentTab == 4,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: ShowImage(
        imagePath: icon,
        width: 45,
        height: 45,
        color: isActive ? AppColors.primary: AppColors.textSub600,
      ),
    );
  }
}
