import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_tab_shared.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/text_tab_bar.dart';

class InboxContactsTab extends ConsumerStatefulWidget {
  const InboxContactsTab({super.key});

  @override
  ConsumerState<InboxContactsTab> createState() => _InboxContactsTabState();
}

class _InboxContactsTabState extends ConsumerState<InboxContactsTab>
    with SingleTickerProviderStateMixin {
  late final TabController _subTabController;
  final _tabs = const ['Contacts Received', 'Contacts Sent'];

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
            children: const [
              _ContactsPlaceholder(title: 'Contacts Received'),
              _ContactsPlaceholder(title: 'Contacts Sent'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactsPlaceholder extends StatelessWidget {
  const _ContactsPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return buildInboxPlaceholder(
      context: context,
      title: title,
      subtitle: title == 'Contacts Received'
          ? 'Profiles that contacted you will appear here.'
          : 'Profiles you contacted will appear here.',
    );
  }
}
