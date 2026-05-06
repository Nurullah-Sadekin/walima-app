import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/empty_state.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/inbox/domain/models/menu_item_model.dart';
import 'package:walima_llc/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:walima_llc/features/inbox/presentation/widgets/inbox_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/features/inbox/presentation/widgets/inbox_tab_shared.dart';
import 'package:walima_llc/features/matches/presentation/widgets/text_tab_bar.dart';

class InboxContactsTab extends ConsumerStatefulWidget {
  const InboxContactsTab({super.key});

  @override
  ConsumerState<InboxContactsTab> createState() => _InboxContactsTabState();
}

class _InboxContactsTabState extends ConsumerState<InboxContactsTab>
    with SingleTickerProviderStateMixin {
  late final TabController _subTabController;
  final _tabs = const ['Contacts Viewed', 'Viewed You'];

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _subTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(inboxProvider);
    return Column(
      children: [
        TextTabBar(
          isScrollable: false,
          tabAlignment: TabAlignment.fill,
          controller: _subTabController,
          onTabChange: (_) {},
          tabs: _tabs,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            physics: const NeverScrollableScrollPhysics(),
            children:  [
              contactsViewed(provider),
              viewedYou(provider),
            ],
          ),
        ),
      ],
    );
  }


  Widget contactsViewed(InboxProvider provider) {
    return Column(
      spacing: 10,
      children: [
        InboxCard(
          menuItems: [
            MenuItem(
              name: 'Block',
              onTap: () => handleMenuAction(
                context: context,
                action: InboxMoreMenuAction.block,
              ),
            ),
            MenuItem(
              name: 'Report',
              onTap: () => handleMenuAction(
                context: context,
                action: InboxMoreMenuAction.report,
              ),
            ),
          ],
          imagePath: AppImages.demoProfile2,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          day: 'Today',
          subtitle: 'Profile Created by Self',
          email: '*******@gmail.com',
          contact: '01*********',
          sendSMS: 'Send SMS',
          isVerified: true,
          mood: InboxCardMood.large,
          isBottomSection: false,
        ),
        InboxCard(
          menuItems: [
            MenuItem(
              name: 'Block',
              onTap: () => handleMenuAction(
                context: context,
                action: InboxMoreMenuAction.block,
              ),
            ),
            MenuItem(
              name: 'Report',
              onTap: () => handleMenuAction(
                context: context,
                action: InboxMoreMenuAction.report,
              ),
            ),
          ],
          imagePath: AppImages.demoProfile2,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          day: 'Today',
          contactUnavailable: true,
          isVerified: true,
          mood: InboxCardMood.large,
          isBottomSection: false,
        ),
      ],
    );
  }

  Widget viewedYou(InboxProvider provider) {
    return Column(
      spacing: 10,
      children: [
        InboxCard(
          menuItems: [
            MenuItem(
              name: 'Block',
              onTap: () => handleMenuAction(
                context: context,
                action: InboxMoreMenuAction.block,
              ),
            ),
            MenuItem(
              name: 'Report',
              onTap: () => handleMenuAction(
                context: context,
                action: InboxMoreMenuAction.report,
              ),
            ),
          ],
          imagePath: AppImages.demoProfile2,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          day: 'Today',
          location: 'Gulshan, Dhaka, BD',
          isVerified: true,
          mood: InboxCardMood.small,
          isBottomSection: false,
        ),
        const EmptyStateWidget(
          imagePath: AppImages.viewOffSlash,
          title: 'No Views on Your Contact!',
          subtitle: 'Take the next step, check out more profiles to find your perfect match!',
          buttonText: 'View My Matches',
        ),

      ],
    );
  }
}
