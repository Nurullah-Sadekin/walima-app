import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/home_screen.dart';
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
      Container(),
      Container(),
      Container(),
      Container(),
    ];

    // WillPopScope is deprecated in newer Flutter versions; PopScope is preferred.
    // Using WillPopScope here for compatibility; suppress analyzer deprecation warning.
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog and only pop if user confirms
        final shouldClose = await DialogUtils.showAppCloseDiaLog(context);
        if (shouldClose) {
          // Exit the app
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
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isActive: currentTab == 0,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 0,
                  ),
                  _buildNavItem(
                    icon: Icons.menu_book_rounded,
                    label: 'Courses',
                    isActive: currentTab == 1,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 1,
                  ),
                  _buildNavItem(
                    icon: Icons.fact_check_rounded,
                    label: 'Test',
                    isActive: currentTab == 2,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 2,
                  ),
                  _buildNavItem(
                    icon: Icons.emoji_events_rounded,
                    label: 'Rank',
                    isActive: currentTab == 3,
                    onTap: () => ref.read(currentTabProvider.notifier).state = 3,
                  ),
                  _buildNavItem(
                    icon: Icons.more_horiz_rounded,
                    label: 'More',
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
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              width: 32,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF1A8FE3),
                borderRadius: BorderRadius.circular(10),
              ),
            )
          else
            const SizedBox(height: 3),
          const SizedBox(height: 6),
          Icon(
            icon,
            color: isActive ? const Color(0xFF1A8FE3) : const Color(0xFF9CA3AF),
            size: 24,
          ),
          if (isActive && label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A8FE3),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
