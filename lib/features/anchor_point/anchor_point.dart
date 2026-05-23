import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/chat/presentation/screens/chat_home.dart';
import 'package:walima_llc/features/home/presentation/screens/home_screen.dart';
import 'package:walima_llc/features/inbox/presentation/screens/inbox_screen.dart';
import 'package:walima_llc/features/matches/presentation/screens/matches.dart';
import 'package:walima_llc/features/plans/presentation/screens/plans_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Current tab provider
final currentTabProvider = StateProvider<int>((ref) => 0);

class AnchorPointScreen extends ConsumerWidget {
  const AnchorPointScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    final unreadChatCount = ref.watch(chatProvider).unreadCount;

    final screens = [
      const HomeScreen(),
      const MatchesScreen(),
      const InboxScreen(),
      const ChatScreen(),
      const UpgradePackageScreen(
        showAppBar: false,
      ),
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
            border:
                Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: AppImages.home,
                    label: 'Home',
                    isActive: currentTab == 0,
                    onTap: () =>
                        ref.read(currentTabProvider.notifier).state = 0,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: AppImages.matches,
                    label: 'Matches',
                    isActive: currentTab == 1,
                    onTap: () =>
                        ref.read(currentTabProvider.notifier).state = 1,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: AppImages.inbox,
                    label: 'Inbox',
                    isActive: currentTab == 2,
                    onTap: () =>
                        ref.read(currentTabProvider.notifier).state = 2,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: AppImages.chat,
                    label: 'Chat',
                    isActive: currentTab == 3,
                    badgeCount: unreadChatCount,
                    onTap: () =>
                        ref.read(currentTabProvider.notifier).state = 3,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: AppImages.premium,
                    label: 'Premium',
                    isActive: currentTab == 4,
                    onTap: () =>
                        ref.read(currentTabProvider.notifier).state = 4,
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
    required BuildContext context,
    required String icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ShowImage(
                imagePath: icon,
                width: 24,
                height: 24,
                color: isActive ? AppColors.primary : AppColors.textSub600,
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 12, minHeight: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label.localized(context),
            style: TextStyle(
              color: isActive ? AppColors.primary : AppColors.textSub600,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
