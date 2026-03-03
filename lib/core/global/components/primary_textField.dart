import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/input_border_style.dart';

class PrimaryTextField extends StatefulWidget {
  const PrimaryTextField({
    super.key,
    this.controller,
    this.hintText,
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
    this.maxLine,
    this.borderRadius,
    this.readOnly,
    required this.onTap,
    this.prefix,
    this.validator,
    this.showPassIcon,
    this.forgotPass,
    this.forgotPassOntap,
    this.datePicker,
    this.noPrefix,
    this.contentPadding,
    this.enabled,
    this.hideHeadline,
  });

  final TextEditingController? controller;
  final dynamic errorText;
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
  final VoidCallback? forgotPassOntap;
  final bool? noPrefix;
  final bool? forgotPass;
  final void Function(String)? onChanged;
  final String? Function(String? value)? validator;
  final int? minLine;
  final int? maxLine;
  final double? borderRadius;
  final bool? readOnly;
  final Widget? prefix;
  final bool? showPassIcon;

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool viewPassword = true;

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
        _forgotPassField(screenHeight)
      ],
    );
  }

  Widget _inputField(double screenWidth, double screenHeight) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      minLines: widget.minLine ?? 1,
      maxLines: widget.maxLine ?? 1,
      obscureText: widget.showPassIcon != null
          ? viewPassword
          : widget.obscureText ?? false,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly ?? false,
      onTap: () => widget.onTap != null ? widget.onTap!() : null,
      onChanged: (value) =>
          widget.onChanged != null ? widget.onChanged!(value) : null,
      validator: widget.validator,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: TextStyle(
        color: widget.textColor ?? Colors.black,
        fontSize: TextSize.font16(context),
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefix: widget.noPrefix != null && true
            ? Container(
                color: Colors.green,
                child: const Padding(padding: EdgeInsets.only(left: 15)))
            : null,
        prefixIcon: widget.noPrefix != null && true
            ? null
            : widget.prefix ?? _prefixIcon(screenWidth),
        border: InputBorderStyle.border(
            widget.maxLine != null ? 60 / widget.maxLine! : 60,
            borderColor: widget.borderColor),
        focusedBorder: InputBorderStyle.focusedBorder(
            widget.maxLine != null ? 60 / widget.maxLine! : 60),
        enabledBorder: (widget.controller?.text ?? '').isNotEmpty
            ? InputBorderStyle.validBorder(
                widget.maxLine != null ? 60 / widget.maxLine! : 60,
                borderColor: widget.borderColor)
            : InputBorderStyle.border(
                widget.maxLine != null ? 60 / widget.maxLine! : 60),
        focusedErrorBorder: InputBorderStyle.focusedErrorBorder(
            widget.maxLine != null ? 60 / widget.maxLine! : 60),
        errorBorder: InputBorderStyle.errorBorder(
            widget.maxLine != null ? 60 / widget.maxLine! : 60),
        hintStyle: TextStyle(
          color: const Color(0xFF818092),
          fontSize: TextSize.font16(context),
          fontWeight: FontWeight.w300,
        ),
        hintText: widget.hintText ?? 'Your Username',
        errorText: widget.errorText == "" ? null : widget.errorText,
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
            : widget.suffix,
        suffixIconConstraints: BoxConstraints(
          minHeight: screenHeight * 0.025,
        ),
        prefixIconConstraints: BoxConstraints(
          minHeight: screenHeight * 0.025,
        ),
        fillColor: widget.fillColor,
        filled: widget.fillColor != null,
      ),
    );
  }

  Widget _headLine() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.headLine != null)
              Text(
                widget.headLine!,
                style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ],
    );
  }

  Widget _prefixIcon(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.025,
        right: screenWidth * 0.02,
      ),
      child: const Icon(Icons.add),
      // child: SvgPicture.asset(
      //   'svgs/${widget.icon ?? 'user-circle'}.svg',
      //   colorFilter: ColorFilter.mode(_prefixColor(), BlendMode.srcIn),
      //   height: screenHeight * 0.03,
      //   width: screenWidth * 0.03,
      // ),
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

  Widget _forgotPassField(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.01),
        if (widget.forgotPass != null && true)
          Row(
            children: [
              GestureDetector(
                onTap: widget.forgotPassOntap,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: const Color(0xFF818092),
                            fontSize: TextSize.font14(context),
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
