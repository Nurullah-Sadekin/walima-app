import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class ClipboardUtils {
  /// Copies [value] to the system clipboard and shows a confirmation snackbar.
  /// [label] describes what was copied (e.g. "ID", "Email").
  static Future<void> copyWithSnack(
    BuildContext context,
    String? value, {
    String label = 'ID',
  }) async {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: trimmed));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
          content: Text(
            '$label copied successfully',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }
}
