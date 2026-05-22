import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  const LinkOpener._();

  static Future<void> openLink( BuildContext context,String title, String url) {
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
        SnackBar(content: Text('Unable to open $title')),
      );
      return;
    }
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open $title')),
        );
      }
    } on PlatformException catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'External link support is not ready yet. Please fully restart the app and try again.',
          ),
        ),
      );
    } on MissingPluginException catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'External link support is not ready yet. Please fully restart the app and try again.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open $title')),
      );
    }
  }
}
