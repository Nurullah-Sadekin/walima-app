import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/menu_item_model.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_tab_shared.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/text_tab_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxAcceptedTab extends ConsumerStatefulWidget {
  const InboxAcceptedTab({super.key});

  @override
  ConsumerState<InboxAcceptedTab> createState() => _InboxAcceptedTabState();
}

class _InboxAcceptedTabState extends ConsumerState<InboxAcceptedTab>
    with SingleTickerProviderStateMixin {
  late final TabController _subTabController;
  final _tabs = const ['Accepted by Her', 'Accepted by Me'];

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
            children: [
              _acceptedByHer(provider),
              _acceptedByHer(provider),
            ],
          ),
        ),
      ],
    );
  }


  Widget _acceptedByHer(InboxProvider provider) {
    return Column(
      children: [
        InboxCard(
          menuItems: _buildMenuItems(
            context: context,
            displayName: 'Tasnova Ahmed',
            imagePath: AppImages.demoProfile2,
          ),
          imagePath: AppImages.demoProfile2,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          day: 'Today',
          location: 'Gulshan, Dhaka, BD',
          profession: 'Software Engineer',
          isVerified: true,
        ),
      ],
    );
  }

  List<MenuItem> _buildMenuItems({
    required BuildContext context,
    required String displayName,
    required String imagePath,
  }) {
    return [
      MenuItem(
        name: 'View Profile',
        onTap: () => handleMenuAction(
          context: context,
          action: InboxMoreMenuAction.viewProfile,
          displayName: displayName,
          imagePath: imagePath,
        ),
      ),
      MenuItem(
        name: 'View Contact',
        onTap: () => handleMenuAction(
          context: context,
          action: InboxMoreMenuAction.viewContact,
          displayName: displayName,
          imagePath: imagePath,
        ),
      ),
      MenuItem(
        name: 'Block',
        onTap: () => handleMenuAction(
          context: context,
          action: InboxMoreMenuAction.block,
          displayName: displayName,
          imagePath: imagePath,
        ),
      ),
      MenuItem(
        name: 'Report',
        onTap: () => handleMenuAction(
          context: context,
          action: InboxMoreMenuAction.report,
          displayName: displayName,
          imagePath: imagePath,
        ),
      ),
    ];
  }
}


