import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/input_border_style.dart';
import 'package:intl/intl.dart';

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
    required this.errorText,
    this.onChanged,
    this.minLine,
    this.isCountryDropdown = false,
    this.maxLine,
    this.borderRadius,
    this.readOnly,
    required this.onTap,
    this.prefixIcon,
    this.validator,
    this.showPassIcon,
    this.datePicker,
    this.noPrefix,
    this.contentPadding,
    this.enabled,
    this.hideHeadline,
  });

  final TextEditingController? controller;
  final dynamic errorText;
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
  final void Function(String)? onChanged;
  final String? Function(String? value)? validator;
  final int? minLine;
  final int? maxLine;
  final double? borderRadius;
  final bool? readOnly;
  final Widget? prefixIcon;
  final bool? showPassIcon;
  final bool? headLineInfoIcon;

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
      maxLength: widget.isCountryDropdown ? 10 : null,
      readOnly: widget.datePicker == true ? true : (widget.readOnly ?? false),
      onTap: () async {
        if (widget.datePicker == true) {
          if (widget.controller == null && _internalController == null) {
            _internalController = TextEditingController();

            setState(() {});
          }
          //initial date will be 18 years ago from today
          DateTime initialDate =
              DateTime.now().subtract(const Duration(days: 365 * 19));
          try {
            final existing =
                widget.controller?.text ?? _internalController?.text ?? '';
            if (existing.isNotEmpty) {
              try {
                initialDate = DateTime.parse(existing);
              } catch (_) {
                initialDate = DateFormat('yyyy-MM-dd').parseLoose(existing);
              }
            }
          } catch (_) {}

          final picked = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );

          if (picked != null) {
            final formatted = DateFormat('yyyy-MM-dd').format(picked);
            if (widget.controller != null) {
              widget.controller!.text = formatted;
            } else if (_internalController != null) {
              _internalController!.text = formatted;
            }
            if (widget.onChanged != null) widget.onChanged!(formatted);
            setState(() {});
          }

          if (widget.onTap != null) widget.onTap!();
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefix: _getPrefix(),
        prefixIcon: _getPrefixIcon(),
        border: InputBorderStyle.border(6, borderColor: widget.borderColor),
        focusedBorder: InputBorderStyle.focusedBorder(6),
        enabledBorder: (widget.controller?.text ??
                    _internalController?.text ??
                    '')
                .isNotEmpty
            ? InputBorderStyle.validBorder(6, borderColor: widget.borderColor)
            : InputBorderStyle.border(6),
        focusedErrorBorder: InputBorderStyle.focusedErrorBorder(6),
        errorBorder: InputBorderStyle.errorBorder(6),
        hintStyle: TextStyle(
          color: const Color(0xFFA3A3A3),
          fontSize: TextSize.font14(context),
          fontWeight: FontWeight.w400,
        ),
        hintText: widget.hintText ?? 'Your Username',
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
          width: 120,
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
          child: const Padding(padding: EdgeInsets.only(left: 15)));
    } else if (widget.noPrefix != null && true) {
      return Container(
          color: Colors.green,
          child: const Padding(padding: EdgeInsets.only(left: 15)));
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
                widget.headLine!,
                style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF171717)),
              ),
            if (widget.headLineInfoIcon == true && widget.headLine != null)
              Icon(Icons.info,
                  size: TextSize.font13(context), color: AppColors.disableText),
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
