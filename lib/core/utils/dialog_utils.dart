import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class DialogUtils {
  static Future<void> showSuccessDialog({
    required BuildContext context,
    String title = 'Success',
    String? message,
    String buttonText = 'View order',
    bool autoClose = true,
    String? imagePath,
    Duration autoCloseDuration = const Duration(seconds: 2),
    VoidCallback? onClose,
    VoidCallback? onButtonPressed,
    String? disableButtonText,
    bool isDisableButton = false,
    VoidCallback? onDisableButtonPressed,
  }) async {
    bool dismissed = false;
    void safeClose() {
      if (dismissed) return;
      dismissed = true;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (onClose != null) onClose();
    }

    await showDialog(
      context: context,
      barrierDismissible: !autoClose,
      builder: (context) => statusDialogs(
        context: context,
        isSuccess: true,
        imagePath: imagePath,
        title: title,
        message: message ?? 'Purchase done! Instant alerts for matches\nand profile views are now enabled.',
        buttonText: buttonText, // Always show button now
        onButtonPressed: onButtonPressed ?? safeClose,
        onClose: safeClose,
        showIcon: true,
       disableButtonText: disableButtonText,
        isDisableButton: isDisableButton,
        onDisableButtonPressed: onDisableButtonPressed,
      ),
    );

    if (autoClose) {
      await Future.delayed(autoCloseDuration);
      if (context.mounted) {
        safeClose();
      }
    }
  }

  static Future<void> showErrorDialog({
    required BuildContext ctx,
    String title = 'Error',
    String? message,
    String buttonText = 'Try again',
    bool autoClose = false,
    Duration autoCloseDuration = const Duration(seconds: 2),
    VoidCallback? onClose,
    bool hideCloseButton = false,
    String? imagePath,
    VoidCallback? onButtonPressed,
    String? disableButtonText,
    bool isDisableButton = false,
    VoidCallback? onDisableButtonPressed,
  }) async {
    bool dismissed = false;
    void safeClose() {
      if (dismissed) return;
      dismissed = true;
      if (Navigator.of(ctx).canPop()) {
        Navigator.of(ctx).pop();
      }
      if (onClose != null) onClose();
    }

    // Start the dialog and keep its future
    final dialogFuture = showDialog(
      context: ctx,
      barrierDismissible: !autoClose,
      builder: (context) => statusDialogs(
        context: context,
        isSuccess: true,
        imagePath: imagePath,
        title: title,
        message: message ?? 'Purchase done! Instant alerts for matches\nand profile views are now enabled.',
        buttonText: buttonText, // Always show button now
        onButtonPressed: onButtonPressed ?? safeClose,
        onClose: safeClose,
        showIcon: true,
        disableButtonText: disableButtonText,
        isDisableButton: isDisableButton,
        onDisableButtonPressed: onDisableButtonPressed,
      ),
    );

    // Schedule auto-close before awaiting the dialog
    if (autoClose) {
      Future.delayed(autoCloseDuration).then((_) {
        if (ctx.mounted && !dismissed) {
          safeClose();
        }
      });
    }

    // Wait for dialog to close (either by user/button/autoClose)
    await dialogFuture;
  }

  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    String? message,
    String? buttonText =' Enable Now',
    bool autoClose = false,
    Duration autoCloseDuration = const Duration(seconds: 2),
    VoidCallback? onClose,
    VoidCallback? onButtonPressed,
    String? imagePath = AppImages.alertStatus,
    String? disableButtonText ='Remind Me Later',
    bool isDisableButton = true,
    VoidCallback? onDisableButtonPressed,
  }) async {
    bool dismissed = false;
    void safeClose() {
      if (dismissed) return;
      dismissed = true;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (onClose != null) onClose();
    }
    await showDialog(
      context: context,
      barrierDismissible: !autoClose,
      builder: (context) => statusDialogs(
        context: context,
        isSuccess: true,
        imagePath: imagePath,
        title: title,
        message: message ?? 'Purchase done! Instant alerts for matches\nand profile views are now enabled.',
        buttonText: buttonText, // Always show button now
        onButtonPressed: onButtonPressed ?? safeClose,
        onClose: safeClose,
        showIcon: true,
        disableButtonText: disableButtonText,
        isDisableButton: isDisableButton,
        onDisableButtonPressed: onDisableButtonPressed,
      ),
    );
    if (onClose != null) onClose();
    if (autoClose) {
      await Future.delayed(autoCloseDuration);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }


  static Widget statusDialogs({
    required BuildContext context,
    required bool isSuccess,
    required String title,
    required String message,
    String? buttonText,
    String? imagePath,
    VoidCallback? onButtonPressed,
    VoidCallback? onClose,
    bool showIcon = true,
    String? disableButtonText,
    bool isDisableButton = false,
    VoidCallback? onDisableButtonPressed,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            ShowImage(
              imagePath: imagePath ??AppImages.successfulStatus,
              width: 80,
              height: 80,
            ),
            Text(
              title,
              maxLines: 1,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
              style: TextStyle(
                fontSize: TextSize.font20(context),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondaryLight,
              ),
            ),
            if (buttonText != null) ...[
              PrimaryButtons(
                buttonStyle: ButtonsStyle.activePrimaryButton,
                onTap: onButtonPressed ?? () {},
                title: buttonText,
              ),
              if(isDisableButton)
              Column(
                children: [
                  const SizedBox(height: 8),
                  PrimaryButtons(
                    buttonStyle: ButtonsStyle.disableButton,
                    onTap: onDisableButtonPressed ?? () {},
                    title: disableButtonText,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _infoDialog({
    required String title,
    required String message,
    required String? buttonText,
    required VoidCallback onClose,
    VoidCallback? onButtonPressed,
  }) {
    const accent = Color(0xFF4A8CFF);
    const accentDark = Color(0xFF1A2E5A);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: accent.withAlpha((0.45 * 255).round()), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 24,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accent.withAlpha((0.85 * 255).round()),
                        accentDark.withAlpha((0.9 * 255).round()),
                        Colors.transparent,
                      ],
                      stops: const [0.2, 0.6, 1],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.info, color: Colors.white, size: 26),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withAlpha((0.7 * 255).round()),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                if (buttonText != null) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: accent.withAlpha((0.6 * 255).round())),
                        foregroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: onButtonPressed ?? onClose,
                      child: Text(buttonText),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              icon: const Icon(Icons.close, color: Colors.white, size: 22),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> showAppCloseDiaLog(BuildContext context) async {
    // Show a confirmation dialog when the user tries to close the app
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Don't close
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Close
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return shouldClose ??
        false; // Return false if dialog is dismissed without selection
  }
}
