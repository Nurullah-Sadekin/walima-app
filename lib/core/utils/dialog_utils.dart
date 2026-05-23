import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class DialogUtils {
  static Future<void> showSuccessDialog({
    required BuildContext context,
    String title = 'Success',
    String? message,
    String buttonText = 'OK',
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
    VoidCallback? dialogClose;

    // Start the dialog and keep its future
    final dialogFuture = showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: !autoClose,
      builder: (dialogContext) {
        void localSafeClose() {
          if (dismissed) return;
          dismissed = true;
          if (Navigator.of(dialogContext, rootNavigator: true).canPop())
            Navigator.of(dialogContext, rootNavigator: true).pop();
          if (onClose != null) onClose();
        }

        dialogClose = localSafeClose;

        return statusDialogs(
          context: dialogContext,
          isSuccess: true,
          imagePath: imagePath,
          title: title,
          message: message ??
              'Purchase done! Instant alerts for matches\nand profile views are now enabled.',
          buttonText: buttonText,
          onButtonPressed: onButtonPressed ?? localSafeClose,
          onClose: localSafeClose,
          showIcon: true,
          disableButtonText: disableButtonText,
          isDisableButton: isDisableButton,
          onDisableButtonPressed: onDisableButtonPressed,
        );
      },
    );

    if (autoClose) {
      Future.delayed(autoCloseDuration).then((_) {
        if (!dismissed) dialogClose?.call();
      });
    }

    await dialogFuture;
  }

  static Future<void> showErrorDialog({
    required BuildContext context,
    String title = 'Error',
    String? message,
    String buttonText = 'Try again',
    bool autoClose = false,
    Duration autoCloseDuration = const Duration(seconds: 2),
    VoidCallback? onClose,
    bool hideCloseButton = false,
    String? imagePath = AppImages.errorStatus,
    VoidCallback? onButtonPressed,
    String? disableButtonText,
    bool isDisableButton = false,
    VoidCallback? onDisableButtonPressed,
  }) async {
    bool dismissed = false;
    VoidCallback? dialogClose;

    // Start the dialog and keep its future
    final dialogFuture = showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: !autoClose,
      builder: (dialogContext) {
        void localSafeClose() {
          if (dismissed) return;
          dismissed = true;
          if (Navigator.of(dialogContext, rootNavigator: true).canPop())
            Navigator.of(dialogContext, rootNavigator: true).pop();
          if (onClose != null) onClose();
        }

        dialogClose = localSafeClose;

        return statusDialogs(
          context: dialogContext,
          isSuccess: true,
          imagePath: imagePath,
          title: title,
          message: message ??
              'Purchase done! Instant alerts for matches\nand profile views are now enabled.',
          buttonText: buttonText, // Always show button now
          onButtonPressed: onButtonPressed ?? localSafeClose,
          onClose: localSafeClose,
          showIcon: true,
          disableButtonText: disableButtonText,
          isDisableButton: isDisableButton,
          onDisableButtonPressed: onDisableButtonPressed,
        );
      },
    );

    // Schedule auto-close before awaiting the dialog
    if (autoClose) {
      Future.delayed(autoCloseDuration).then((_) {
        if (!dismissed) dialogClose?.call();
      });
    }

    // Wait for dialog to close (either by user/button/autoClose)
    await dialogFuture;
  }

  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    String? message,
    String? buttonText = ' Enable Now',
    bool autoClose = false,
    Duration autoCloseDuration = const Duration(seconds: 2),
    VoidCallback? onClose,
    VoidCallback? onButtonPressed,
    String? imagePath = AppImages.alertStatus,
    String? disableButtonText = 'Remind Me Later',
    bool isDisableButton = true,
    VoidCallback? onDisableButtonPressed,
  }) async {
    bool dismissed = false;
    VoidCallback? dialogClose;

    // Start the dialog and keep its future
    final dialogFuture = showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: !autoClose,
      builder: (dialogContext) {
        void localSafeClose() {
          if (dismissed) return;
          dismissed = true;
          if (Navigator.of(dialogContext, rootNavigator: true).canPop())
            Navigator.of(dialogContext, rootNavigator: true).pop();
          if (onClose != null) onClose();
        }

        dialogClose = localSafeClose;

        return statusDialogs(
          context: dialogContext,
          isSuccess: true,
          imagePath: imagePath,
          title: title,
          message: message ??
              'Purchase done! Instant alerts for matches\nand profile views are now enabled.',
          buttonText: buttonText, // Always show button now
          onButtonPressed: onButtonPressed ?? localSafeClose,
          onClose: localSafeClose,
          showIcon: true,
          disableButtonText: disableButtonText,
          isDisableButton: isDisableButton,
          onDisableButtonPressed: onDisableButtonPressed,
        );
      },
    );

    // Schedule auto-close before awaiting the dialog
    if (autoClose) {
      Future.delayed(autoCloseDuration).then((_) {
        if (!dismissed) dialogClose?.call();
      });
    }

    // Wait for dialog to close (either by user/button/autoClose)
    await dialogFuture;
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
          children: [
            ShowImage(
              imagePath: imagePath ?? AppImages.successfulStatus,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 20),
            Text(
              title.localized(context),
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
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 20),
            if (buttonText != null) ...[
              PrimaryButtons(
                buttonStyle: ButtonsStyle.activePrimaryButton,
                onTap: onButtonPressed ?? () {},
                title: buttonText.localized(context),
              ),
              if (isDisableButton)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    PrimaryButtons(
                      buttonStyle: ButtonsStyle.disableButton,
                      onTap: onDisableButtonPressed ?? () {},
                      title: disableButtonText?.localized(context),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  static Future<bool> showAppCloseDiaLog(BuildContext context) async {
    // Show a confirmation dialog when the user tries to close the app
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'.localized(context)),
        content:
            Text('Are you sure you want to exit the app?'.localized(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Don't close
            child: Text('Cancel'.localized(context)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Close
            child: Text('Exit'.localized(context)),
          ),
        ],
      ),
    );
    return shouldClose ??
        false; // Return false if dialog is dismissed without selection
  }

  static Future<void> show(
      {required BuildContext context, required Widget child}) async {
    await showDialog(
      context: context,
      builder: (context) => child,
    );
  }

  static Future<void> showFullScreenImage({
    required BuildContext context,
    required String imagePath,
    bool barrierDismissible = true,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black.withOpacity(0.8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ShowImage(
              imagePath: imagePath,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.contain,
              radius: BorderRadius.zero,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
