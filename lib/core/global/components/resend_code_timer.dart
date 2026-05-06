import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';

/// Reusable "Resend Code" widget with a countdown timer.
///
/// Disabled while the countdown is running (shows `Resend Code in M:SS`).
/// After expiry the text becomes tappable. Tapping invokes [onResend] and
/// restarts the timer.
class ResendCodeTimer extends StatefulWidget {
  const ResendCodeTimer({
    super.key,
    required this.onResend,
    this.duration = const Duration(seconds: 60),
    this.autoStart = true,
  });

  final Future<void> Function() onResend;
  final Duration duration;
  final bool autoStart;

  @override
  State<ResendCodeTimer> createState() => _ResendCodeTimerState();
}

class _ResendCodeTimerState extends State<ResendCodeTimer> {
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = widget.duration.inSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        t.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _handleTap() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onResend();
    } finally {
      if (!mounted) return;
      setState(() => _busy = false);
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _secondsRemaining == 0 && !_busy;
    return InkWell(
      onTap: isActive ? _handleTap : null,
      child: Text(
        isActive ? 'Resend Code' : 'Resend Code in $_formattedTime',
        style: TextStyle(
          fontSize: TextSize.font14(context),
          color: isActive
              ? AppColors.textPrimaryLight
              : AppColors.textSecondaryLight,
          fontWeight: FontWeight.w500,
          decoration: isActive ? TextDecoration.underline : null,
          decorationColor: AppColors.textPrimaryLight,
          decorationThickness: 1,
        ),
      ),
    );
  }
}
