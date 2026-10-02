import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

/// Toggles [memberId] (member UUID) in the shortlist behind a full-screen
/// transparent loader, then shows the API error if any (e.g. "Connected
/// members cannot be shortlisted" on 409).
Future<void> toggleShortlistWithFeedback(
  BuildContext context,
  WidgetRef ref,
  String? memberId,
) async {
  final provider = ref.read(shortlistProvider);
  if (provider.isPending(memberId)) return;

  // Same look as TransparentLoading, but on the root navigator so it covers
  // the whole app (app bar, bottom tabs) from any screen.
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => const PopScope(
      canPop: false,
      child: Center(child: CircularProgressIndicator()),
    ),
  );

  String? error;
  try {
    error = await provider.toggle(memberId);
  } finally {
    if (navigator.mounted) navigator.pop();
  }

  if (error == null || !context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error.localized(context))),
  );
}
