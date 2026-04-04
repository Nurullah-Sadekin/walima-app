import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/screens/tabs/inbox_accepted_tab.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/screens/tabs/inbox_contacts_tab.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/screens/tabs/inbox_more_tab.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/screens/tabs/inbox_received_tab.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/screens/tabs/inbox_sent_tab.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _primaryTabController;
  final _primaryTabs = const ['Received', 'Accepted', 'Contacts', 'Sent', 'More'];

  @override
  void initState() {
    super.initState();
    _primaryTabController = TabController(initialIndex: 0, length: 5, vsync: this)
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
      title: 'Inbox',
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
            children: const [
              InboxReceivedTab(),
              InboxAcceptedTab(),
              InboxContactsTab(),
              InboxSentTab(),
              InboxMoreTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          TabBarWidget(
            text: _primaryTabs[0],
            isSelected: _primaryTabController.index == 0,
            onTap: () => _primaryTabController.animateTo(0),
          ),
          TabBarWidget(
            text: _primaryTabs[1],
            isSelected: _primaryTabController.index == 1,
            onTap: () => _primaryTabController.animateTo(1),
          ),
          TabBarWidget(
            text: _primaryTabs[2],
            isSelected: _primaryTabController.index == 2,
            onTap: () => _primaryTabController.animateTo(2),
          ),
          TabBarWidget(
            text: _primaryTabs[3],
            isSelected: _primaryTabController.index == 3,
            selectedBackgroundColor: AppColors.primary,
            selectedTextColor: AppColors.white,
            selectedBorderColor: AppColors.primary,
            onTap: () => _primaryTabController.animateTo(3),
          ),
          TabBarWidget(
            text: _primaryTabs[4],
            isSelected: _primaryTabController.index == 4,
            selectedBackgroundColor: AppColors.primary,
            selectedTextColor: AppColors.white,
            selectedBorderColor: AppColors.primary,
            onTap: () => _primaryTabController.animateTo(4),
          ),
        ],
      ),
    );
  }
}
