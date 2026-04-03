import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/features/inbox/presentation/widgets/inbox_tab_shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxMoreTab extends ConsumerStatefulWidget {
  const InboxMoreTab({super.key});

  @override
  ConsumerState<InboxMoreTab> createState() => _InboxMoreTabState();
}

class _InboxMoreTabState extends ConsumerState<InboxMoreTab> {
  @override
  Widget build(BuildContext context) {
    return buildInboxPlaceholder(
      context: context,
      title: 'More',
      subtitle: 'More inbox options will appear here.',
    );
  }
}

