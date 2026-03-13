import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

class CountdownTimer extends StatefulWidget {

  const CountdownTimer({
    super.key,
    required this.initialHours,
    required this.initialMinutes,
    required this.initialSeconds,
    this.onTimerComplete,
    this.updateInterval = const Duration(seconds: 1),
    this.numberStyle,
    this.unitStyle,
  });

  final int initialHours;
  final int initialMinutes;
  final int initialSeconds;
  final Function? onTimerComplete;
  final Duration? updateInterval;
  final TextStyle? numberStyle;
  final TextStyle? unitStyle;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _hours;
  late int _minutes;
  late int _seconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _hours = widget.initialHours;
    _minutes = widget.initialMinutes;
    _seconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.updateInterval!, (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            if (_hours > 0) {
              _hours--;
              _minutes = 59;
              _seconds = 59;
            } else {
              // Timer completed
              _timer.cancel();
              if (widget.onTimerComplete != null) {
                widget.onTimerComplete!();
              }
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final defaultNumberStyle = TextStyle(
      color: AppColors.primary,
      fontSize: TextSize.font24(context),
      fontWeight: FontWeight.w700,
    );

    final defaultUnitStyle = TextStyle(
      color: AppColors.primary,
      fontSize: TextSize.font24(context),
      fontWeight: FontWeight.w400,
    );

    return Row(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hours
        _buildTimeUnit(
          _formatNumber(_hours),
          'h',
          numberStyle: widget.numberStyle ?? defaultNumberStyle,
          unitStyle: widget.unitStyle ?? defaultUnitStyle,
        ),

        // Minutes
        _buildTimeUnit(
          _formatNumber(_minutes),
          'm',
          numberStyle: widget.numberStyle ?? defaultNumberStyle,
          unitStyle: widget.unitStyle ?? defaultUnitStyle,
        ),

        // Seconds
        _buildTimeUnit(
          _formatNumber(_seconds),
          's',
          numberStyle: widget.numberStyle ?? defaultNumberStyle,
          unitStyle: widget.unitStyle ?? defaultUnitStyle,
        ),
      ],
    );
  }

  Widget _buildTimeUnit(String value, String unit,
      {required TextStyle numberStyle, required TextStyle unitStyle}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: numberStyle,
          ),
          Text(
            unit,
            style: unitStyle,
          ),
        ],
      ),
    );
  }
}