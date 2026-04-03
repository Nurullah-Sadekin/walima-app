import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxMoreTab extends ConsumerStatefulWidget {
  const InboxMoreTab({super.key});

  @override
  ConsumerState<InboxMoreTab> createState() => _InboxMoreTabState();
}

class _InboxMoreTabState extends ConsumerState<InboxMoreTab> {
  @override
  Widget build(BuildContext context) {
    return const Text(' More',
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
    );
  }
}
