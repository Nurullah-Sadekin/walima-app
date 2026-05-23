import 'package:flutter/material.dart';

import 'package:walima_llc/core/utils/in_app_webview_screen.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class LinkOpener {
  const LinkOpener._();

  static Future<void> openLink(
    BuildContext context,
    String title,
    String url,
  ) {
    return LinkOpener.open(
      context,
      title: title,
      url: url,
    );
  }

  static Future<void> open(
    BuildContext context, {
    required String title,
    required String url,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${'Unable to open'.localized(context)} $title')),
      );
      return;
    }

    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InAppWebViewScreen(title: title, initialUrl: uri),
      ),
    );
  }
}
