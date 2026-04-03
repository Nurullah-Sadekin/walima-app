import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_tab_shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxSentTab extends ConsumerStatefulWidget {
  const InboxSentTab({super.key});

  @override
  ConsumerState<InboxSentTab> createState() => _InboxSentTabState();
}

class _InboxSentTabState extends ConsumerState<InboxSentTab> {
  @override
  Widget build(BuildContext context) {
    return buildInboxPlaceholder(
      context: context,
      title: 'Sent',
      subtitle: 'All sent inbox items will appear here.',
    );
  }
}

