import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> showSuccessDialog({
    required BuildContext context,
    String title = 'Success',
    String? message,
    String buttonText = 'View order',
    bool autoClose = true,
    Duration autoCloseDuration = const Duration(seconds: 2),
    VoidCallback? onClose,
    VoidCallback? onButtonPressed,
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
      builder: (context) => statusDialog(
        context: context,
        isSuccess: true,
        title: title,
        message: message ?? 'Your payment went through.\nYou’ll receive a confirmation shortly.',
        buttonText: autoClose ? null : buttonText,
        onButtonPressed: onButtonPressed ?? safeClose,
        onClose: safeClose,
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
    VoidCallback? onButtonPressed,
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
      builder: (context) => statusDialog(
        isSuccess: false,
        hideButton: hideCloseButton,
        context: context,
        title: title,
        message: message ?? '',
        buttonText: autoClose ? null : buttonText,
        onButtonPressed: onButtonPressed ?? safeClose,
        onClose: safeClose,
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
    String? buttonText,
    bool autoClose = false,
    Duration autoCloseDuration = const Duration(seconds: 2),
    VoidCallback? onClose,
    VoidCallback? onButtonPressed,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: !autoClose,
      builder: (context) => _infoDialog(
        title: title,
        message: message ?? '',
        buttonText: autoClose ? null : buttonText,
        onClose: () {
          Navigator.of(context).pop();
          if (onClose != null) onClose();
        },
        onButtonPressed: onButtonPressed,
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

  static Widget statusDialog({
    required bool isSuccess,
    required String title,
    required String message,
    required String? buttonText,
    required VoidCallback onButtonPressed,
    required VoidCallback onClose,
    required BuildContext context,
    bool hideButton = false,
  }) {
    final accent =
    isSuccess ? const Color(0xFF2EE34B) : const Color(0xFFE13B3B);
    final accentDark =
    isSuccess ? const Color(0xFF0B4F16) : const Color(0xFF5B1414);
    final icon = isSuccess ? Icons.check : Icons.close;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withOpacity(0.5), width: 1),
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
                        accent.withOpacity(0.9),
                        accentDark.withOpacity(0.9),
                        Colors.transparent,
                      ],
                      stops: const [0.2, 0.6, 1],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.black, size: 26),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                if (buttonText != null) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: accent.withOpacity(0.6)),
                        foregroundColor: isSuccess ? accent : Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: onButtonPressed,
                      child: Text(buttonText),
                    ),
                  ),
                ],
              ],
            ),
          ),
          hideButton
              ? const SizedBox.shrink()
              :
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
              border: Border.all(color: accent.withOpacity(0.45), width: 1),
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
                        accent.withOpacity(0.85),
                        accentDark.withOpacity(0.9),
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
                    color: Colors.white.withOpacity(0.7),
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
                        side: BorderSide(color: accent.withOpacity(0.6)),
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
}
