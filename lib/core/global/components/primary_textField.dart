import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/input_border_style.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class PrimaryTextField extends StatefulWidget {
  const PrimaryTextField({
    super.key,
    this.controller,
    this.hintText,
    this.headLineInfoIcon,
    this.icon,
    this.textColor,
    this.borderColor,
    this.fillColor,
    this.suffix,
    this.headLine,
    this.keyboardType,
    this.obscureText,
    this.errorText,
    this.onChanged,
    this.minLine,
    this.isCountryDropdown = false,
    this.maxLine,
    this.borderRadius = 10,
    this.readOnly,
    required this.onTap,
    this.prefixIcon,
    this.validator,
    this.showPassIcon,
    this.datePicker,
    this.noPrefix,
    this.inputFormatters,
    this.contentPadding,
    this.enabled,
    this.hideHeadline,
    this.length,
    this.isRequired = false,
    this.isOptional = false,
  });

  final TextEditingController? controller;
  final String? errorText;
  final bool isCountryDropdown;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool? hideHeadline;
  final String? hintText;
  final String? headLine;
  final String? icon;
  final Color? textColor;
  final Color? borderColor;
  final Color? fillColor;
  final Widget? suffix;
  final bool? enabled;
  final bool? datePicker;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? noPrefix;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final String? Function(String? value)? validator;
  final int? minLine;
  final int? maxLine;
  final double? borderRadius;
  final bool? readOnly;
  final Widget? prefixIcon;
  final bool? showPassIcon;
  final bool? headLineInfoIcon;
  final int? length;
  final bool? isRequired;
  final bool? isOptional;

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool viewPassword = true;
  TextEditingController? _internalController;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        widget.hideHeadline != null && true
            ? const SizedBox.shrink()
            : _headLine(),
        _inputField(screenWidth, screenHeight),
      ],
    );
  }

  Widget _inputField(double screenWidth, double screenHeight) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller ?? _internalController,
      minLines: widget.minLine ?? 1,
      maxLines: widget.maxLine ?? 1,
      obscureText: widget.showPassIcon != null
          ? viewPassword
          : widget.obscureText ?? false,
      keyboardType: widget.keyboardType,
      maxLength: widget.length,
      inputFormatters: widget.inputFormatters,
      readOnly: widget.datePicker == true ? true : (widget.readOnly ?? false),
      onTap: () async {
        if (widget.datePicker == true) {
          if (widget.controller == null && _internalController == null) {
            _internalController = TextEditingController();
            setState(() {});
          }

          final now = DateTime.now();
          // Date arithmetic is calendar-based so the boundary remains correct
          // around leap years. A duration of 18 * 365 days would allow some
          // under-18 dates to slip through.
          final latestAllowedDate = DateTime(now.year - 18, now.month, now.day);
          final earliestAllowedDate = DateTime(1950);
          DateTime selectedDate = latestAllowedDate;

          try {
            final existing =
                widget.controller?.text ?? _internalController?.text ?? '';

            if (existing.isNotEmpty) {
              try {
                selectedDate = DateTime.parse(existing);
              } catch (_) {
                selectedDate = DateFormat('yyyy-MM-dd').parseLoose(existing);
              }
            }
          } catch (_) {}

          // A DOB may have been saved before the adult-age rule was added.
          // Keep the picker valid and do not let that value be re-selected.
          if (selectedDate.isAfter(latestAllowedDate)) {
            selectedDate = latestAllowedDate;
          } else if (selectedDate.isBefore(earliestAllowedDate)) {
            selectedDate = earliestAllowedDate;
          }

          await showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return Container(
                height: 320,
                decoration: const BoxDecoration(
                  color: Color(0xFF21161A),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              'Cancel'.localized(context),
                              style: const TextStyle(
                                color: Color(0xFFB9ADB1),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            'Select Date'.localized(context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: TextSize.font18(context),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              'Done'.localized(context),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              final formatted =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);

                              if (widget.controller != null) {
                                widget.controller!.text = formatted;
                              } else if (_internalController != null) {
                                _internalController!.text = formatted;
                              }

                              if (widget.onChanged != null) {
                                widget.onChanged!(formatted);
                              }

                              setState(() {});

                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          brightness: Brightness.dark,
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: TextSize.font18(context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          primaryColor: AppColors.primary,
                          applyThemeToAll: true,
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: selectedDate,
                          minimumDate: earliestAllowedDate,
                          maximumDate: latestAllowedDate,
                          use24hFormat: true,
                          onDateTimeChanged: (DateTime value) {
                            selectedDate = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          if (widget.onTap != null) {
            widget.onTap!();
          }

          return;
        }

        if (widget.onTap != null) widget.onTap!();
      },
      onChanged: (value) =>
          widget.onChanged != null ? widget.onChanged!(value) : null,
      validator: widget.validator,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: TextStyle(
        color: widget.textColor ?? AppColors.textPrimaryLight,
        fontSize: TextSize.font14(context),
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        isDense: true,
        counterText: '',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefix: _getPrefix(),
        prefixIcon: _getPrefixIcon(),
        border: InputBorderStyle.border(widget.borderRadius ?? 6,
            borderColor: widget.borderColor),
        focusedBorder: InputBorderStyle.focusedBorder(widget.borderRadius ?? 6),
        enabledBorder:
            (widget.controller?.text ?? _internalController?.text ?? '')
                    .isNotEmpty
                ? InputBorderStyle.validBorder(widget.borderRadius ?? 6,
                    borderColor: widget.borderColor)
                : InputBorderStyle.border(widget.borderRadius ?? 6),
        focusedErrorBorder:
            InputBorderStyle.focusedErrorBorder(widget.borderRadius ?? 6),
        errorBorder: InputBorderStyle.errorBorder(widget.borderRadius ?? 6),
        hintStyle: TextStyle(
          color: const Color(0xFFA3A3A3),
          fontSize: TextSize.font14(context),
          fontWeight: FontWeight.w400,
        ),
        hintText: (widget.hintText ?? 'Your Username').localized(context),
        errorText: widget.errorText == '' ? null : widget.errorText,
        errorMaxLines: 2,
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: TextSize.font12(context),
        ),
        disabledBorder: InputBorderStyle.disabledBorder(60),
        suffixIcon: widget.showPassIcon != null
            ? Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.025),
                child: _suffixIcon(screenWidth),
              )
            : Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.025),
                child: widget.suffix,
              ),
        suffixIconConstraints: BoxConstraints(
          minHeight: screenHeight * 0.025,
        ),
        prefixIconConstraints: BoxConstraints(
          minHeight: screenHeight * 0.025,
        ),
        fillColor: widget.fillColor ?? Colors.white,
        filled: true,
      ),
    );
  }

  Widget? _getPrefixIcon() {
    if (widget.noPrefix != null && true) {
      return const SizedBox.shrink();
    } else {
      if (widget.isCountryDropdown == true) {
        return Container(
          width: 96,
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: AppColors.inputBorderColor,
                width: 1,
              ),
            ),
          ),
          child: widget.prefixIcon,
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 4),
          child: widget.prefixIcon,
        );
      }
    }
  }

  Widget? _getPrefix() {
    if (widget.isCountryDropdown == true) {
      return Container(
        color: Colors.green,
        child: const Padding(
          padding: EdgeInsets.only(left: 15),
        ),
      );
    } else if (widget.noPrefix != null && true) {
      return Container(
        color: Colors.green,
        child: const Padding(
          padding: EdgeInsets.only(left: 15),
        ),
      );
    } else {
      return null;
    }
  }

  Widget _headLine() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 4,
          children: [
            if (widget.headLine != null)
              Text(
                widget.headLine!.localized(context),
                style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondaryLight),
              ),
            if (widget.headLineInfoIcon == true && widget.headLine != null)
              Icon(Icons.info,
                  size: TextSize.font13(context), color: AppColors.disableText),
            if (widget.isRequired == true && widget.headLine != null)
              Text(
                '*',
                style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent),
              ),
            if (widget.isOptional == true && widget.headLine != null)
              Text(
                '(optional)'.localized(context),
                style: TextStyle(
                    fontSize: TextSize.font10(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.hintTextColor),
              ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _suffixIcon(double screenWidth) {
    return GestureDetector(
        onTap: () {
          viewPassword = !viewPassword;
          setState(() {});
        },
        child: Icon(
          viewPassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: viewPassword
              ? AppColors.inputBorderColor
              : AppColors.competeBorderColor,
          size: screenWidth * 0.05,
        ));
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }
}
