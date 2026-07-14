import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/anchor_point/achore_appbar.dart';
import 'package:walima_llc/features/inbox/presentation/screens/tabs/inbox_accepted_tab.dart';
import 'package:walima_llc/features/inbox/presentation/screens/tabs/inbox_contacts_tab.dart';
import 'package:walima_llc/features/inbox/presentation/screens/tabs/inbox_more_tab.dart';
import 'package:walima_llc/features/inbox/presentation/screens/tabs/inbox_received_tab.dart';
import 'package:walima_llc/features/inbox/presentation/screens/tabs/inbox_sent_tab.dart';
import 'package:walima_llc/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _primaryTabController;
  final _primaryTabs = const [
    'Received',
    'Accepted',
    // 'Contacts',
    'Sent',
    'More',
  ];

  @override
  void initState() {
    super.initState();
    _primaryTabController =
        TabController(initialIndex: 0, length: 4, vsync: this)
          ..addListener(_handlePrimaryTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(inboxProvider).loadPrimaryTab(_primaryTabController.index);
    });
  }

  void _handlePrimaryTabChange() {
    if (!mounted || _primaryTabController.indexIsChanging) return;
    ref.read(inboxProvider).loadPrimaryTab(_primaryTabController.index);
    setState(() {});
  }

  @override
  void dispose() {
    _primaryTabController.removeListener(_handlePrimaryTabChange);
    _primaryTabController.dispose();
    super.dispose();
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
              Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbarSection() {
    return AnchoredAppBar(
      title: 'Inbox'.localized(context),
      notificationCount: 26,
      context: context,
      onNotificationPressed: () => context.pushNamed(Routes.notifications),
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPrimaryTabs(),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _primaryTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              InboxReceivedTab(
                onExploreAcceptedTap: () => _primaryTabController.animateTo(1),
              ),
              const InboxAcceptedTab(),
              // const InboxContactsTab(),
              const InboxSentTab(),
              const InboxMoreTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8,
      children: [
        TabBarWidget(
          text: _primaryTabs[0].localized(context),
          isSelected: _primaryTabController.index == 0,
          onTap: () => _primaryTabController.animateTo(0),
        ),
        TabBarWidget(
          text: _primaryTabs[1].localized(context),
          isSelected: _primaryTabController.index == 1,
          onTap: () => _primaryTabController.animateTo(1),
        ),
        // TabBarWidget(
        //   text: _primaryTabs[2],
        //   isSelected: _primaryTabController.index == 2,
        //   onTap: () => _primaryTabController.animateTo(2),
        // ),
        TabBarWidget(
          text: _primaryTabs[2].localized(context),
          isSelected: _primaryTabController.index == 2,
          selectedBackgroundColor: AppColors.primary,
          selectedTextColor: AppColors.white,
          selectedBorderColor: AppColors.primary,
          onTap: () => _primaryTabController.animateTo(2),
        ),
        TabBarWidget(
          text: _primaryTabs[3].localized(context),
          isSelected: _primaryTabController.index == 3,
          selectedBackgroundColor: AppColors.primary,
          selectedTextColor: AppColors.white,
          selectedBorderColor: AppColors.primary,
          onTap: () => _primaryTabController.animateTo(3),
        ),
      ],
    );
  }
}
